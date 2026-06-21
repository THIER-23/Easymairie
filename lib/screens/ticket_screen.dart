import 'package:flutter/material.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final tickets = [
      {"numero": "A-021", "status": "En cours"},
      {"numero": "A-022", "status": "Bientôt"},
      {"numero": "A-023", "status": "Votre tour"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Mes tickets")),

      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: tickets.length,
        itemBuilder: (context, index) {

          final ticket = tickets[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.grey.shade200, blurRadius: 10)
              ],
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket["numero"]!,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(ticket["status"]!),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: ticket["status"] == "Votre tour"
                        ? Colors.green
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    ticket["status"]!,
                    style: TextStyle(
                      color: ticket["status"] == "Votre tour"
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}