class Trip {
  final String id;
  final String userId;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final int numberOfGuests;
  final double totalPrice;
  final String status; // 'upcoming', 'ongoing', 'completed', 'cancelled'
  final String imageUrl;
  final String bookingReference;

  Trip({
    required this.id,
    required this.userId,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.numberOfGuests,
    required this.totalPrice,
    required this.status,
    required this.imageUrl,
    required this.bookingReference,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'destination': destination,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'numberOfGuests': numberOfGuests,
      'totalPrice': totalPrice,
      'status': status,
      'imageUrl': imageUrl,
      'bookingReference': bookingReference,
    };
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'],
      userId: map['userId'],
      destination: map['destination'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      numberOfGuests: map['numberOfGuests'],
      totalPrice: map['totalPrice'],
      status: map['status'],
      imageUrl: map['imageUrl'],
      bookingReference: map['bookingReference'],
    );
  }
} 