/// Données statiques des services proposés par la mairie.
///
/// Utilisé par [FileManager] pour valider les services et calculer
/// les temps d'attente, et par la Personne 1 pour afficher la liste.
class ServicesData {
  /// Liste des services avec leur temps moyen de traitement (en minutes).
  static const Map<String, int> services = {
    "Carte d'identité": 15,
    "Passeport": 60,
    "Acte de naissance": 5,
    "Acte de mariage": 5,
    "Certificat de domicile": 8,
    "Inscription sur les listes électorales": 10,
    "Légalisation de signature": 5,
  };

  /// Récupère la liste des noms de services (pour affichage UI — Personne 1).
  static List<String> get nomsServices => services.keys.toList();

  /// Récupère le temps moyen de traitement pour un service donné.
  /// Retourne 10 minutes par défaut si le service est inconnu.
  static int tempsMoyenPour(String service) {
    return services[service] ?? 10;
  }

  /// Vérifie qu'un service existe bien dans la liste officielle.
  /// À utiliser dans [FileManager] avant de créer un ticket,
  /// pour éviter les erreurs silencieuses dues à une faute de frappe.
  static bool serviceExiste(String service) => services.containsKey(service);
}