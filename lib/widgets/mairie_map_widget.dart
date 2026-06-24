import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MairieMapWidget extends StatelessWidget {
  const MairieMapWidget({super.key});

  // Remplace par les vraies coordonnées de la mairie
  static const LatLng mairiePosition = LatLng(0.4162, 9.4673); // exemple Libreville

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: mairiePosition,
            zoom: 15,
          ),
          markers: {
            const Marker(
              markerId: MarkerId('mairie'),
              position: mairiePosition,
              infoWindow: InfoWindow(title: 'Mairie'),
            ),
          },
        ),
      ),
    );
  }
}