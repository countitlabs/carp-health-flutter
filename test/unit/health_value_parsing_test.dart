import 'package:flutter_test/flutter_test.dart';
import 'package:health/health.dart';

import '../support/fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HealthDataPoint parsing', () {
    test('parses numeric health data points', () {
      final point = HealthDataPoint.fromHealthDataPoint(HealthDataType.HEART_RATE, HealthFixtures.numericPoint(), null);

      expect(point.type, HealthDataType.HEART_RATE);
      expect(point.value, isA<NumericHealthValue>());
      final value = point.value as NumericHealthValue;
      expect(value.numericValue, 72);
    });

    test('parses Health Connect elevation gained in meters', () {
      final point = HealthDataPoint.fromHealthDataPoint(
        HealthDataType.ELEVATION_GAINED,
        HealthFixtures.numericPoint(value: 42.5, sourceId: 'health-connect-record-id'),
        null,
      );

      expect(point.type, HealthDataType.ELEVATION_GAINED);
      expect(point.unit, HealthDataUnit.METER);
      expect((point.value as NumericHealthValue).numericValue, 42.5);
      expect(point.sourceId, 'health-connect-record-id');
    });

    test('parses workout health data points', () {
      final point = HealthDataPoint.fromHealthDataPoint(
        HealthDataType.WORKOUT,
        HealthFixtures.workoutPoint(),
        HealthDataUnit.NO_UNIT.name,
      );

      expect(point.type, HealthDataType.WORKOUT);
      expect(point.value, isA<WorkoutHealthValue>());
      final value = point.value as WorkoutHealthValue;
      expect(value.workoutActivityType, HealthWorkoutActivityType.RUNNING);
      expect(value.totalEnergyBurned, 200);
      expect(value.totalDistance, 5000);
      expect(value.duration, 3600);
      expect(value.durationUnit, 'second');
      expect(value.activityName, 'Morning run');
      expect(value.totalElevationAscended, 120);
      expect(value.totalElevationAscendedUnit, HealthDataUnit.METER);
      expect(value.totalElevationDescended, 95);
      expect(value.totalElevationDescendedUnit, HealthDataUnit.METER);
      expect(value.averageSpeed, 2.5);
      expect(value.averageSpeedUnit, HealthDataUnit.METER_PER_SECOND);
    });

    test('preserves individual Health Connect calorie records', () {
      final point = HealthDataPoint.fromHealthDataPoint(
        HealthDataType.WORKOUT,
        HealthFixtures.workoutPoint(
          activityName: '56',
          totalEnergyBurned: null,
          totalEnergyBurnedUnit: null,
          energyBurnedValues: const [120.25, 79.75],
        ),
        HealthDataUnit.NO_UNIT.name,
      );

      final value = point.value as WorkoutHealthValue;
      expect(value.activityName, '56');
      expect(value.totalEnergyBurned, isNull);
      expect(value.totalEnergyBurnedUnit, isNull);
      expect(value.energyBurnedValues, [120.25, 79.75]);
      expect(value.energyBurnedValuesUnit, HealthDataUnit.KILOCALORIE);
    });

    test('parses workout route health data points', () {
      final point = HealthDataPoint.fromHealthDataPoint(
        HealthDataType.WORKOUT_ROUTE,
        HealthFixtures.workoutRoutePoint(),
        HealthDataUnit.NO_UNIT.name,
      );

      expect(point.type, HealthDataType.WORKOUT_ROUTE);
      expect(point.value, isA<WorkoutRouteHealthValue>());
      final value = point.value as WorkoutRouteHealthValue;
      expect(value.locations, hasLength(1));
      expect(value.workoutUuid, 'workout-uuid-1');
      expect(value.locations.first.latitude, 37.3349);
    });
  });
}
