import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taeatz_mobile/core/services/realtime_service.dart';
import 'package:taeatz_mobile/features/realtime/presentation/bloc/realtime_event.dart';
import 'package:taeatz_mobile/features/realtime/presentation/bloc/realtime_state.dart';

class RealtimeBloc extends Bloc<RealtimeEvent, RealtimeState> {
  final RealtimeService _realtimeService;
  StreamSubscription<Map<String, dynamic>>? _messageSubscription;
  StreamSubscription<String>? _connectionSubscription;

  RealtimeBloc({RealtimeService? realtimeService})
      : _realtimeService = realtimeService ?? RealtimeService.instance,
        super(const RealtimeInitial()) {
    on<InitializeRealtime>(_onInitializeRealtime);
    on<ConnectRealtime>(_onConnectRealtime);
    on<DisconnectRealtime>(_onDisconnectRealtime);
    on<SubscribeToOrderUpdates>(_onSubscribeToOrderUpdates);
    on<UnsubscribeFromOrderUpdates>(_onUnsubscribeFromOrderUpdates);
    on<SubscribeToNotifications>(_onSubscribeToNotifications);
    on<SendLocationUpdate>(_onSendLocationUpdate);
    on<SendChatMessage>(_onSendChatMessage);
    on<UpdateUserPresence>(_onUpdateUserPresence);
    on<RealtimeMessageReceived>(_onRealtimeMessageReceived);
    on<RealtimeConnectionStatusChanged>(_onRealtimeConnectionStatusChanged);
  }

  Future<void> _onInitializeRealtime(
    InitializeRealtime event,
    Emitter<RealtimeState> emit,
  ) async {
    try {
      // Set up message stream listener
      _messageSubscription = _realtimeService.messageStream.listen(
        (message) {
          add(RealtimeMessageReceived(message));
        },
        onError: (error) {
          emit(RealtimeError(message: 'Message stream error: $error'));
        },
      );

      // Set up connection status listener
      _connectionSubscription = _realtimeService.connectionStream.listen(
        (status) {
          add(RealtimeConnectionStatusChanged(status));
        },
        onError: (error) {
          emit(RealtimeError(message: 'Connection stream error: $error'));
        },
      );

      // Auto-connect
      add(const ConnectRealtime());
    } catch (e) {
      emit(RealtimeError(message: 'Failed to initialize realtime: $e'));
    }
  }

  Future<void> _onConnectRealtime(
    ConnectRealtime event,
    Emitter<RealtimeState> emit,
  ) async {
    try {
      emit(const RealtimeConnecting());
      
      // Connect to WebSocket (using mock URL for now)
      await _realtimeService.connect('wss://mock-websocket.taeatz.com/realtime');
      
      // Simulate successful connection
      await Future.delayed(const Duration(seconds: 1));
      
      emit(RealtimeConnected(
        connectionId: 'conn_${DateTime.now().millisecondsSinceEpoch}',
        connectedAt: DateTime.now(),
      ));
    } catch (e) {
      emit(RealtimeError(message: 'Failed to connect: $e'));
    }
  }

  Future<void> _onDisconnectRealtime(
    DisconnectRealtime event,
    Emitter<RealtimeState> emit,
  ) async {
    try {
      _realtimeService.disconnect();
      emit(const RealtimeDisconnected('User disconnected'));
    } catch (e) {
      emit(RealtimeError(message: 'Failed to disconnect: $e'));
    }
  }

  Future<void> _onSubscribeToOrderUpdates(
    SubscribeToOrderUpdates event,
    Emitter<RealtimeState> emit,
  ) async {
    try {
      _realtimeService.subscribeToOrderUpdates(event.orderId);
    } catch (e) {
      emit(RealtimeError(message: 'Failed to subscribe to order updates: $e'));
    }
  }

  Future<void> _onUnsubscribeFromOrderUpdates(
    UnsubscribeFromOrderUpdates event,
    Emitter<RealtimeState> emit,
  ) async {
    try {
      // Implementation for unsubscribing
    } catch (e) {
      emit(RealtimeError(message: 'Failed to unsubscribe from order updates: $e'));
    }
  }

