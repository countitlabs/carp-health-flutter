part of '../health.dart';

/// Compatibility facade for applications written against health 8.x.
///
/// New code can use [Health] directly. Keeping this facade in the package lets
/// existing applications select Google Fit or Health Connect without changing
/// their call sites while the migration is in progress.
class HealthFactory {
  HealthFactory({bool useHealthConnectIfAvailable = false, DeviceInfoPlugin? deviceInfo})
    : _useHealthConnectIfAvailable = useHealthConnectIfAvailable,
      _health = Health(
        deviceInfo: deviceInfo,
        // GOOGLE FIT TEMPORARY SUPPORT - REMOVE START ----------------------------
        // When Google Fit is retired, keep this facade for Dart compatibility but
        // construct the Health Connect-only Health instance unconditionally.
        androidProvider: useHealthConnectIfAvailable
            ? AndroidHealthProvider.healthConnect
            : AndroidHealthProvider.googleFit,
        // GOOGLE FIT TEMPORARY SUPPORT - REMOVE END ------------------------------
      );

  final bool _useHealthConnectIfAvailable;
  final Health _health;

  bool get useHealthConnectIfAvailable => _useHealthConnectIfAvailable;
  HealthPlatformType get platformType => _health.platformType;
  String get deviceId => _health.deviceId;

  Future<void> configure() => _health.configure();

  bool isDataTypeAvailable(HealthDataType dataType) => _health.isDataTypeAvailable(dataType);

  Future<bool?> hasPermissions(
    List<HealthDataType> types, {
    List<HealthDataAccess>? permissions,
    bool backgroundRead = false,
  }) async {
    final granted = await _health.hasPermissions(types, permissions: permissions);
    if (granted != true || !backgroundRead || !_useHealthConnectIfAvailable) {
      return granted;
    }
    return _health.isHealthDataInBackgroundAuthorized();
  }

  Future<bool> requestAuthorization(
    List<HealthDataType> types, {
    List<HealthDataAccess>? permissions,
    bool backgroundRead = false,
  }) async {
    final granted = await _health.requestAuthorization(types, permissions: permissions);
    if (!granted || !backgroundRead || !_useHealthConnectIfAvailable) {
      return granted;
    }

    if (await _health.isHealthDataInBackgroundAvailable()) {
      await _health.requestHealthDataInBackgroundAuthorization();
    }
    return _health.isHealthDataInBackgroundAuthorized();
  }

  Future<bool> hasBackgroundPermission() => _health.isHealthDataInBackgroundAuthorized();

  Future<bool> revokePermissions() => _health.revokePermissions();

  /// Backwards-compatible Health Connect disconnect behavior.
  Future<bool> disconnect() => _health.revokePermissions();

  Future<List<HealthDataPoint>> getHealthDataFromTypes(
    DateTime startTime,
    DateTime endTime,
    List<HealthDataType> types, {
    int? limit,
  }) => _health.getHealthDataFromTypes(startTime: startTime, endTime: endTime, types: types, limit: limit);

  Future<int?> getTotalStepsInInterval(DateTime startTime, DateTime endTime) =>
      _health.getTotalStepsInInterval(startTime, endTime);

  Future<double?> getTotalDistanceInterval(DateTime startTime, DateTime endTime) =>
      _health.getTotalDistanceInterval(startTime, endTime);

  Future<WorkoutRouteHealthValue?> getWorkoutRoute(String workoutUuid) => _health.getWorkoutRoute(workoutUuid);

  Future<bool> isExerciseRoutesAuthorized() => _health.isExerciseRoutesAuthorized();

  Future<(bool presented, List<WorkoutRouteLocation>? locations)> requestExerciseRoute(String sessionUuid) =>
      _health.requestExerciseRoute(sessionUuid);

  Future<bool> writeHealthData(
    double value,
    HealthDataType type,
    DateTime startTime,
    DateTime endTime, {
    HealthDataUnit? unit,
  }) => _health.writeHealthData(value: value, type: type, startTime: startTime, endTime: endTime, unit: unit);

  Future<bool> writeWorkoutData(
    HealthWorkoutActivityType activityType,
    DateTime start,
    DateTime end, {
    int? totalEnergyBurned,
    HealthDataUnit totalEnergyBurnedUnit = HealthDataUnit.KILOCALORIE,
    int? totalDistance,
    HealthDataUnit totalDistanceUnit = HealthDataUnit.METER,
  }) => _health.writeWorkoutData(
    activityType: activityType,
    start: start,
    end: end,
    totalEnergyBurned: totalEnergyBurned,
    totalEnergyBurnedUnit: totalEnergyBurnedUnit,
    totalDistance: totalDistance,
    totalDistanceUnit: totalDistanceUnit,
  );

  static List<HealthDataPoint> removeDuplicates(List<HealthDataPoint> points) =>
      LinkedHashSet<HealthDataPoint>.of(points).toList();
}
