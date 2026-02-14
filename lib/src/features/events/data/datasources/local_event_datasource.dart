import 'dart:convert';

import 'package:city_events_explorer/src/features/events/data/models/event_model.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LocalEventDatasource {
  static const String _eventsJsonPath = 'assets/data/events.json';

  Future<List<EventModel>> loadEventsFromJson() async {
    final jsonString = await rootBundle.loadString(_eventsJsonPath);
    final jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((json) => EventModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
