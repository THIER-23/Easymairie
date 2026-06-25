import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ticket.dart';
import '../services/file_manager.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Consumer<FileManager>(
      builder: (context, fileManager, _) {
        final List<Ticket> mesTickets = fileManager.mesTickets;

        return Scaffold(
          appBar: AppBar(title: const Text("Mes tickets")),
          body: mesTickets.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.confirmation_number_outlined,
                          size: 60, color: colors.onSurface.withOpacity(0.3)),
                      const SizedBox(height: 12),
                      Text(
                        "Vous n'avez aucun ticket actif.",
                        style: TextStyle(color: colors.onSurface.withOpacity(0.6)),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: mesTickets.length,
                  itemBuilder: (context, index) {
                    final ticket = mesTickets[index];
                    final String statusLabel = _getStatusLabel(ticket);
                    final Color statusColor = _getStatusColor(ticket);
                    final IconData statusIcon = _getStatusIcon(ticket);

                    return Column(
                      children: [
                        // Carte principale avec dégradé
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
                                children: [
                                  const Icon(Icons.event_seat_outlined, color: Colors.white70, size: 16),
                                  const SizedBox(width: 6),
                                  Text(ticket.service, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${ticket.service[0].toUpperCase()}${ticket.numero}",
                                style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: const [
                                          Icon(Icons.format_list_numbered, color: Colors.white70, size: 14),
                                          SizedBox(width: 4),
                                          Text("Position", style: TextStyle(color: Colors.white70)),
                                        ],
                                      ),
                                      Text(
                                        ticket.position == 0 ? "Premier !" : "${ticket.position}",
                                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: const [
                                          Icon(Icons.access_time, color: Colors.white70, size: 14),
                                          SizedBox(width: 4),
                                          Text("Temps estimé", style: TextStyle(color: Colors.white70)),
                                        ],
                                      ),
                                      Text(
                                        ticket.tempsAttenteEstime == 0
                                            ? "C'est votre tour !"
                                            : "${ticket.tempsAttenteEstime} min",
                                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Badge de statut
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "N° ${ticket.service[0].toUpperCase()}${ticket.numero}",
                                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colors.onSurface),
                                  ),
                                  Text(statusLabel, style: TextStyle(color: colors.onSurface.withOpacity(0.6))),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  children: [
                                    Icon(statusIcon, color: Colors.white, size: 14),
                                    const SizedBox(width: 6),
                                    Text(statusLabel, style: const TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        // QR Code du ticket
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.qr_code_2, color: colors.primary, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    "QR Code du ticket",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colors.onSurface),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                child: QrImageView(
                                  data: '=== EASYMAIRIE ===\n'
                                      'Service : ${ticket.service}\n'
                                      'Ticket N° : ${ticket.service[0].toUpperCase()}${ticket.numero}\n'
                                      'Position : ${ticket.position == 0 ? "C\'est votre tour !" : "${ticket.position}"}\n'
                                      'Temps estimé : ${ticket.tempsAttenteEstime == 0 ? "C\'est votre tour !" : "${ticket.tempsAttenteEstime} min"}\n'
                                      'Créé le : ${ticket.heureCreation.day}/${ticket.heureCreation.month}/${ticket.heureCreation.year} '
                                      'à ${ticket.heureCreation.hour}h${ticket.heureCreation.minute.toString().padLeft(2, '0')}\n'
                                      '✅ TICKET VALIDE',
                                  version: QrVersions.auto,
                                  size: 180,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.info_outline, size: 14, color: colors.onSurface.withOpacity(0.5)),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Présentez ce QR code à l'agent",
                                    style: TextStyle(color: colors.onSurface.withOpacity(0.5), fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Bouton annuler le ticket
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Annuler le ticket ?"),
                                  content: Text(
                                    "Voulez-vous vraiment annuler le ticket "
                                    "${ticket.service[0].toUpperCase()}${ticket.numero} — ${ticket.service} ?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Non, garder"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.read<FileManager>().cancelTicket(ticket.id);
                                        Navigator.pop(context);
                                      },
                                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                                      child: const Text("Oui, annuler"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                            label: const Text("Annuler ce ticket", style: TextStyle(color: Colors.red)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    );
                  },
                ),
        );
      },
    );
  }

  String _getStatusLabel(Ticket ticket) {
    if (ticket.position == 0) return "Votre tour";
    if (ticket.position <= 2) return "Bientôt";
    return "En cours";
  }

  Color _getStatusColor(Ticket ticket) {
    if (ticket.position == 0) return Colors.green;
    if (ticket.position <= 2) return Colors.orange;
    return Colors.grey;
  }

  IconData _getStatusIcon(Ticket ticket) {
    if (ticket.position == 0) return Icons.notifications_active;
    if (ticket.position <= 2) return Icons.hourglass_bottom;
    return Icons.schedule;
  }
}