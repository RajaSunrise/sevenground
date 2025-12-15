import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'model/place.dart';
import 'order_trip.dart';
import 'edit.dart';
import 'api.dart';

class DetailPage extends StatelessWidget {
  final Place place;
  const DetailPage({super.key, required this.place});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFF00AAFF),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(place.name, style: const TextStyle(fontSize: 16)),
              background: CachedNetworkImage(
                imageUrl: place.safeImageUrl,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const Icon(Icons.error, size: 50, color: Colors.white),
              ),
            ),
            actions: [
              // Edit Button
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                   final bool? updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (final _) => EditPage(place: place)),
                  );
                  if (updated == true) {
                    Navigator.pop(context); // Go back to refresh list
                  }
                },
              ),
              // Delete Button
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final bool confirm = await showDialog(
                    context: context,
                    builder: (final context) => AlertDialog(
                      title: const Text('Hapus Tempat?'),
                      content: const Text('Tindakan ini tidak bisa dibatalkan.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ) ?? false;

                  if (confirm && place.id != null) {
                    await ApiService.deletePlace(place.id!);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(place.location,
                          style: const TextStyle(color: Colors.grey)),
                      const Spacer(),
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      Text('${place.rating} / 5'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _infoBox('Ketinggian', '${place.elevation} mdpl'),
                      _infoBox('Kategori', place.category),
                      _infoBox('Jarak', '12 km'), // Dummy distance
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Deskripsi',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(place.description,
                      style: const TextStyle(color: Colors.black87, height: 1.5)),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00AAFF),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (final _) => OrderTripPage(place: place)),
            );
          },
          child: const Text(
            'Booking Sekarang',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _infoBox(final String label, final String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
