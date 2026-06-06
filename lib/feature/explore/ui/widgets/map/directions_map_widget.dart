import 'dart:async';
import 'dart:math' as math;

import 'package:egytravel_app/feature/explore/data/model/directions_route_model.dart';
import 'package:egytravel_app/feature/explore/data/services/directions_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsMapWidget extends StatefulWidget {
  const DirectionsMapWidget({
    super.key,
    required this.originLat,
    required this.originLng,
    required this.destinationLat,
    required this.destinationLng,
    required this.directionsApiKey,
    this.originTitle = 'Your Location',
    this.destinationTitle = 'Destination',
  });

  final double originLat;
  final double originLng;
  final double destinationLat;
  final double destinationLng;
  final String directionsApiKey;
  final String originTitle;
  final String destinationTitle;

  @override
  State<DirectionsMapWidget> createState() => _DirectionsMapWidgetState();
}

class _DirectionsMapWidgetState extends State<DirectionsMapWidget> {
  final Completer<GoogleMapController> _controllerCompleter =
      Completer<GoogleMapController>();

  late final DirectionsService _directionsService;
  late final LatLng _origin;
  late final LatLng _destination;

  DirectionsRouteModel? _route;
  GoogleMapController? _mapController;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _origin = LatLng(widget.originLat, widget.originLng);
    _destination = LatLng(widget.destinationLat, widget.destinationLng);
    _directionsService = DirectionsService(apiKey: widget.directionsApiKey);
    _loadRoute();
  }

  Future<void> _loadRoute() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final route = await _directionsService.fetchRoute(
        origin: _origin,
        destination: _destination,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _route = route;
      });

      await _fitCamera();
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = error.toString().replaceAll('Exception: ', '');
      });

      await _fitCamera();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fitCamera() async {
    final controller = _mapController;
    if (controller == null) {
      return;
    }

    final targetBounds = _route?.bounds ?? _boundsFromPoints(_allPoints);
    if (targetBounds == null) {
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(_destination, 14),
      );
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 250));
    await controller.animateCamera(
      CameraUpdate.newLatLngBounds(targetBounds, 72),
    );
  }

  List<LatLng> get _allPoints {
    final points = <LatLng>[_origin, _destination];
    if (_route?.polylinePoints.isNotEmpty ?? false) {
      points.addAll(_route!.polylinePoints);
    }
    return points;
  }

  Set<Marker> get _markers {
    return {
      Marker(
        markerId: const MarkerId('origin'),
        position: _origin,
        infoWindow: InfoWindow(title: widget.originTitle),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
      Marker(
        markerId: const MarkerId('destination'),
        position: _destination,
        infoWindow: InfoWindow(title: widget.destinationTitle),
      ),
    };
  }

  Set<Polyline> get _polylines {
    if (!(_route?.hasPolyline ?? false)) {
      return {};
    }

    return {
      Polyline(
        polylineId: const PolylineId('route'),
        color: const Color(0xFFE09A1E),
        width: 6,
        points: _route!.polylinePoints,
      ),
    };
  }

  LatLngBounds? _boundsFromPoints(List<LatLng> points) {
    if (points.isEmpty) {
      return null;
    }

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points.skip(1)) {
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLng = math.min(minLng, point.longitude);
      maxLng = math.max(maxLng, point.longitude);
    }

    if (minLat == maxLat && minLng == maxLng) {
      const delta = 0.01;
      minLat -= delta;
      maxLat += delta;
      minLng -= delta;
      maxLng += delta;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _directionsService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: _destination, zoom: 13),
          markers: _markers,
          polylines: _polylines,
          zoomControlsEnabled: false,
          compassEnabled: true,
          onMapCreated: (controller) async {
            _mapController = controller;
            if (!_controllerCompleter.isCompleted) {
              _controllerCompleter.complete(controller);
            }
            await _fitCamera();
          },
        ),
        if (_route != null || _errorMessage != null)
          Positioned(
            top: 110,
            left: 16,
            right: 16,
            child: _RouteStatusCard(
              distanceText: _route?.distanceText,
              durationText: _route?.durationText,
              errorMessage: _errorMessage,
            ),
          ),
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.18),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFFE09A1E)),
              ),
            ),
          ),
      ],
    );
  }
}

class _RouteStatusCard extends StatelessWidget {
  const _RouteStatusCard({
    this.distanceText,
    this.durationText,
    this.errorMessage,
  });

  final String? distanceText;
  final String? durationText;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final hasError = errorMessage != null && errorMessage!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasError
              ? Colors.redAccent.withValues(alpha: 0.35)
              : Colors.white.withValues(alpha: 0.12),
        ),
      ),
      child: hasError
          ? Text(
              errorMessage!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _MetricChip(
                  icon: Icons.route_outlined,
                  label: distanceText ?? 'Route ready',
                ),
                _MetricChip(
                  icon: Icons.schedule_outlined,
                  label: durationText ?? 'ETA unavailable',
                ),
              ],
            ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFFE09A1E), size: 18),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
