import 'dart:convert';

import 'package:egytravel_app/feature/explore/data/model/directions_route_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class DirectionsService {
  DirectionsService({required this.apiKey, http.Client? client})
    : _client = client ?? http.Client();

  final String apiKey;
  final http.Client _client;

  Future<DirectionsRouteModel> fetchRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final uri = Uri.https('maps.googleapis.com', '/maps/api/directions/json', {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      'key': apiKey,
    });

    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception(
        'Directions request failed with HTTP ${response.statusCode}.',
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final status = (decoded['status'] ?? '').toString();
    if (status != 'OK') {
      final errorMessage = (decoded['error_message'] ?? '').toString();
      if (status == 'ZERO_RESULTS') {
        throw Exception('No route found between the selected locations.');
      }

      throw Exception(
        errorMessage.isNotEmpty
            ? errorMessage
            : 'Directions API returned status: $status',
      );
    }

    final routes = decoded['routes'];
    if (routes is! List || routes.isEmpty) {
      throw Exception('No route data was returned by the Directions API.');
    }

    final route = Map<String, dynamic>.from(routes.first as Map);
    final overviewPolyline = route['overview_polyline'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(route['overview_polyline'] as Map)
        : <String, dynamic>{};
    final encodedPoints = (overviewPolyline['points'] ?? '').toString();

    if (encodedPoints.isEmpty) {
      throw Exception('The route response did not include a polyline.');
    }

    final leg = route['legs'] is List && (route['legs'] as List).isNotEmpty
        ? Map<String, dynamic>.from((route['legs'] as List).first as Map)
        : <String, dynamic>{};

    return DirectionsRouteModel(
      polylinePoints: decodePolyline(encodedPoints),
      distanceText: _readTextValue(leg['distance']),
      durationText: _readTextValue(leg['duration']),
      bounds: _parseBounds(route['bounds']),
    );
  }

  List<LatLng> decodePolyline(String encoded) {
    final points = <LatLng>[];
    int index = 0;
    int latitude = 0;
    int longitude = 0;

    while (index < encoded.length) {
      int shift = 0;
      int result = 0;

      while (true) {
        final byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
        if (byte < 0x20) {
          break;
        }
      }

      final deltaLatitude = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      latitude += deltaLatitude;

      shift = 0;
      result = 0;

      while (true) {
        final byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
        if (byte < 0x20) {
          break;
        }
      }

      final deltaLongitude = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      longitude += deltaLongitude;

      points.add(LatLng(latitude / 1e5, longitude / 1e5));
    }

    return points;
  }

  void dispose() {
    _client.close();
  }

  String? _readTextValue(dynamic value) {
    if (value is Map<String, dynamic>) {
      final text = value['text']?.toString();
      if (text != null && text.isNotEmpty) {
        return text;
      }
    }
    return null;
  }

  LatLngBounds? _parseBounds(dynamic rawBounds) {
    if (rawBounds is! Map<String, dynamic>) {
      return null;
    }

    final northeast = _parseLatLng(rawBounds['northeast']);
    final southwest = _parseLatLng(rawBounds['southwest']);
    if (northeast == null || southwest == null) {
      return null;
    }

    return LatLngBounds(northeast: northeast, southwest: southwest);
  }

  LatLng? _parseLatLng(dynamic rawPoint) {
    if (rawPoint is! Map<String, dynamic>) {
      return null;
    }

    final lat = _toDouble(rawPoint['lat']);
    final lng = _toDouble(rawPoint['lng']);
    if (lat == null || lng == null) {
      return null;
    }

    return LatLng(lat, lng);
  }

  double? _toDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }
}
