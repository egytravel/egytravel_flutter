class TripModel {
  final String id;
  final String title;
  final String? description;
  final String? destination;
  final String? startDate;
  final String? endDate;
  final double? budget;
  final String status;
  final List<TripDayModel>? days;
  final Map<String, dynamic>? hotel;
  final List<TripBookingModel>? bookings;

  TripModel({
    required this.id,
    required this.title,
    this.description,
    this.destination,
    this.startDate,
    this.endDate,
    this.budget,
    required this.status,
    this.days,
    this.hotel,
    this.bookings,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: _readString(json, ['id', '_id', 'tripId']),
      title: _readString(json, ['title', 'name']),
      description: _nullableString(json['description']),
      destination: _nullableString(json['destination']),
      startDate: _nullableString(json['startDate']),
      endDate: _nullableString(json['endDate']),
      budget: _nullableDouble(json['budget']),
      status: _readString(json, ['status'], fallback: 'planning'),
      days: _mapList(json['days'], (item) => TripDayModel.fromJson(item)),
      hotel: json['hotel'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['hotel'] as Map)
          : null,
      bookings: _mapList(
        json['bookings'],
        (item) => TripBookingModel.fromJson(item),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      if (description != null) 'description': description,
      if (destination != null) 'destination': destination,
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
      if (budget != null) 'budget': budget,
    };
  }

  int get durationInDays {
    if (startDate == null || endDate == null) return 0;
    try {
      final s = DateTime.parse(startDate!);
      final e = DateTime.parse(endDate!);
      return e.difference(s).inDays + 1;
    } catch (_) {
      return 0;
    }
  }
}

class TripDayModel {
  final String id;
  final int dayNumber;
  final String? date;
  final String? title;
  final String? description;
  final String? notes;
  final double? budget;
  final List<TripActivityModel>? activities;
  final List<TripLocationModel>? locations;
  final List<TripBookingModel>? bookings;

  TripDayModel({
    required this.id,
    required this.dayNumber,
    this.date,
    this.title,
    this.description,
    this.notes,
    this.budget,
    this.activities,
    this.locations,
    this.bookings,
  });

  factory TripDayModel.fromJson(Map<String, dynamic> json) {
    return TripDayModel(
      id: _readString(json, ['id', '_id', 'dayId']),
      dayNumber: _readInt(json['dayNumber']),
      date: _nullableString(json['date']),
      title: _nullableString(json['title']),
      description: _nullableString(json['description']),
      notes: _nullableString(json['notes']),
      budget: _nullableDouble(json['budget']),
      activities: _parseActivities(json['activities']),
      locations: _mapList(
        json['locations'],
        (item) => TripLocationModel.fromJson(item),
      ),
      bookings: _mapList(
        json['bookings'],
        (item) => TripBookingModel.fromJson(item),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayNumber': dayNumber,
      if (date != null) 'date': date,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (notes != null) 'notes': notes,
      if (budget != null) 'budget': budget,
      if (activities != null)
        'activities': activities!.map((activity) => activity.toJson()).toList(),
      if (locations != null)
        'locations': locations!.map((location) => location.toJson()).toList(),
    };
  }
}

class TripActivityModel {
  final String id;
  final String title;
  final String? time;
  final String? location;
  final String? description;
  final double? cost;

  TripActivityModel({
    required this.id,
    required this.title,
    this.time,
    this.location,
    this.description,
    this.cost,
  });

  factory TripActivityModel.fromJson(Map<String, dynamic> json) {
    return TripActivityModel(
      id: _readString(json, ['id', '_id', 'activityId']),
      title: _readString(json, ['title', 'name']),
      time: _nullableString(json['time']),
      location: _nullableString(json['location']),
      description: _nullableString(json['description']),
      cost: _nullableDouble(json['cost']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      if (time != null) 'time': time,
      if (location != null) 'location': location,
      if (description != null) 'description': description,
      if (cost != null) 'cost': cost,
    };
  }
}

class TripLocationModel {
  final String name;
  final String? address;
  final double? lat;
  final double? lng;
  final String? type;

  TripLocationModel({
    required this.name,
    this.address,
    this.lat,
    this.lng,
    this.type,
  });

  factory TripLocationModel.fromJson(Map<String, dynamic> json) {
    return TripLocationModel(
      name: _readString(json, ['name', 'title'], fallback: 'Location'),
      address: _nullableString(json['address']),
      lat: _nullableDouble(json['lat'] ?? json['latitude']),
      lng: _nullableDouble(json['lng'] ?? json['longitude']),
      type: _nullableString(json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (address != null) 'address': address,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (type != null) 'type': type,
    };
  }
}

class TripBookingModel {
  final String id;
  final String type;
  final String? tripId;
  final String? status;
  final String? hotelId;
  final String? hotelName;
  final String? hotelLocation;
  final String? checkinDate;
  final String? checkoutDate;
  final int? guests;
  final int? rooms;
  final double? totalPrice;
  final String? currency;
  final Map<String, dynamic> raw;

  TripBookingModel({
    required this.id,
    required this.type,
    this.tripId,
    this.status,
    this.hotelId,
    this.hotelName,
    this.hotelLocation,
    this.checkinDate,
    this.checkoutDate,
    this.guests,
    this.rooms,
    this.totalPrice,
    this.currency,
    required this.raw,
  });

  factory TripBookingModel.fromJson(Map<String, dynamic> json) {
    final hotelMap = json['hotel'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(json['hotel'] as Map)
        : <String, dynamic>{};

    return TripBookingModel(
      id: _readString(json, ['id', '_id', 'bookingId']),
      type: _readString(
        json,
        ['type', 'bookingType'],
        fallback:
            hotelMap.isNotEmpty ||
                json['hotelId'] != null ||
                json['hotelName'] != null
            ? 'hotel'
            : 'booking',
      ),
      tripId: _nullableString(json['tripId']),
      status: _nullableString(json['status']),
      hotelId: _nullableString(
        json['hotelId'] ?? hotelMap['id'] ?? hotelMap['_id'],
      ),
      hotelName: _nullableString(
        json['hotelName'] ?? hotelMap['name'] ?? json['name'] ?? json['title'],
      ),
      hotelLocation: _nullableString(
        json['hotelLocation'] ??
            hotelMap['location'] ??
            hotelMap['city'] ??
            json['location'] ??
            json['city'],
      ),
      checkinDate: _nullableString(json['checkinDate'] ?? json['checkInDate']),
      checkoutDate: _nullableString(
        json['checkoutDate'] ?? json['checkOutDate'],
      ),
      guests: _nullableInt(json['guests']),
      rooms: _nullableInt(json['rooms']),
      totalPrice: _nullableDouble(
        json['totalPrice'] ?? json['price'] ?? json['amount'],
      ),
      currency: _nullableString(json['currency']),
      raw: Map<String, dynamic>.from(json),
    );
  }

  String get displayTitle {
    if ((hotelName ?? '').trim().isNotEmpty) return hotelName!.trim();
    if (type.toLowerCase() == 'hotel') return 'Hotel Booking';
    return 'Booking';
  }

  String get displayStatus {
    final value = (status ?? '').trim();
    return value.isEmpty ? 'Pending' : value;
  }

  String get displayLocation => (hotelLocation ?? '').trim();

  String get displayPrice {
    if (totalPrice == null) return '';
    final amount = totalPrice!;
    final normalized = amount == amount.roundToDouble()
        ? amount.toStringAsFixed(0)
        : amount.toStringAsFixed(2);
    final code = (currency ?? '').trim();
    return code.isEmpty ? normalized : '$code $normalized';
  }
}

class TripMapMarker {
  final String id;
  final String title;
  final String? description;
  final double lat;
  final double lng;
  final String? type;

  TripMapMarker({
    required this.id,
    required this.title,
    this.description,
    required this.lat,
    required this.lng,
    this.type,
  });

  factory TripMapMarker.fromJson(Map<String, dynamic> json) {
    return TripMapMarker(
      id: _readString(json, ['id', '_id']),
      title: _readString(json, ['title', 'name']),
      description: _nullableString(json['description']),
      lat: _nullableDouble(json['lat'] ?? json['latitude']) ?? 0,
      lng: _nullableDouble(json['lng'] ?? json['longitude']) ?? 0,
      type: _nullableString(json['type']),
    );
  }
}

List<T>? _mapList<T>(
  dynamic source,
  T Function(Map<String, dynamic> item) parser,
) {
  if (source is! List) return null;
  return source
      .whereType<Map>()
      .map((item) => parser(Map<String, dynamic>.from(item)))
      .toList();
}

List<TripActivityModel>? _parseActivities(dynamic source) {
  if (source is! List) return null;

  return source.map((item) {
    if (item is Map<String, dynamic>) {
      return TripActivityModel.fromJson(item);
    }
    if (item is Map) {
      return TripActivityModel.fromJson(Map<String, dynamic>.from(item));
    }
    if (item is String) {
      return TripActivityModel(id: '', title: item);
    }
    return TripActivityModel(id: '', title: item.toString());
  }).toList();
}

String _readString(
  Map<String, dynamic> json,
  List<String> keys, {
  String fallback = '',
}) {
  for (final key in keys) {
    final value = _nullableString(json[key]);
    if (value != null && value.trim().isNotEmpty) {
      return value;
    }
  }
  return fallback;
}

String? _nullableString(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

double? _nullableDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

int _readInt(dynamic value) => _nullableInt(value) ?? 0;

int? _nullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}
