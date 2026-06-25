/// Représente l'état d'avancement d'un ticket dans la file d'attente.
enum TicketStatus {
  waiting, // En attente dans la file
  called,  // Appelé au guichet
  done,    // Traitement terminé
}

/// Modèle de données représentant un ticket de file d'attente virtuelle.
///
/// Utilisé par [FileManager] pour la logique métier,
/// et sérialisable via [toMap]/[fromMap] pour le stockage local (Personne 3).
class Ticket {
  final String id;
  final String service;          // ex: "Carte d'identité", "Acte de naissance"
  final int numero;              // Numéro du ticket (ex: 42)
  final DateTime heureCreation;
  final int position;            // Position dans la file (0 = c'est son tour)
  final int tempsAttenteEstime;  // Temps d'attente estimé, en minutes
  final TicketStatus status;     // État actuel du ticket

  Ticket({
    required this.id,
    required this.service,
    required this.numero,
    required this.heureCreation,
    required this.position,
    required this.tempsAttenteEstime,
    this.status = TicketStatus.waiting, // Par défaut : en attente
  });

  /// Crée une copie du ticket avec certaines valeurs mises à jour.
  /// Utile quand la file avance (position, temps et statut peuvent changer).
  Ticket copyWith({
    int? position,
    int? tempsAttenteEstime,
    TicketStatus? status,
  }) {
    return Ticket(
      id: id,
      service: service,
      numero: numero,
      heureCreation: heureCreation,
      position: position ?? this.position,
      tempsAttenteEstime: tempsAttenteEstime ?? this.tempsAttenteEstime,
      status: status ?? this.status,
    );
  }

  /// Sérialise le ticket en Map pour la sauvegarde locale (Personne 3).
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'service': service,
      'numero': numero,
      'heureCreation': heureCreation.toIso8601String(),
      'position': position,
      'tempsAttenteEstime': tempsAttenteEstime,
      'status': status.name, // ex: "waiting", "called", "done"
    };
  }

  /// Recrée un ticket depuis une Map (lecture depuis la base locale).
  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      id: map['id'],
      service: map['service'],
      numero: map['numero'],
      heureCreation: DateTime.parse(map['heureCreation']),
      position: map['position'],
      tempsAttenteEstime: map['tempsAttenteEstime'],
      status: TicketStatus.values.byName(map['status']),
    );
  }
}