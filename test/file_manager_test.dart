import 'package:flutter_test/flutter_test.dart';
import 'package:mon_app/models/ticket.dart';
import 'package:mon_app/services/file_manager.dart';

void main() {
  // Crée un FileManager frais avant chaque test
  late FileManager fileManager;

  setUp(() {
    fileManager = FileManager();
  });

  tearDown(() {
    fileManager.dispose();
  });

  // ─── addTicket ───────────────────────────────────────────────────────────────

  group('addTicket', () {
    test('crée un ticket avec les bonnes valeurs', () {
      final ticket = fileManager.addTicket("Passeport");

      expect(ticket.service, equals("Passeport"));
      expect(ticket.numero, equals(1));       // premier ticket → numéro 1
      expect(ticket.position, equals(0));     // seul dans la file → position 0
      expect(ticket.tempsAttenteEstime, equals(0)); // position 0 → 0 min
      expect(ticket.status, equals(TicketStatus.waiting));
      expect(ticket.id, isNotEmpty);
    });

    test('deux tickets ont des positions et numéros corrects', () {
      final t1 = fileManager.addTicket("Passeport");
      final t2 = fileManager.addTicket("Passeport");

      expect(t1.numero, equals(1));
      expect(t1.position, equals(0));
      expect(t1.tempsAttenteEstime, equals(0));  // 0 × 20 min = 0

      expect(t2.numero, equals(2));
      expect(t2.position, equals(1));
      expect(t2.tempsAttenteEstime, equals(20)); // 1 × 20 min = 20
    });

    test('les numéros de tickets sont indépendants par service', () {
      final t1 = fileManager.addTicket("Passeport");
      final t2 = fileManager.addTicket("Acte de naissance");

      expect(t1.numero, equals(1));
      expect(t2.numero, equals(1)); // chaque service repart de 1
    });

    test('lance ArgumentError pour un service inconnu', () {
      expect(
        () => fileManager.addTicket("Service inexistant"),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  // ─── nextTicket ──────────────────────────────────────────────────────────────

  group('nextTicket', () {
    test('retire le premier ticket et recalcule les positions', () {
      fileManager.addTicket("Passeport"); // position 0
      fileManager.addTicket("Passeport"); // position 1
      fileManager.addTicket("Passeport"); // position 2

      final called = fileManager.nextTicket("Passeport");

      // Le ticket appelé est bien le premier
      expect(called, isNotNull);
      expect(called!.numero, equals(1));

      // Les tickets restants ont leurs positions recalculées
      final queue = fileManager.getQueueForService("Passeport");
      expect(queue.length, equals(2));
      expect(queue[0].position, equals(0));
      expect(queue[0].tempsAttenteEstime, equals(0));  // 0 × 20 = 0
      expect(queue[1].position, equals(1));
      expect(queue[1].tempsAttenteEstime, equals(20)); // 1 × 20 = 20
    });

    test('retourne null si la file est vide', () {
      final result = fileManager.nextTicket("Passeport");
      expect(result, isNull);
    });

    test('retourne null si le service n\'existe pas encore', () {
      final result = fileManager.nextTicket("Acte de naissance");
      expect(result, isNull);
    });
  });

  // ─── cancelTicket ────────────────────────────────────────────────────────────

  group('cancelTicket', () {
    test('supprime le bon ticket et recalcule les positions', () {
      fileManager.addTicket("Passeport"); // position 0
      final t2 = fileManager.addTicket("Passeport"); // position 1
      fileManager.addTicket("Passeport"); // position 2

      // Annule le ticket du milieu
      final result = fileManager.cancelTicket(t2.id);
      expect(result, isTrue);

      final queue = fileManager.getQueueForService("Passeport");
      expect(queue.length, equals(2));
      expect(queue[0].position, equals(0));
      expect(queue[1].position, equals(1)); // était 2, recalculé à 1
    });

    test('retourne false pour un id inconnu', () {
      final result = fileManager.cancelTicket("id-qui-nexiste-pas");
      expect(result, isFalse);
    });

    test('fonctionne sur des services différents', () {
      fileManager.addTicket("Passeport");
      final t2 = fileManager.addTicket("Acte de naissance");

      final result = fileManager.cancelTicket(t2.id);
      expect(result, isTrue);
      expect(fileManager.getQueueForService("Acte de naissance"), isEmpty);
      expect(fileManager.getQueueForService("Passeport").length, equals(1));
    });
  });

  // ─── getTicketById ───────────────────────────────────────────────────────────

  group('getTicketById', () {
    test('retrouve le bon ticket', () {
      final t1 = fileManager.addTicket("Passeport");
      final t2 = fileManager.addTicket("Acte de naissance");

      expect(fileManager.getTicketById(t1.id)?.id, equals(t1.id));
      expect(fileManager.getTicketById(t2.id)?.id, equals(t2.id));
    });

    test('retourne null pour un id inconnu', () {
      expect(fileManager.getTicketById("id-inconnu"), isNull);
    });
  });

  // ─── peopleAhead ─────────────────────────────────────────────────────────────

  group('peopleAhead', () {
    test('retourne le bon nombre de personnes devant', () {
      fileManager.addTicket("Passeport"); // position 0 → 0 personne devant
      final t2 = fileManager.addTicket("Passeport"); // position 1 → 1 personne devant
      final t3 = fileManager.addTicket("Passeport"); // position 2 → 2 personnes devant

      expect(fileManager.peopleAhead(t2.id), equals(1));
      expect(fileManager.peopleAhead(t3.id), equals(2));
    });

    test('retourne null pour un id inconnu', () {
      expect(fileManager.peopleAhead("id-inconnu"), isNull);
    });
  });
}