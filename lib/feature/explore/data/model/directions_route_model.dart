import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsRouteModel {
  final List<LatLng> polylinePoints;
  final String? distanceText;
  final String? durationText;
  final LatLngBounds? bounds;

  const DirectionsRouteModel({
    required this.polylinePoints,
    this.distanceText,
    this.durationText,
    this.bounds,
  });

  bool get hasPolyline => polylinePoints.isNotEmpty;
}
