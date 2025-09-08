import 'package:equatable/equatable.dart';

abstract class RealtimeState extends Equatable {
  const RealtimeState();

  @override
  List<Object> get props => [];
}

class RealtimeInitial extends RealtimeState {
  const RealtimeInitial();
}

class RealtimeConnecting extends RealtimeState {
  const RealtimeConnecting();
}

class RealtimeConnected extends RealtimeState {
  final String connectionId;
  final DateTime connectedAt;

  const RealtimeConnected({
    required this.connectionId,
    required this.connectedAt,
  });

  @override
  List<Object> get props => [connectionId, connectedAt];
}

class RealtimeDisconnected extends RealtimeState {
  final String reason;

  const RealtimeDisconnected(this.reason);

  @override
  List<Object> get props => [reason];
}

class RealtimeError extends RealtimeState {
  final String message;
  final String? errorCode;

  const RealtimeError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object> get props => [message, errorCode ?? ''];
}

class RealtimeMessageReceivedState extends RealtimeState {
  final Map<String, dynamic> message;
  final String messageType;

  const RealtimeMessageReceivedState({
    required this.message,
    required this.messageType,
  });

  @override
  List<Object> get props => [message, messageType];
}

class RealtimeOrderUpdate extends RealtimeState {
  final String orderId;
  final String status;
  final Map<String, dynamic> data;

  const RealtimeOrderUpdate({
    required this.orderId,
    required this.status,
    required this.data,
  });

  @override
  List<Object> get props => [orderId, status, data];
}

class RealtimeLocationUpdate extends RealtimeState {
  final String orderId;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  const RealtimeLocationUpdate({
    required this.orderId,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  @override
  List<Object> get props => [orderId, latitude, longitude, timestamp];
}

class RealtimeNotificationReceived extends RealtimeState {
  final String notificationId;
  final String title;
  final String message;
  final String type;
  final Map<String, dynamic> data;

  const RealtimeNotificationReceived({
    required this.notificationId,
    required this.title,
    required this.message,
    required this.type,
    required this.data,
  });

  @override
  List<Object> get props => [notificationId, title, message, type, data];
}

class RealtimeChatMessageReceived extends RealtimeState {
  final String groupId;
  final String messageId;
  final String senderId;
  final String message;
  final DateTime timestamp;

  const RealtimeChatMessageReceived({
    required this.groupId,
    required this.messageId,
    required this.senderId,
    required this.message,
    required this.timestamp,
  });

  @override
  List<Object> get props => [groupId, messageId, senderId, message, timestamp];
}
