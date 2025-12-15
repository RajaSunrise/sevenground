class OrderTrip {
  final int? id;
  final String placeName;
  final String date;
  final int pax;
  final int totalPrice;
  final String status;
  final String paymentMethod;

  OrderTrip({
    this.id,
    required this.placeName,
    required this.date,
    required this.pax,
    required this.totalPrice,
    required this.status,
    required this.paymentMethod,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'placeName': placeName,
      'date': date,
      'pax': pax,
      'totalPrice': totalPrice,
      'status': status,
      'paymentMethod': paymentMethod,
    };
  }

  factory OrderTrip.fromMap(Map<String, dynamic> map) {
    return OrderTrip(
      id: map['id'],
      placeName: map['placeName'] ?? '',
      date: map['date'] ?? '',
      pax: map['pax'] ?? 1,
      totalPrice: map['totalPrice'] ?? 0,
      status: map['status'] ?? 'Pending',
      paymentMethod: map['paymentMethod'] ?? 'Cash',
    );
  }
}
