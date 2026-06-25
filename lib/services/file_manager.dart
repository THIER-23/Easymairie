import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';
import '../models/ticket.dart';
import '../data/services_data.dart';
import 'notification_service.dart';

/// Gestionnaire de files d'attente virtuelles par service.
///
/// Étend [ChangeNotifier] pour notifier l'UI (Personne 1) à chaque
/// modification de la file via `Consumer<FileManager>` ou `Provider`.
///
/// Un [Timer.periodic] décrémente automatiquement le temps d'attente
/// de chaque ticket toutes les minutes.
class FileManager extends ChangeNotifier {
  /// Générateur d'identifiants uniques pour chaque ticket.
  final Uuid _uuid = const Uuid();

  /// Map service → liste ordonnée de tickets (ordre FIFO).
  final Map<String, List<Ticket>> _queues = {};

  /// Map service → dernier numéro délivré (ne se réinitialise pas si la file se vide).
  final Map<String, int> _lastNumbers = {};

  /// Liste des ids des tickets pris par cet appareil.
  final List<String> _mesTicketIds = [];

  /// Expose les ids des tickets de l'utilisateur en lecture seule.
  List<String> get mesTicketIds => List.unmodifiable(_mesTicketIds);

  /// Retourne tous les tickets actifs de l'utilisateur courant.
  List<Ticket> get mesTickets {
    return _mesTicketIds
        .map((id) => getTicketById(id))
        .whereType<Ticket>()
        .toList();
  }

  /// Timer qui décrémente le temps d'attente de chaque ticket toutes les minutes.
  late final Timer _timer;

