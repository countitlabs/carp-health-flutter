import 'package:health/health.dart';

class HealthFixtures {
  static final DateTime start = DateTime(2025, 1, 1, 10, 0);
  static final DateTime end = DateTime(2025, 1, 1, 11, 0);

  static Map<String, dynamic> numericPoint({
    String uuid = 'uuid-1',
    num value = 72,
    DateTime? from,
    DateTime? to,
    String sourceId = 'source-id',
    String sourceName = 'source-name',
    int recordingMethod = 2,
    Map<String, dynamic>? metadata,
  }) {
    return {
      'uuid': uuid,
      'value': value,
      'date_from': (from ?? start).millisecondsSinceEpoch,
      'date_to': (to ?? end).millisecondsSinceEpoch,
      'source_id': sourceId,
      'source_name': sourceName,
      'recording_method': recordingMethod,
      if (metadata != null) 'metadata': metadata,
    };
  }

  static Map<String, dynamic> workoutPoint({
    String uuid = 'workout-uuid-1',
    String activityType = 'RUNNING',
    int? totalEnergyBurned = 200,
    String? totalEnergyBurnedUnit = 'KILOCALORIE',
    int totalDistance = 5000,
    String totalDistanceUnit = 'METER',
    DateTime? from,
    DateTime? to,
    String sourceId = 'source-id',
    String sourceName = 'source-name',
    int recordingMethod = 2,
    double duration = 3600,
    String durationUnit = 'SECOND',
    String activityName = 'Morning run',
    double totalElevationAscended = 120,
    double totalElevationDescended = 95,
    double averageSpeed = 2.5,
    List<double> energyBurnedValues = const [],
    Map<String, dynamic>? metadata,
  }) {
    return {
      'uuid': uuid,
      'workoutActivityType': activityType,
      'totalEnergyBurned': totalEnergyBurned,
      'totalEnergyBurnedUnit': totalEnergyBurnedUnit,
      'totalDistance': totalDistance,
      'totalDistanceUnit': totalDistanceUnit,
      'duration': duration,
      'durationUnit': durationUnit,
      'activityName': activityName,
      'totalElevationAscended': totalElevationAscended,
      'totalElevationAscendedUnit': 'METER',
      'totalElevationDescended': totalElevationDescended,
      'totalElevationDescendedUnit': 'METER',
      'averageSpeed': averageSpeed,
      'averageSpeedUnit': 'METER_PER_SECOND',
      'energyBurnedValues': energyBurnedValues,
      if (energyBurnedValues.isNotEmpty) 'energyBurnedValuesUnit': 'KILOCALORIE',
      'date_from': (from ?? start).millisecondsSinceEpoch,
      'date_to': (to ?? end).millisecondsSinceEpoch,
      'source_id': sourceId,
      'source_name': sourceName,
      'recording_method': recordingMethod,
      if (metadata != null) 'metadata': metadata,
    };
  }

  static Map<String, dynamic> workoutRoutePoint({
    String uuid = 'route-uuid-1',
    String workoutUuid = 'workout-uuid-1',
    DateTime? from,
    DateTime? to,
  }) {
    return {
      'uuid': uuid,
      'route': [
        {
          'latitude': 37.3349,
          'longitude': -122.0090,
          'timestamp': (from ?? start).toUtc().millisecondsSinceEpoch,
          'horizontalAccuracy': 5.0,
          'verticalAccuracy': 8.0,
          'speed': 1.4,
          'course': 90.0,
          'speedAccuracy': 0.5,
          'courseAccuracy': 5.0,
        },
      ],
      'date_from': (from ?? start).millisecondsSinceEpoch,
      'date_to': (to ?? end).millisecondsSinceEpoch,
      'source_id': 'source-id',
      'source_name': 'source-name',
      'recording_method': RecordingMethod.automatic.toInt(),
      'metadata': {'route_point_count': 1, 'workout_uuid': workoutUuid},
      'workout_uuid': workoutUuid,
    };
  }

  static Map<String, dynamic> changesResponse({
    String nextToken = 'next-token',
    bool hasMore = false,
    bool changesTokenExpired = false,
  }) {
    return {
      'changes': [
        {'type': 'upsert', 'dataTypeKey': HealthDataType.HEART_RATE.name, 'dataPoint': numericPoint()},
        {'type': 'delete', 'recordId': 'deleted-record-1'},
      ],
      'nextChangesToken': nextToken,
      'hasMore': hasMore,
      'changesTokenExpired': changesTokenExpired,
    };
  }
}
