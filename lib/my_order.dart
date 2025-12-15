import 'package:flutter/material.dart';
import 'detail.dart';
import 'model/order.dart';

class MyOrderPage extends StatelessWidget {
  const MyOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Order> orders = DetailPage.orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: const Color(0xFF00AAFF),
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text(
                'Belum ada booking',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final Order order = orders[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(order.placeName),
                    subtitle: Text(
                        'Tanggal: ${order.date.day}/${order.date.month}/${order.date.year}\nOrang: ${order.people}'),
                  ),
                );
              },
            ),
    );
  }
}