  /// Démarre le timer au lancement du FileManager.
  FileManager() {
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      _decrementerTempsAttente();
    });
  }

  /// Décrémente de 1 minute le temps d'attente de tous les tickets en file.
  /// Ne descend jamais en dessous de 0.
  void _decrementerTempsAttente() {
    bool changed = false;
    for (final queue in _queues.values) {
      for (int i = 0; i < queue.length; i++) {
        final tempsActuel = queue[i].tempsAttenteEstime;
        if (tempsActuel > 0) {
          queue[i] = queue[i].copyWith(
            tempsAttenteEstime: tempsActuel - 1,
          );
          changed = true;
        }
      }
    }
    if (changed) notifyListeners();
  }

  /// Expose les files en lecture seule (copies immuables).
  /// La Personne 1 peut lire sans risquer de modifier l'état interne.
  UnmodifiableMapView<String, List<Ticket>> get queues {
  final copied = _queues.map<String, List<Ticket>>(
    (k, v) => MapEntry(k, List<Ticket>.unmodifiable(v)),
  );
  return UnmodifiableMapView(copied);
}

  /// Crée un ticket pour un [service] donné et l'ajoute en fin de file.
  ///
  /// Lance une [ArgumentError] si le service n'existe pas dans [ServicesData].
  /// Retourne le ticket créé.
  Ticket addTicket(String service) {
    // Validation du service via ServicesData (évite les erreurs silencieuses)
    if (!ServicesData.serviceExiste(service)) {
      throw ArgumentError('Service inconnu : "$service". '
          'Vérifiez ServicesData.services pour la liste des services valides.');
    }

    final id = _uuid.v4();
    final nextNumber = (_lastNumbers[service] ?? 0) + 1;
    _lastNumbers[service] = nextNumber;

    final currentQueue = _queues.putIfAbsent(service, () => []);
    final position = currentQueue.length; // 0 = premier de la file
    final estimatedWait = _estimateWaitForPosition(service, position);

    final ticket = Ticket(
      id: id,
      service: service,
      numero: nextNumber,
      heureCreation: DateTime.now(),
      position: position,
      tempsAttenteEstime: estimatedWait,
    );

    currentQueue.add(ticket);
    _mesTicketIds.add(ticket.id); // Mémorise ce ticket comme appartenant à cet appareil
    notifyListeners();
    return ticket;
  }

  /// Appelle le prochain ticket d'un [service] (fait avancer la file).
  ///
  /// Recalcule les positions et temps d'attente de tous les tickets restants.
  /// Retourne le ticket appelé, ou `null` si la file est vide.
  Ticket? nextTicket(String service) {
    final queue = _queues[service];
    if (queue == null || queue.isEmpty) return null;

    final called = queue.removeAt(0);
    // Vérifie si un ticket de l'utilisateur est à position 2
for (final t in queue) {
  if (t.position == 2 && _mesTicketIds.contains(t.id)) {
    NotificationService.notifierBientotTour(t.service, t.numero);
  }
}

    // Recalcule positions et temps estimés pour les tickets restants
    for (int i = 0; i < queue.length; i++) {
      queue[i] = queue[i].copyWith(
        position: i,
        tempsAttenteEstime: _estimateWaitForPosition(service, i),
      );
    }

    notifyListeners();
    return called;
  }

  /// Annule un ticket par son [ticketId] (cherche dans toutes les files).
  ///
  /// Recalcule les positions si le ticket est trouvé et supprimé.
  /// Retourne `true` si supprimé, `false` si introuvable.
  bool cancelTicket(String ticketId) {
    for (final service in _queues.keys) {
      final queue = _queues[service]!;
      final index = queue.indexWhere((t) => t.id == ticketId);
      if (index != -1) {
        queue.removeAt(index);
        _mesTicketIds.remove(ticketId); // Retire aussi de la liste personnelle
        for (int i = 0; i < queue.length; i++) {
          queue[i] = queue[i].copyWith(
            position: i,
            tempsAttenteEstime: _estimateWaitForPosition(service, i),
          );
        }
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  /// Retourne la file complète d'un [service] (copie immuable).
  /// Retourne une liste vide si le service n'a pas encore de file.
  List<Ticket> getQueueForService(String service) {
    final q = _queues[service];
    if (q == null) return const [];
    return List.unmodifiable(q);
  }

  /// Recherche un ticket par son [ticketId] dans toutes les files.
  ///
  /// Utilise [firstWhereOrNull] du package `collection` pour éviter
  /// le crash de `null as Ticket` avec `orElse`.
  /// Retourne `null` si introuvable.
  Ticket? getTicketById(String ticketId) {
    for (final queue in _queues.values) {
      final t = queue.firstWhereOrNull((tk) => tk.id == ticketId);
      if (t != null) return t;
    }
    return null;
  }

  /// Estime le temps d'attente (en minutes) pour un ticket donné par [ticketId].
  /// Retourne `null` si le ticket est introuvable.
  int? estimateWaitForTicket(String ticketId) {
    final ticket = getTicketById(ticketId);
    if (ticket == null) return null;
    return _estimateWaitForPosition(ticket.service, ticket.position);
  }

  /// Retourne le nombre de personnes devant un ticket donné par [ticketId].
  /// Retourne `null` si le ticket est introuvable.
  int? peopleAhead(String ticketId) {
    final ticket = getTicketById(ticketId);
    if (ticket == null) return null;
    return ticket.position;
  }

  /// Remet à zéro la file d'un [service] (utile pour les tests ou l'administration).
  void resetQueue(String service) {
    _queues.remove(service);
    _lastNumbers.remove(service);
    notifyListeners();
  }

  /// Calcule le temps d'attente estimé pour une [position] dans la file d'un [service].
  ///
  /// Formule : position × temps moyen par personne.
  /// position 0 → 0 min (c'est son tour), position 1 → 1 × avg, etc.
  int _estimateWaitForPosition(String service, int position) {
    final avg = ServicesData.tempsMoyenPour(service);
    return position * avg;
  }

  @override
  void dispose() {
    _timer.cancel(); // Arrête le timer proprement pour éviter les fuites mémoire
    super.dispose();
  }
}