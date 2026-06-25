# Easymairie
Nom du projet:  Easymairie est une application permettant de digitaliser les files d’attente des services municipaux afin d’améliorer l’expérience utilisateur et réduire le temps d’attente physique.elle a été dévéloppé par SICKOUT Lucrèce, MBEANGONE Lutecia, SOUSATTE Claude. Easymairie a comme fonctionnalités la possibilité de prendre un ticket pour le service concerné par notre besoin, de savoir notre position dans la file d'attente, le temps moyen dans tous les services et un code QR à presenter à l'agent de la mairie qui offre un descriptif de notre ticket. Les Technlogies utilisées sont: Flutter, dart,Navigator de flutter, packages  (sharedpreferences pour la persistance des données,qr flutter pour la génération du code QR, http pour l'appel de l'api de la méteo sur api.open-meteo.com,  Google_fonts pour la police des écritures + la modification du thème (sombre ou clair selon le système), un provider pour partager les données sur toutes les pages, consumer qui écoute les changements et reconstruit la partie UI concernées, changenotifier pour que les différentes pages l’écoutent, Uuid pour l’a génération automatique des identifiants des tickets ) pour la gestion d'etat: STATEFULWIDGET
Une Architecture modulaire et pour la collaboration en groupe github avec separation de branches par personne.
Pour lancer l’application il faut taper la commande flutter run dans la terminal puis choisir comment on souhaite l’ouvrir soit sur un navigateur ou sur un émulateur.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
