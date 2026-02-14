import 'package:city_events_explorer/src/features/events/domain/entities/location.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';

@freezed
class Event with _$Event {
  const factory Event({
    required String id,
    required String title,
    required String description,
    required String category,
    required DateTime startDate,
    required DateTime endDate,
    required String imageUrl,
    required Location location,
  }) = _Event;
}
