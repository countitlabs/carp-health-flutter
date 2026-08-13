package cachet.plugins.health

import android.content.Context
import androidx.health.connect.client.records.metadata.Device
import androidx.health.connect.client.records.metadata.Metadata

/** Maps Health Connect provenance to the same source contract used by HealthKit. */
class HealthConnectMetadataMapper(context: Context) {
    private val packageManager = context.applicationContext.packageManager
    private val sourceNames = mutableMapOf<String, String>()

    fun fields(metadata: Metadata): Map<String, Any?> = mapOf(
        "source_id" to metadata.dataOrigin.packageName,
        "source_name" to sourceName(metadata.dataOrigin.packageName),
        "device_id" to deviceName(metadata.device),
    )

    fun sourceName(packageName: String): String = sourceNames.getOrPut(packageName) {
        runCatching {
            @Suppress("DEPRECATION")
            val applicationInfo = packageManager.getApplicationInfo(packageName, 0)
            packageManager.getApplicationLabel(applicationInfo).toString()
        }.getOrDefault(packageName)
    }
}

internal fun deviceName(device: Device?): String? {
    if (device == null) return null

    val manufacturer = device.manufacturer?.trim().orEmpty()
    val model = device.model?.trim().orEmpty()

    return when {
        manufacturer.isEmpty() && model.isEmpty() -> null
        manufacturer.isEmpty() -> model
        model.isEmpty() -> manufacturer
        model.startsWith(manufacturer, ignoreCase = true) -> model
        else -> "$manufacturer $model"
    }
}
