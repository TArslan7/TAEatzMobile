import 'package:equatable/equatable.dart';

// IoT Device Entity
class IoTDeviceEntity extends Equatable {
  final String id;
  final String userId;
  final String deviceId;
  final String name;
  final String type; // 'smart_fridge', 'smart_oven', 'smart_scale', 'wearable'
  final String manufacturer;
  final String model;
  final String firmwareVersion;
  final String status; // 'online', 'offline', 'error', 'maintenance'
  final Map<String, dynamic> capabilities;
  final Map<String, dynamic> settings;
  final DateTime lastSeen;
  final DateTime createdAt;
  final bool isActive;

  const IoTDeviceEntity({
    required this.id,
    required this.userId,
    required this.deviceId,
    required this.name,
    required this.type,
    required this.manufacturer,
    required this.model,
    required this.firmwareVersion,
    required this.status,
    required this.capabilities,
    required this.settings,
    required this.lastSeen,
    required this.createdAt,
    required this.isActive,
  });

  @override
  List<Object> get props => [id, userId, deviceId, name, type, manufacturer, model, firmwareVersion, status, capabilities, settings, lastSeen, createdAt, isActive];
}

// IoT Sensor Entity
class IoTSensorEntity extends Equatable {
  final String id;
  final String deviceId;
  final String sensorType; // 'temperature', 'humidity', 'weight', 'motion', 'light'
  final String name;
  final String unit;
  final double minValue;
  final double maxValue;
  final double currentValue;
  final String status; // 'active', 'inactive', 'error'
  final DateTime lastReading;
  final Map<String, dynamic> metadata;

  const IoTSensorEntity({
    required this.id,
    required this.deviceId,
    required this.sensorType,
    required this.name,
    required this.unit,
    required this.minValue,
    required this.maxValue,
    required this.currentValue,
    required this.status,
    required this.lastReading,
    required this.metadata,
  });

  @override
  List<Object> get props => [id, deviceId, sensorType, name, unit, minValue, maxValue, currentValue, status, lastReading, metadata];
}

// IoT Data Entity
class IoTDataEntity extends Equatable {
  final String id;
  final String deviceId;
  final String sensorId;
  final String dataType;
  final dynamic value;
  final String unit;
  final double quality; // 0.0 to 1.0
  final Map<String, dynamic> metadata;
  final DateTime timestamp;

  const IoTDataEntity({
    required this.id,
    required this.deviceId,
    required this.sensorId,
    required this.dataType,
    required this.value,
    required this.unit,
    required this.quality,
    required this.metadata,
    required this.timestamp,
  });

  @override
  List<Object> get props => [id, deviceId, sensorId, dataType, value, unit, quality, metadata, timestamp];
}

// IoT Command Entity
class IoTCommandEntity extends Equatable {
  final String id;
  final String deviceId;
  final String commandType; // 'set_temperature', 'start_cooking', 'weigh_item'
  final Map<String, dynamic> parameters;
  final String status; // 'pending', 'sent', 'executed', 'failed'
  final String? response;
  final DateTime createdAt;
  final DateTime? executedAt;
  final Map<String, dynamic> metadata;

  const IoTCommandEntity({
    required this.id,
    required this.deviceId,
    required this.commandType,
    required this.parameters,
    required this.status,
    this.response,
    required this.createdAt,
    this.executedAt,
    required this.metadata,
  });

  @override
  List<Object> get props => [id, deviceId, commandType, parameters, status, response, createdAt, executedAt, metadata];
}

// IoT Alert Entity
class IoTAlertEntity extends Equatable {
  final String id;
  final String deviceId;
  final String alertType; // 'temperature_high', 'low_battery', 'maintenance_due'
  final String severity; // 'low', 'medium', 'high', 'critical'
  final String message;
  final Map<String, dynamic> data;
  final String status; // 'active', 'acknowledged', 'resolved'
  final DateTime createdAt;
  final DateTime? acknowledgedAt;
  final DateTime? resolvedAt;

  const IoTAlertEntity({
    required this.id,
    required this.deviceId,
    required this.alertType,
    required this.severity,
    required this.message,
    required this.data,
    required this.status,
    required this.createdAt,
    this.acknowledgedAt,
    this.resolvedAt,
  });

