import 'package:flutter/material.dart';
import 'services_screen.dart';
import 'ticket_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(Icons.location_city, size: 80, color: Colors.white),

            const SizedBox(height: 20),

            const Text(
              "Easymairie",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Gérez votre attente facilement",
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 40),

            // Bouton 1
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ServicesScreen(),
                  ),
                );
              },
              child: const Text("Prendre un ticket"),
            ),

            const SizedBox(height: 20),

            // Bouton 2
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TicketScreen(),
                  ),
                );
              },
              child: const Text("Voir mon ticket"),
            ),
          ],
        ),
      ),
    );
  }
}