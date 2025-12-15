import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'model/place.dart';
import 'model/order_model.dart';
import 'services/local_data_service.dart';

class OrderTripPage extends StatefulWidget {
  final Place place;
  const OrderTripPage({super.key, required this.place});

  @override
  State<OrderTripPage> createState() => _OrderTripPageState();
}

class _OrderTripPageState extends State<OrderTripPage> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  int _pax = 1;
  String _paymentMethod = 'Gopay';
  bool _loading = false;

  final List<String> _paymentMethods = ['Gopay', 'OVO', 'Dana', 'Transfer Bank'];

  // Base price calculation (Dummy logic)
  int get _basePrice => widget.place.category == 'mountain' ? 500000 : 150000;
  int get _totalPrice => _basePrice * _pax;

  Future<void> _selectDate(final BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final OrderTrip newOrder = OrderTrip(
      placeName: widget.place.name,
      date: DateFormat('yyyy-MM-dd').format(_selectedDate),
      pax: _pax,
      totalPrice: _totalPrice,
      status: 'Paid',
      paymentMethod: _paymentMethod,
    );

    // Save to local DB
    await LocalDataService.insertOrder(newOrder);

    if (!mounted) return;
    setState(() => _loading = false);

    // Show success dialog
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (final ctx) => AlertDialog(
        title: const Text('Pesanan Berhasil'),
        content: Text(
            'Pesanan ke ${widget.place.name} berhasil dibuat.\nPembayaran via $_paymentMethod sukses.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Close OrderPage
              Navigator.pop(context); // Close DetailPage (optional, depends on UX)
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Pemesanan'),
        backgroundColor: const Color(0xFF00AAFF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Destinasi: ${widget.place.name}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),

              // Date Picker
              const Text('Tanggal Perjalanan', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 18),
                      const SizedBox(width: 8),
                      Text(DateFormat('dd MMMM yyyy').format(_selectedDate)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Pax Counter
              const Text('Jumlah Peserta', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_pax > 1) setState(() => _pax--);
                    },
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text('$_pax', style: const TextStyle(fontSize: 18)),
                  IconButton(
                    onPressed: () {
                      setState(() => _pax++);
                    },
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Payment Method
              const Text('Metode Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                items: _paymentMethods.map((final String method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Row(
                      children: [
                        const Icon(Icons.payment, size: 16),
                        const SizedBox(width: 8),
                        Text(method),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (final String? val) {
                  if (val != null) setState(() => _paymentMethod = val);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 32),

              // Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Harga per orang'),
                        Text('Rp ${NumberFormat('#,###').format(_basePrice)}'),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Bayar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Rp ${NumberFormat('#,###').format(_totalPrice)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00AAFF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _loading ? null : _submitOrder,
                  child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Bayar & Pesan', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
