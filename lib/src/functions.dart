part of '../health.dart';

/// Custom Exception for the plugin. Used when a Health Data Type is requested,
/// but not available on the current platform.
class HealthException implements Exception {
  /// Data Type that was requested.
  dynamic dataType;

  /// Cause of the exception.
  String cause;

  HealthException(this.dataType, this.cause);

  @override
  String toString() => "Error requesting health data type '$dataType' - cause: $cause";
}

/// Error codes for iOS HealthKit [PlatformException]s thrown by this plugin.
class HealthKitErrorCode {
  HealthKitErrorCode._();

  /// Protected HealthKit data is inaccessible, usually because the device is locked.
  static const databaseInaccessible = 'HEALTHKIT_DATABASE_INACCESSIBLE';

  /// A generic HealthKit failure.
  static const error = 'HEALTHKIT_ERROR';

  /// The native error was unavailable.
  static const unknown = 'HEALTHKIT_UNKNOWN_ERROR';
}

/// The status of Google Health Connect.
///
/// **NOTE** - The enum order is arbitrary. If you need the native value,
/// use [nativeValue] and not the index.
///
/// Reference:
/// https://developer.android.com/reference/kotlin/androidx/health/connect/client/HealthConnectClient#constants_1
enum HealthConnectSdkStatus {
  /// https://developer.android.com/reference/kotlin/androidx/health/connect/client/HealthConnectClient#SDK_UNAVAILABLE()
  sdkUnavailable(1),

  /// https://developer.android.com/reference/kotlin/androidx/health/connect/client/HealthConnectClient#SDK_UNAVAILABLE_PROVIDER_UPDATE_REQUIRED()
  sdkUnavailableProviderUpdateRequired(2),

  /// https://developer.android.com/reference/kotlin/androidx/health/connect/client/HealthConnectClient#SDK_AVAILABLE()
  sdkAvailable(3);

  const HealthConnectSdkStatus(this.nativeValue);

  /// The native value that matches the value in the Android SDK.
  final int nativeValue;

  factory HealthConnectSdkStatus.fromNativeValue(int value) {
    return HealthConnectSdkStatus.values.firstWhere(
      (e) => e.nativeValue == value,
      orElse: () => HealthConnectSdkStatus.sdkUnavailable,
    );
  }
}
