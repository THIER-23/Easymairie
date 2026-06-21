import 'package:flutter/material.dart';
import 'ticket_screen.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final services = [
      {"name": "État civil", "time": "10 min"},
      {"name": "Passeport", "time": "25 min"},
      {"name": "Carte d'identité", "time": "15 min"},
      {"name": "Naissance", "time": "8 min"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Services")),

      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: services.length,
        itemBuilder: (context, index) {

          final service = services[index];

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
                      service["name"]!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text("Temps estimé : ${service["time"]}"),
                  ],
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TicketScreen(),
                      ),
                    );
                  },
                  child: const Text("Choisir"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}