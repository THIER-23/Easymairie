import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/file_manager.dart';
import '../data/services_data.dart';
import 'ticket_screen.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  static const Map<String, IconData> _icones = {
    "Carte d'identité": Icons.badge_outlined,
    "Acte de naissance": Icons.description_outlined,
    "Permis de construire": Icons.home_work_outlined,
    "État civil": Icons.family_restroom_outlined,
  };

  IconData _iconePour(String service) {
    return _icones[service] ?? Icons.miscellaneous_services_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final List<String> services = ServicesData.nomsServices;

    return Scaffold(
      appBar: AppBar(title: const Text("Services")),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final String service = services[index];
          final int tempsMoyen = ServicesData.tempsMoyenPour(service);

          void choisirService() {
            final fileManager = context.read<FileManager>();
            fileManager.addTicket(service);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TicketScreen()),
            );
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            child: Material(
              color: colors.surface,
              borderRadius: BorderRadius.circular(20),
              elevation: 2,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                splashColor: colors.primary.withOpacity(0.12),
                onTap: choisirService,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(_iconePour(service), color: colors.primary, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: colors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.access_time, size: 14, color: colors.onSurface.withOpacity(0.6)),
                                const SizedBox(width: 4),
                                Text(
                                  "~$tempsMoyen min",
                                  style: TextStyle(fontSize: 13, color: colors.onSurface.withOpacity(0.6)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Material(
                        color: colors.secondary,
                        borderRadius: BorderRadius.circular(30),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: choisirService,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: Text(
                              "Choisir",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}