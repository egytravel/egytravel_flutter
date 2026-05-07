import 'package:egytravel_app/core/config/google_maps_config.dart';
import 'package:egytravel_app/core/widgets/glassy_background.dart';
import 'package:egytravel_app/feature/explore/data/model/explore_item_model.dart';
import 'package:egytravel_app/feature/explore/ui/widgets/map/directions_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewScreen extends StatelessWidget {
  const MapViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamic args = Get.arguments;
    final ExploreItemModel? item = _readItem(args);
    final double? originLat = _readDouble(
      args is Map ? args['originLat'] : null,
    );
    final double? originLng = _readDouble(
      args is Map ? args['originLng'] : null,
    );
    final double? destinationLat = _readDouble(
      args is Map ? args['destinationLat'] ?? item?.lat : item?.lat,
    );
    final double? destinationLng = _readDouble(
      args is Map ? args['destinationLng'] ?? item?.lng : item?.lng,
    );

    return GlassyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            child: const BackButton(color: Colors.black),
          ),
        ),
        body: _buildBody(
          item: item,
          originLat: originLat,
          originLng: originLng,
          destinationLat: destinationLat,
          destinationLng: destinationLng,
        ),
      ),
    );
  }

  Widget _buildBody({
    required ExploreItemModel? item,
    required double? originLat,
    required double? originLng,
    required double? destinationLat,
    required double? destinationLng,
  }) {
    if (item == null || destinationLat == null || destinationLng == null) {
      return const _MapMessageView(
        title: 'Location unavailable',
        message: 'This place does not have map coordinates yet.',
      );
    }

    final destination = LatLng(destinationLat, destinationLng);

    return Stack(
      children: [
        if (originLat != null && originLng != null)
          DirectionsMapWidget(
            originLat: originLat,
            originLng: originLng,
            destinationLat: destinationLat,
            destinationLng: destinationLng,
            destinationTitle: item.title,
            directionsApiKey: GoogleMapsConfig.directionsApiKey,
          )
        else
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: destination,
              zoom: 14,
            ),
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            markers: {
              Marker(
                markerId: const MarkerId('destination'),
                position: destination,
                infoWindow: InfoWindow(title: item.title),
              ),
            },
          ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 30,
          child: _DestinationInfoCard(
            item: item,
            isRouteEnabled: originLat != null && originLng != null,
          ),
        ),
      ],
    );
  }

  ExploreItemModel? _readItem(dynamic args) {
    if (args is ExploreItemModel) {
      return args;
    }
    if (args is Map && args['item'] is ExploreItemModel) {
      return args['item'] as ExploreItemModel;
    }
    return null;
  }

  double? _readDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }
}

class _DestinationInfoCard extends StatelessWidget {
  const _DestinationInfoCard({
    required this.item,
    required this.isRouteEnabled,
  });

  final ExploreItemModel item;
  final bool isRouteEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            item.location,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.place_outlined,
                color: Color(0xFFE09A1E),
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${item.lat?.toStringAsFixed(5)}, ${item.lng?.toStringAsFixed(5)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (!isRouteEnabled) ...[
            const SizedBox(height: 12),
            const Text(
              'Route preview is waiting for your current latitude and longitude.',
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MapMessageView extends StatelessWidget {
  const _MapMessageView({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map_outlined, color: Colors.white54, size: 56),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
