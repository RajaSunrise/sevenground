import 'package:flutter/material.dart';
import 'model/place.dart';
import 'model/order.dart';

class DetailPage extends StatefulWidget {
  final Place place;
  const DetailPage({super.key, required this.place});

  static List<Order> orders = [];

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  DateTime? _selectedDate;
  int _people = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.place.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Image.network(widget.place.safeImageUrl,
              height: 200, fit: BoxFit.cover),
          const SizedBox(height: 12),
          Text(widget.place.location,
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Text(widget.place.description),
          const SizedBox(height: 20),
          ListTile(
            title: const Text('Tanggal Trip'),
            subtitle: Text(_selectedDate != null
                ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                : 'Pilih tanggal'),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (picked != null) setState(() => _selectedDate = picked);
            },
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Jumlah Orang'),
              Row(
                children: [
                  IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed:
                          _people > 1 ? () => setState(() => _people--) : null),
                  Text('$_people'),
                  IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() => _people++)),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00AAFF)),
            onPressed: _selectedDate == null
                ? null
                : () {
                    DetailPage.orders.add(Order(
                      placeName: widget.place.name,
                      date: _selectedDate!,
                      people: _people,
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Trip berhasil dibooking')));
                  },
            child: const Text('Pesan Trip'),
          )
        ],
      ),
    );
  }
}