  Future<void> _onSubscribeToNotifications(
    SubscribeToNotifications event,
    Emitter<RealtimeState> emit,
  ) async {
    try {
      _realtimeService.subscribeToUserNotifications(event.userId);
    } catch (e) {
      emit(RealtimeError(message: 'Failed to subscribe to notifications: $e'));
    }
  }

  Future<void> _onSendLocationUpdate(
    SendLocationUpdate event,
    Emitter<RealtimeState> emit,
  ) async {
    try {
      _realtimeService.sendLocationUpdate(
        event.latitude,
        event.longitude,
        event.orderId,
      );
    } catch (e) {
      emit(RealtimeError(message: 'Failed to send location update: $e'));
    }
  }

  Future<void> _onSendChatMessage(
    SendChatMessage event,
    Emitter<RealtimeState> emit,
  ) async {
    try {
      _realtimeService.sendChatMessage(
        event.groupId,
        event.message,
        event.userId,
      );
    } catch (e) {
      emit(RealtimeError(message: 'Failed to send chat message: $e'));
    }
  }

  Future<void> _onUpdateUserPresence(
    UpdateUserPresence event,
    Emitter<RealtimeState> emit,
  ) async {
    try {
      _realtimeService.sendUserPresence(event.userId, event.status);
    } catch (e) {
      emit(RealtimeError(message: 'Failed to update user presence: $e'));
    }
  }

  Future<void> _onRealtimeMessageReceived(
    RealtimeMessageReceived event,
    Emitter<RealtimeState> emit,
  ) async {
    try {
      final message = event.message;
      final messageType = message['type'] as String? ?? 'unknown';

      switch (messageType) {
        case 'order_update':
          emit(RealtimeOrderUpdate(
            orderId: message['orderId'] as String? ?? '',
            status: message['status'] as String? ?? '',
            data: message['data'] as Map<String, dynamic>? ?? {},
          ));
          break;

        case 'location_update':
          emit(RealtimeLocationUpdate(
            orderId: message['orderId'] as String? ?? '',
            latitude: (message['latitude'] as num?)?.toDouble() ?? 0.0,
            longitude: (message['longitude'] as num?)?.toDouble() ?? 0.0,
            timestamp: DateTime.now(),
          ));
          break;

        case 'notification':
          emit(RealtimeNotificationReceived(
            notificationId: message['notificationId'] as String? ?? '',
            title: message['title'] as String? ?? '',
            message: message['message'] as String? ?? '',
            type: message['notificationType'] as String? ?? '',
            data: message['data'] as Map<String, dynamic>? ?? {},
          ));
          break;

        case 'chat_message':
          emit(RealtimeChatMessageReceived(
            groupId: message['groupId'] as String? ?? '',
            messageId: message['messageId'] as String? ?? '',
            senderId: message['senderId'] as String? ?? '',
            message: message['message'] as String? ?? '',
            timestamp: DateTime.now(),
          ));
          break;

        default:
          emit(RealtimeMessageReceivedState(
            message: message,
            messageType: messageType,
          ));
      }
    } catch (e) {
      emit(RealtimeError(message: 'Failed to process message: $e'));
    }
  }

  Future<void> _onRealtimeConnectionStatusChanged(
    RealtimeConnectionStatusChanged event,
    Emitter<RealtimeState> emit,
  ) async {
    try {
      switch (event.status) {
        case 'connected':
          emit(RealtimeConnected(
            connectionId: 'conn_${DateTime.now().millisecondsSinceEpoch}',
            connectedAt: DateTime.now(),
          ));
          break;
        case 'disconnected':
          emit(const RealtimeDisconnected('Connection lost'));
          break;
        case 'error':
          emit(const RealtimeError(message: 'Connection error'));
          break;
      }
    } catch (e) {
      emit(RealtimeError(message: 'Failed to handle connection status: $e'));
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _connectionSubscription?.cancel();
    _realtimeService.dispose();
    return super.close();
  }
}