  @override
  List<Object> get props => [id, deviceId, alertType, severity, message, data, status, createdAt, acknowledgedAt, resolvedAt];
}

// IoT Automation Entity
class IoTAutomationEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String description;
  final String triggerType; // 'sensor_value', 'time', 'location', 'manual'
  final Map<String, dynamic> triggerConditions;
  final String actionType; // 'send_notification', 'execute_command', 'send_alert'
  final Map<String, dynamic> actionParameters;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastExecutedAt;
  final int executionCount;

  const IoTAutomationEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.triggerType,
    required this.triggerConditions,
    required this.actionType,
    required this.actionParameters,
    required this.isActive,
    required this.createdAt,
    this.lastExecutedAt,
    required this.executionCount,
  });

  @override
  List<Object> get props => [id, userId, name, description, triggerType, triggerConditions, actionType, actionParameters, isActive, createdAt, lastExecutedAt, executionCount];
}

// IoT Integration Entity
class IoTIntegrationEntity extends Equatable {
  final String id;
  final String userId;
  final String integrationType; // 'smart_home', 'wearable', 'restaurant_kitchen'
  final String platform; // 'alexa', 'google_home', 'samsung_smartthings', 'apple_homekit'
  final String status; // 'connected', 'disconnected', 'error'
  final Map<String, dynamic> credentials;
  final Map<String, dynamic> settings;
  final DateTime connectedAt;
  final DateTime? lastSyncAt;
  final bool isActive;

  const IoTIntegrationEntity({
    required this.id,
    required this.userId,
    required this.integrationType,
    required this.platform,
    required this.status,
    required this.credentials,
    required this.settings,
    required this.connectedAt,
    this.lastSyncAt,
    required this.isActive,
  });

  @override
  List<Object> get props => [id, userId, integrationType, platform, status, credentials, settings, connectedAt, lastSyncAt, isActive];
}

// IoT Analytics Entity
class IoTAnalyticsEntity extends Equatable {
  final String id;
  final String deviceId;
  final String metricType; // 'usage_time', 'energy_consumption', 'data_points'
  final double value;
  final String period; // 'hourly', 'daily', 'weekly', 'monthly'
  final DateTime timestamp;
  final Map<String, dynamic> context;

  const IoTAnalyticsEntity({
    required this.id,
    required this.deviceId,
    required this.metricType,
    required this.value,
    required this.period,
    required this.timestamp,
    required this.context,
  });

  @override
  List<Object> get props => [id, deviceId, metricType, value, period, timestamp, context];
}

// IoT Error Entity
class IoTErrorEntity extends Equatable {
  final String id;
  final String deviceId;
  final String errorType; // 'connection', 'sensor', 'command', 'data'
  final String errorCode;
  final String errorMessage;
  final Map<String, dynamic> context;
  final DateTime timestamp;
  final String status; // 'new', 'investigating', 'resolved'

  const IoTErrorEntity({
    required this.id,
    required this.deviceId,
    required this.errorType,
    required this.errorCode,
    required this.errorMessage,
    required this.context,
    required this.timestamp,
    required this.status,
  });

  @override
  List<Object> get props => [id, deviceId, errorType, errorCode, errorMessage, context, timestamp, status];
}

// IoT Settings Entity
class IoTSettingsEntity extends Equatable {
  final String id;
  final String userId;
  final bool notificationsEnabled;
  final bool dataCollectionEnabled;
  final bool automationEnabled;
  final int dataRetentionDays;
  final String timezone;
  final Map<String, dynamic> privacySettings;
  final Map<String, dynamic> deviceSettings;

  const IoTSettingsEntity({
    required this.id,
    required this.userId,
    required this.notificationsEnabled,
    required this.dataCollectionEnabled,
    required this.automationEnabled,
    required this.dataRetentionDays,
    required this.timezone,
    required this.privacySettings,
    required this.deviceSettings,
  });

  @override
  List<Object> get props => [id, userId, notificationsEnabled, dataCollectionEnabled, automationEnabled, dataRetentionDays, timezone, privacySettings, deviceSettings];
}
