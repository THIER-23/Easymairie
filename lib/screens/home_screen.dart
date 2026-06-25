import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/file_manager.dart';
import '../theme/app_theme.dart';
import 'services_screen.dart';
import 'ticket_screen.dart';
import '../widgets/weather_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              // Logo + titre
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colors.primary, colors.primary.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.account_balance, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 10),
                  Text("Easymairie", style: AppTheme.logoStyle(colors.onSurface)),
                ],
              ),
              // Message de bienvenue avec l'heure
Builder(
  builder: (context) {
    final heure = DateTime.now().hour;
    String salutation;
    if (heure < 12) {
      salutation = "Bonjour";
    } else if (heure < 18) {
      salutation = "Bon après-midi";
    } else {
      salutation = "Bonsoir";
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 8)
        ],
      ),
      child: Row(
        children: [
          Text(
            heure < 12 ? "🌅" : heure < 18 ? "☀️" : "🌙",
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$salutation !",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: colors.onSurface,
                ),
              ),
              Text(
                "Il est ${DateTime.now().hour}h${DateTime.now().minute.toString().padLeft(2, '0')}",
                style: TextStyle(
                  color: colors.onSurface.withOpacity(0.6),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  },
),
const SizedBox(height: 20),
              const SizedBox(height: 10),
              Text(
                "Gérez vos files d'attente sans stress.",
                style: TextStyle(color: colors.onSurface.withOpacity(0.6)),
              ),

              const SizedBox(height: 30),
              const WeatherWidget(),
              const SizedBox(height: 30),

              // Carte principale "Prendre un ticket"
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colors.primary, colors.primary.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.confirmation_number_outlined, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Prendre un ticket",
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Évitez la file physique et gagnez du temps.",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          splashColor: colors.primary.withOpacity(0.15),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ServicesScreen()),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_forward, color: colors.primary, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  "Commencer",
                                  style: TextStyle(color: colors.primary, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),
              

              // Bouton "Voir mes tickets"
              Consumer<FileManager>(
                builder: (context, fileManager, _) {
                  final bool aDesTickets = fileManager.mesTickets.isNotEmpty;

                  return Material(
                    color: aDesTickets ? colors.surface : colors.surface.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                    elevation: aDesTickets ? 2 : 0,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      splashColor: colors.primary.withOpacity(0.1),
                      onTap: aDesTickets
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const TicketScreen()),
                              );
                            }
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  aDesTickets ? Icons.confirmation_number : Icons.confirmation_number_outlined,
                                  size: 20,
                                  color: aDesTickets ? colors.primary : colors.onSurface.withOpacity(0.4),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  aDesTickets
                                      ? "Voir mes tickets (${fileManager.mesTickets.length})"
                                      : "Aucun ticket actif",
                                  style: TextStyle(
                                    color: aDesTickets ? colors.onSurface : colors.onSurface.withOpacity(0.4),
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: aDesTickets ? colors.onSurface.withOpacity(0.6) : colors.onSurface.withOpacity(0.2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}