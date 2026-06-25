# Easymairie
Nom du projet:  Easymairie est une application permettant de digitaliser les files d’attente des services municipaux afin d’améliorer l’expérience utilisateur et réduire le temps d’attente physique.elle a été dévéloppé par SICKOUT Lucrèce, MBEANGONE Lutecia, SOUSATTE Claude. Easymairie a comme fonctionnalités la possibilité de prendre un ticket pour le service concerné par notre besoin, de savoir notre position dans la file d'attente, le temps moyen dans tous les services et un code QR à presenter à l'agent de la mairie qui offre un descriptif de notre ticket. Les Technlogies utilisées sont: Flutter, dart,Navigator de flutter, packages  (sharedpreferences pour la persistance des données,qr flutter pour la génération du code QR, http pour l'appel de l'api de la méteo sur api.open-meteo.com,  Google_fonts pour la police des écritures + la modification du thème (sombre ou clair selon le système), un provider pour partager les données sur toutes les pages, consumer qui écoute les changements et reconstruit la partie UI concernées, changenotifier pour que les différentes pages l’écoutent, Uuid pour l’a génération automatique des identifiants des tickets ) pour la gestion d'etat: STATEFULWIDGET
Une Architecture modulaire et pour la collaboration en groupe github avec separation de branches par personne.
Pour lancer l’application il faut avoir vscode, puis entrer dans le répertoire du projet taper la commande flutter run dans la terminal puis choisir comment on souhaite l’ouvrir soit sur un navigateur ou sur un émulateur.
images de l'application 
page "mes tickets"
<img width="1890" height="898" alt="Capture d&#39;écran 2026-06-25 192715" src="https://github.com/user-attachments/assets/3efca9be-cfba-4902-883c-4199e17dd6ff" />
page d'accueil 
<img width="1882" height="896" alt="Capture d&#39;écran 2026-06-25 192651" src="https://github.com/user-attachments/assets/93fec897-ed42-4c83-9446-25b7137b2edd" />
page services 
<img width="1888" height="913" alt="Capture d&#39;écran 2026-06-25 195749" src="https://github.com/user-attachments/assets/2570ab08-9a56-4f47-bca1-0e214ccf9b92" />
en mode sombre
<img width="1895" height="908" alt="Capture d&#39;écran 2026-06-25 192519" src="https://github.com/user-attachments/assets/db414573-3765-4bd8-8287-adce82b4d324" />





This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
