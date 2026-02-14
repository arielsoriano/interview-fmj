import 'package:city_events_explorer/src/core/utils/app_colors.dart';
import 'package:city_events_explorer/src/core/utils/app_spacing.dart';
import 'package:city_events_explorer/src/features/events/domain/entities/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPreview extends StatelessWidget {
  const MapPreview({
    required this.location,
    super.key,
  });

  final Location location;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: SizedBox(
        height: 220,
        child: AbsorbPointer(
          child: FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(location.lat, location.lng),
              initialZoom: 14,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.none,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.dribba.city_events_explorer',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(location.lat, location.lng),
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_on,
                      color: AppColors.error,
                      size: 40,
                      shadows: [
                        Shadow(
                          color: AppColors.shadow,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
