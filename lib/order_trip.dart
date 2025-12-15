import 'package:flutter/material.dart';
import 'detail.dart';
import 'model/place.dart';

class OrderTripPage extends StatelessWidget {
  final List<Place> trips;

  const OrderTripPage({super.key, required this.trips});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Trip'),
        backgroundColor: const Color(0xFF00AAFF),
      ),
      body: trips.isEmpty
          ? const Center(
              child: Text(
                'Belum ada trip tersedia',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: trips.length,
              separatorBuilder: (final _, final __) => const Divider(height: 1),
              itemBuilder: (final BuildContext context, final int index) {
                final Place place = trips[index];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  title: Text(
                    place.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(place.location),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (final _) => DetailPage(place: place),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
