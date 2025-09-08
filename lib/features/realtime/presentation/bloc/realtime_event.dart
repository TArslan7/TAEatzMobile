import 'package:equatable/equatable.dart';

abstract class RealtimeEvent extends Equatable {
  const RealtimeEvent();

  @override
  List<Object> get props => [];
}

class InitializeRealtime extends RealtimeEvent {
  const InitializeRealtime();
}

class ConnectRealtime extends RealtimeEvent {
  const ConnectRealtime();
}

class DisconnectRealtime extends RealtimeEvent {
  const DisconnectRealtime();
}

class SubscribeToOrderUpdates extends RealtimeEvent {
  final String orderId;

  const SubscribeToOrderUpdates(this.orderId);

  @override
  List<Object> get props => [orderId];
}

class UnsubscribeFromOrderUpdates extends RealtimeEvent {
  final String orderId;

  const UnsubscribeFromOrderUpdates(this.orderId);

  @override
  List<Object> get props => [orderId];
}

class SubscribeToNotifications extends RealtimeEvent {
  final String userId;

  const SubscribeToNotifications(this.userId);

  @override
  List<Object> get props => [userId];
}

class SendLocationUpdate extends RealtimeEvent {
  final double latitude;
  final double longitude;
  final String orderId;

  const SendLocationUpdate({
    required this.latitude,
    required this.longitude,
    required this.orderId,
  });

  @override
  List<Object> get props => [latitude, longitude, orderId];
}

class SendChatMessage extends RealtimeEvent {
  final String groupId;
  final String message;
  final String userId;

  const SendChatMessage({
    required this.groupId,
    required this.message,
    required this.userId,
  });

  @override
  List<Object> get props => [groupId, message, userId];
}

class UpdateUserPresence extends RealtimeEvent {
  final String userId;
  final String status;

  const UpdateUserPresence({
    required this.userId,
    required this.status,
  });

  @override
  List<Object> get props => [userId, status];
}

class RealtimeMessageReceived extends RealtimeEvent {
  final Map<String, dynamic> message;

  const RealtimeMessageReceived(this.message);

  @override
  List<Object> get props => [message];
}

class RealtimeConnectionStatusChanged extends RealtimeEvent {
  final String status;

  const RealtimeConnectionStatusChanged(this.status);

  @override
  List<Object> get props => [status];
}
