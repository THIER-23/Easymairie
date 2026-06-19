import 'package:flutter/material.dart';
import 'ticket_screen.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final List<String> services = [
      "État civil",
      "Passeport",
      "Carte d'identité",
      "Naissance",
      "Mariage",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Services"),
        backgroundColor: Colors.blue,
      ),

      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {

          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),

            child: ListTile(
              leading: const Icon(Icons.business, color: Colors.blue),
              title: Text(
                services[index],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TicketScreen(),
                    ),
                  );
                },
                child: const Text("Prendre"),
              ),
            ),
          );
        },
      ),
    );
  }
}