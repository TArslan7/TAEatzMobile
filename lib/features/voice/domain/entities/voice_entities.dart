import 'package:equatable/equatable.dart';

// Voice Command Entity
class VoiceCommandEntity extends Equatable {
  final String id;
  final String userId;
  final String command;
  final String intent; // 'search', 'order', 'navigate', 'help'
  final Map<String, dynamic> parameters;
  final double confidence;
  final String language;
  final DateTime timestamp;

  const VoiceCommandEntity({
    required this.id,
    required this.userId,
    required this.command,
    required this.intent,
    required this.parameters,
    required this.confidence,
    required this.language,
    required this.timestamp,
  });

  @override
  List<Object> get props => [id, userId, command, intent, parameters, confidence, language, timestamp];
}

// Voice Response Entity
class VoiceResponseEntity extends Equatable {
  final String id;
  final String commandId;
  final String response;
  final String responseType; // 'text', 'audio', 'action'
  final Map<String, dynamic> data;
  final bool success;
  final String? errorMessage;
  final DateTime timestamp;

  const VoiceResponseEntity({
    required this.id,
    required this.commandId,
    required this.response,
    required this.responseType,
    required this.data,
    required this.success,
    this.errorMessage,
    required this.timestamp,
  });

  @override
  List<Object> get props => [id, commandId, response, responseType, data, success, errorMessage, timestamp];
}

// Voice Session Entity
class VoiceSessionEntity extends Equatable {
  final String id;
  final String userId;
  final String sessionId;
  final String status; // 'active', 'inactive', 'paused'
  final DateTime startedAt;
  final DateTime? endedAt;
  final List<VoiceCommandEntity> commands;
  final Map<String, dynamic> context;

  const VoiceSessionEntity({
    required this.id,
    required this.userId,
    required this.sessionId,
    required this.status,
    required this.startedAt,
    this.endedAt,
    required this.commands,
    required this.context,
  });

  @override
  List<Object> get props => [id, userId, sessionId, status, startedAt, endedAt, commands, context];
}

// Voice Intent Entity
class VoiceIntentEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> patterns;
  final Map<String, dynamic> parameters;
  final String action;
  final double confidence;
  final bool isActive;

  const VoiceIntentEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.patterns,
    required this.parameters,
    required this.action,
    required this.confidence,
    required this.isActive,
  });

  @override
  List<Object> get props => [id, name, description, patterns, parameters, action, confidence, isActive];
}

// Voice Language Entity
class VoiceLanguageEntity extends Equatable {
  final String id;
  final String code;
  final String name;
  final String nativeName;
  final bool isSupported;
  final Map<String, dynamic> settings;

  const VoiceLanguageEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.nativeName,
    required this.isSupported,
    required this.settings,
  });

  @override
  List<Object> get props => [id, code, name, nativeName, isSupported, settings];
}

// Voice Audio Entity
class VoiceAudioEntity extends Equatable {
  final String id;
  final String audioData;
  final String format; // 'wav', 'mp3', 'aac'
  final int duration; // in milliseconds
  final int sampleRate;
  final int bitRate;
  final String language;
  final DateTime createdAt;

  const VoiceAudioEntity({
    required this.id,
    required this.audioData,
    required this.format,
    required this.duration,
    required this.sampleRate,
    required this.bitRate,
    required this.language,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, audioData, format, duration, sampleRate, bitRate, language, createdAt];
}

// Voice Transcription Entity
class VoiceTranscriptionEntity extends Equatable {
  final String id;
  final String audioId;
  final String text;
  final double confidence;
  final String language;
  final List<VoiceWordEntity> words;
  final DateTime createdAt;

  const VoiceTranscriptionEntity({
    required this.id,
    required this.audioId,
    required this.text,
    required this.confidence,
    required this.language,
    required this.words,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, audioId, text, confidence, language, words, createdAt];
}

// Voice Word Entity
class VoiceWordEntity extends Equatable {
  final String word;
  final double confidence;
  final int startTime; // in milliseconds
  final int endTime; // in milliseconds

  const VoiceWordEntity({
    required this.word,
    required this.confidence,
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object> get props => [word, confidence, startTime, endTime];
}

// Voice Settings Entity
class VoiceSettingsEntity extends Equatable {
  final String id;
  final String userId;
  final bool isEnabled;
  final String language;
  final double sensitivity;
  final bool wakeWordEnabled;
  final String wakeWord;
  final bool continuousListening;
  final int timeoutDuration; // in seconds
  final bool feedbackEnabled;
  final bool transcriptionEnabled;

  const VoiceSettingsEntity({
    required this.id,
    required this.userId,
    required this.isEnabled,
    required this.language,
    required this.sensitivity,
    required this.wakeWordEnabled,
    required this.wakeWord,
    required this.continuousListening,
    required this.timeoutDuration,
    required this.feedbackEnabled,
    required this.transcriptionEnabled,
  });

  @override
  List<Object> get props => [id, userId, isEnabled, language, sensitivity, wakeWordEnabled, wakeWord, continuousListening, timeoutDuration, feedbackEnabled, transcriptionEnabled];
}

// Voice Analytics Entity
class VoiceAnalyticsEntity extends Equatable {
  final String id;
  final String userId;
  final String metricType; // 'command_count', 'success_rate', 'response_time'
  final double value;
  final String period; // 'daily', 'weekly', 'monthly'
  final DateTime timestamp;

  const VoiceAnalyticsEntity({
    required this.id,
    required this.userId,
    required this.metricType,
    required this.value,
    required this.period,
    required this.timestamp,
  });

  @override
  List<Object> get props => [id, userId, metricType, value, period, timestamp];
}

// Voice Error Entity
class VoiceErrorEntity extends Equatable {
  final String id;
  final String userId;
  final String errorType; // 'recognition', 'processing', 'network', 'permission'
  final String errorMessage;
  final Map<String, dynamic> context;
  final DateTime timestamp;

  const VoiceErrorEntity({
    required this.id,
    required this.userId,
    required this.errorType,
    required this.errorMessage,
    required this.context,
    required this.timestamp,
  });

  @override
  List<Object> get props => [id, userId, errorType, errorMessage, context, timestamp];
}
