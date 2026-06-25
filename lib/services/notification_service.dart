import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service de notifications locales.
/// À initialiser au démarrage de l'app dans main.dart.
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Initialise le service de notifications.
  /// À appeler dans main() avant runApp().
  static Future<void> init() async {
    const AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings ios = DarwinInitializationSettings();
    const InitializationSettings settings = InitializationSettings(
      android: android,
      iOS: ios,
    );
    await _plugin.initialize(settings);
  }

  /// Envoie une notification "bientôt ton tour".
  /// Appelé quand la position d'un ticket passe à 2.
  static Future<void> notifierBientotTour(String service, int numero) async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'file_attente',
      'File d\'attente',
      channelDescription: 'Notifications de file d\'attente',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails details = NotificationDetails(
      android: android,
      iOS: DarwinNotificationDetails(),
    );
    await _plugin.show(
      numero,
      '🎯 Bientôt votre tour !',
      'Plus que 2 personnes avant vous pour $service',
      details,
    );
  }
}