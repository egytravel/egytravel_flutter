import 'package:egytravel_app/core/widgets/glassy_background.dart';
import 'package:egytravel_app/feature/explore/ui/widgets/map/map_floating_card_list.dart';
import 'package:egytravel_app/feature/explore/ui/widgets/map/map_placeholder_widget.dart';
import 'package:flutter/material.dart';

class MapViewScreen extends StatelessWidget {
  const MapViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: const BackButton(color: Colors.black),
          ),
        ),
        body: const Stack(
          children: [MapPlaceholderWidget(), MapFloatingCardList()],
        ),
      ),
    );
  }
}
