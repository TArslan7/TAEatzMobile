import 'package:equatable/equatable.dart';

class AccessibilitySettingsEntity extends Equatable {
  final String userId;
  final bool screenReaderEnabled;
  final bool highContrastEnabled;
  final bool largeTextEnabled;
  final double textScaleFactor;
  final bool voiceOverEnabled;
  final bool voiceCommandsEnabled;
  final bool hapticFeedbackEnabled;
  final bool reducedMotionEnabled;
  final bool colorBlindSupportEnabled;
  final ColorBlindType colorBlindType;
  final bool keyboardNavigationEnabled;
  final bool switchControlEnabled;
  final bool magnifierEnabled;
  final double magnifierScale;
  final List<String> enabledFeatures;
  final DateTime lastUpdated;

  const AccessibilitySettingsEntity({
    required this.userId,
    this.screenReaderEnabled = false,
    this.highContrastEnabled = false,
    this.largeTextEnabled = false,
    this.textScaleFactor = 1.0,
    this.voiceOverEnabled = false,
    this.voiceCommandsEnabled = false,
    this.hapticFeedbackEnabled = true,
    this.reducedMotionEnabled = false,
    this.colorBlindSupportEnabled = false,
    this.colorBlindType = ColorBlindType.none,
    this.keyboardNavigationEnabled = false,
    this.switchControlEnabled = false,
    this.magnifierEnabled = false,
    this.magnifierScale = 1.5,
    this.enabledFeatures = const [],
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
    userId,
    screenReaderEnabled,
    highContrastEnabled,
    largeTextEnabled,
    textScaleFactor,
    voiceOverEnabled,
    voiceCommandsEnabled,
    hapticFeedbackEnabled,
    reducedMotionEnabled,
    colorBlindSupportEnabled,
    colorBlindType,
    keyboardNavigationEnabled,
    switchControlEnabled,
    magnifierEnabled,
    magnifierScale,
    enabledFeatures,
    lastUpdated,
  ];
}

enum ColorBlindType {
  none,
  protanopia,
  deuteranopia,
  tritanopia,
  monochromacy,
}

class VoiceCommandEntity extends Equatable {
  final String id;
  final String userId;
  final String command;
  final String action;
  final Map<String, dynamic> parameters;
  final bool isEnabled;
  final DateTime createdAt;
  final DateTime? lastUsedAt;
  final int usageCount;

  const VoiceCommandEntity({
    required this.id,
    required this.userId,
    required this.command,
    required this.action,
    this.parameters = const {},
    this.isEnabled = true,
    required this.createdAt,
    this.lastUsedAt,
    this.usageCount = 0,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    command,
    action,
    parameters,
    isEnabled,
    createdAt,
    lastUsedAt,
    usageCount,
  ];
}

class AccessibilityFeatureEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final AccessibilityFeatureType type;
  final String iconUrl;
  final bool isEnabled;
  final Map<String, dynamic> configuration;
  final List<String> dependencies;
  final DateTime createdAt;
  final DateTime? lastUpdated;

  const AccessibilityFeatureEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.iconUrl,
    this.isEnabled = false,
    this.configuration = const {},
    this.dependencies = const [],
    required this.createdAt,
    this.lastUpdated,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    type,
    iconUrl,
    isEnabled,
    configuration,
    dependencies,
    createdAt,
    lastUpdated,
  ];
}

enum AccessibilityFeatureType {
  visual,
  auditory,
  motor,
  cognitive,
  speech,
  learning,
}

class AccessibilityEventEntity extends Equatable {
  final String id;
  final String userId;
  final AccessibilityEventType type;
  final String description;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final String? screenName;
  final String? action;

  const AccessibilityEventEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.description,
    this.data = const {},
    required this.timestamp,
    this.screenName,
    this.action,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    type,
    description,
    data,
    timestamp,
    screenName,
    action,
  ];
}

enum AccessibilityEventType {
  screenReaderAnnouncement,
  voiceCommandExecuted,
  hapticFeedbackTriggered,
  keyboardNavigation,
  switchControlActivated,
  magnifierUsed,
  highContrastToggled,
  textScaleChanged,
  colorBlindModeChanged,
  reducedMotionToggled,
}

class AccessibilityGuidelineEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final AccessibilityGuidelineType type;
  final String category;
  final List<String> tags;
  final String? imageUrl;
  final List<String> steps;
  final bool isImplemented;
  final DateTime createdAt;
  final DateTime? lastReviewed;

  const AccessibilityGuidelineEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    this.tags = const [],
    this.imageUrl,
    this.steps = const [],
    this.isImplemented = false,
    required this.createdAt,
    this.lastReviewed,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    type,
    category,
    tags,
    imageUrl,
    steps,
    isImplemented,
    createdAt,
    lastReviewed,
  ];
}

enum AccessibilityGuidelineType {
  wcag,
  ios,
  android,
  custom,
}

class AccessibilityTestEntity extends Equatable {
  final String id;
  final String userId;
  final String testName;
  final AccessibilityTestType type;
  final AccessibilityTestStatus status;
  final Map<String, dynamic> results;
  final List<String> issues;
  final List<String> recommendations;
  final DateTime createdAt;
  final DateTime? completedAt;

  const AccessibilityTestEntity({
    required this.id,
    required this.userId,
    required this.testName,
    required this.type,
    required this.status,
    this.results = const {},
    this.issues = const [],
    this.recommendations = const [],
    required this.createdAt,
    this.completedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    testName,
    type,
    status,
    results,
    issues,
    recommendations,
    createdAt,
    completedAt,
  ];
}

enum AccessibilityTestType {
  screenReader,
  keyboardNavigation,
  colorContrast,
  textScaling,
  voiceOver,
  switchControl,
  magnifier,
  hapticFeedback,
  voiceCommands,
  overall,
}

enum AccessibilityTestStatus {
  pending,
  running,
  completed,
  failed,
  cancelled,
}

class AccessibilityFeedbackEntity extends Equatable {
  final String id;
  final String userId;
  final String feedback;
  final AccessibilityFeedbackType type;
  final String? screenName;
  final String? featureName;
  final int rating;
  final List<String> attachments;
  final DateTime createdAt;
  final String? response;
  final DateTime? respondedAt;

  const AccessibilityFeedbackEntity({
    required this.id,
    required this.userId,
    required this.feedback,
    required this.type,
    this.screenName,
    this.featureName,
    required this.rating,
    this.attachments = const [],
    required this.createdAt,
    this.response,
    this.respondedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    feedback,
    type,
    screenName,
    featureName,
    rating,
    attachments,
    createdAt,
    response,
    respondedAt,
  ];
}

enum AccessibilityFeedbackType {
  bug,
  suggestion,
  complaint,
  praise,
  question,
  other,
}

class AccessibilityAnalyticsEntity extends Equatable {
  final String userId;
  final DateTime date;
  final int screenReaderUsage;
  final int voiceCommandUsage;
  final int hapticFeedbackUsage;
  final int keyboardNavigationUsage;
  final int magnifierUsage;
  final int highContrastUsage;
  final int textScalingUsage;
  final int voiceOverUsage;
  final int switchControlUsage;
  final Map<String, int> featureUsage;
  final List<String> mostUsedFeatures;
  final List<String> leastUsedFeatures;
  final double averageSessionDuration;
  final int totalSessions;

  const AccessibilityAnalyticsEntity({
    required this.userId,
    required this.date,
    this.screenReaderUsage = 0,
    this.voiceCommandUsage = 0,
    this.hapticFeedbackUsage = 0,
    this.keyboardNavigationUsage = 0,
    this.magnifierUsage = 0,
    this.highContrastUsage = 0,
    this.textScalingUsage = 0,
    this.voiceOverUsage = 0,
    this.switchControlUsage = 0,
    this.featureUsage = const {},
    this.mostUsedFeatures = const [],
    this.leastUsedFeatures = const [],
    this.averageSessionDuration = 0.0,
    this.totalSessions = 0,
  });

  @override
  List<Object?> get props => [
    userId,
    date,
    screenReaderUsage,
    voiceCommandUsage,
    hapticFeedbackUsage,
    keyboardNavigationUsage,
    magnifierUsage,
    highContrastUsage,
    textScalingUsage,
    voiceOverUsage,
    switchControlUsage,
    featureUsage,
    mostUsedFeatures,
    leastUsedFeatures,
    averageSessionDuration,
    totalSessions,
  ];
}
