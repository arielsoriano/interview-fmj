import 'package:city_events_explorer/src/features/events/domain/entities/location.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_model.freezed.dart';
part 'location_model.g.dart';

@freezed
class LocationModel with _$LocationModel {
  const factory LocationModel({
    required String name,
    required double lat,
    required double lng,
  }) = _LocationModel;

  const LocationModel._();

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  factory LocationModel.fromEntity(Location entity) => LocationModel(
        name: entity.name,
        lat: entity.lat,
        lng: entity.lng,
      );

  Location toEntity() => Location(
        name: name,
        lat: lat,
        lng: lng,
      );
}
