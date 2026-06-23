import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ticket.dart';

/// Gère la sauvegarde et le chargement des tickets en local,
/// grâce à SharedPreferences (stockage simple sous forme de texte).
///
/// Comme SharedPreferences ne sait stocker que du texte/nombres/booléens,
/// on transforme la liste de tickets en texte JSON avant de la sauvegarder,
/// puis on la retransforme en liste de Ticket quand on la recharge.
class LocalDbHandler {
  // Clé utilisée pour retrouver les tickets dans le stockage.
  // Toujours la même clé, sinon on ne retrouve pas nos données !
  static const String _cleTickets = 'tickets_sauvegardes';

  /// Sauvegarde la liste complète des tickets.
  /// À appeler chaque fois que la liste change (ajout, mise à jour, suppression).
  static Future<void> sauvegarderTickets(List<Ticket> tickets) async {
    final prefs = await SharedPreferences.getInstance();

    // On transforme chaque Ticket en Map, puis toute la liste en texte JSON
    final List<Map<String, dynamic>> listeMaps =
        tickets.map((ticket) => ticket.toMap()).toList();
    final String jsonString = jsonEncode(listeMaps);

    await prefs.setString(_cleTickets, jsonString);
  }

  /// Recharge la liste des tickets sauvegardés.
  /// Renvoie une liste vide si aucun ticket n'a encore été sauvegardé.
  static Future<List<Ticket>> chargerTickets() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_cleTickets);

    // Rien n'a encore été sauvegardé
    if (jsonString == null) {
      return [];
    }

    // On retransforme le texte JSON en liste de Map, puis en liste de Ticket
    final List<dynamic> listeMaps = jsonDecode(jsonString);
    return listeMaps
        .map((map) => Ticket.fromMap(map as Map<String, dynamic>))
        .toList();
  }

  /// Supprime tous les tickets sauvegardés.
  /// Utile par exemple pour réinitialiser la file en fin de journée.
  static Future<void> effacerTickets() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cleTickets);
  }
}