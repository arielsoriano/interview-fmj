import 'package:city_events_explorer/src/features/events/data/models/location_model.dart';
import 'package:city_events_explorer/src/features/events/domain/entities/event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@freezed
class EventModel with _$EventModel {
  const factory EventModel({
    required String id,
    required String title,
    required String description,
    required String category,
    required DateTime startDate,
    required DateTime endDate,
    required String imageUrl,
    required LocationModel location,
  }) = _EventModel;

  const EventModel._();

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  factory EventModel.fromEntity(Event entity) => EventModel(
        id: entity.id,
        title: entity.title,
        description: entity.description,
        category: entity.category,
        startDate: entity.startDate,
        endDate: entity.endDate,
        imageUrl: entity.imageUrl,
        location: LocationModel.fromEntity(entity.location),
      );

  Event toEntity() => Event(
        id: id,
        title: title,
        description: description,
        category: category,
        startDate: startDate,
        endDate: endDate,
        imageUrl: imageUrl,
        location: location.toEntity(),
      );
}
