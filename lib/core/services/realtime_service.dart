import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class RealtimeService {
  static RealtimeService? _instance;
  static RealtimeService get instance => _instance ??= RealtimeService._();
  
  RealtimeService._();

  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _messageController;
  StreamController<String>? _connectionController;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  String? _url;
  
  bool _isConnected = false;
  int _reconnectAttempts = 0;
  static const int maxReconnectAttempts = 5;
  static const Duration reconnectDelay = Duration(seconds: 5);

  // Connection Management
  Future<void> connect(String url) async {
    try {
      _url = url;
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _messageController = StreamController<Map<String, dynamic>>.broadcast();
      _connectionController = StreamController<String>.broadcast();
      
      _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
      );
      
      _isConnected = true;
      _reconnectAttempts = 0;
      _startHeartbeat();
      
      debugPrint('WebSocket connected to: $url');
      _connectionController?.add('connected');
      
    } catch (e) {
      debugPrint('WebSocket connection failed: $e');
      _scheduleReconnect(url);
    }
  }

  void disconnect() {
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    _channel?.sink.close(status.goingAway);
    _isConnected = false;
    _connectionController?.add('disconnected');
    debugPrint('WebSocket disconnected');
  }

  // Message Handling
  void _onMessage(dynamic message) {
    try {
      final data = json.decode(message);
      _messageController?.add(data);
      debugPrint('WebSocket message received: $data');
    } catch (e) {
      debugPrint('Error parsing WebSocket message: $e');
    }
  }

  void _onError(error) {
    debugPrint('WebSocket error: $error');
    _isConnected = false;
    _connectionController?.add('error');
  }

  void _onDone() {
    debugPrint('WebSocket connection closed');
    _isConnected = false;
    _connectionController?.add('disconnected');
    _scheduleReconnect(_url ?? '');
  }

  // Reconnection Logic
  void _scheduleReconnect(String url) {
    if (_reconnectAttempts >= maxReconnectAttempts) {
      debugPrint('Max reconnection attempts reached');
      return;
    }
    
    _reconnectAttempts++;
    debugPrint('Attempting to reconnect... ($_reconnectAttempts/$maxReconnectAttempts)');
    
    _reconnectTimer = Timer(reconnectDelay, () {
      connect(url);
    });
  }

  // Heartbeat
  void _startHeartbeat() {
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_isConnected) {
        sendMessage({
          'type': 'ping',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
      }
    });
  }

  // Message Sending
  void sendMessage(Map<String, dynamic> message) {
    if (_isConnected && _channel != null) {
      try {
        _channel!.sink.add(json.encode(message));
        debugPrint('WebSocket message sent: $message');
      } catch (e) {
        debugPrint('Error sending WebSocket message: $e');
      }
    } else {
      debugPrint('WebSocket not connected, cannot send message');
    }
  }

  // Streams
  Stream<Map<String, dynamic>> get messageStream => 
      _messageController?.stream ?? const Stream.empty();
  
  Stream<String> get connectionStream => 
      _connectionController?.stream ?? const Stream.empty();

  // Specific Message Types
  void subscribeToOrderUpdates(String orderId) {
    sendMessage({
      'type': 'subscribe',
      'channel': 'order_updates',
      'orderId': orderId,
    });
  }

  void subscribeToRestaurantUpdates(String restaurantId) {
    sendMessage({
      'type': 'subscribe',
      'channel': 'restaurant_updates',
      'restaurantId': restaurantId,
    });
  }

  void subscribeToUserNotifications(String userId) {
    sendMessage({
      'type': 'subscribe',
      'channel': 'user_notifications',
      'userId': userId,
    });
  }

  void subscribeToChatMessages(String groupId) {
    sendMessage({
      'type': 'subscribe',
      'channel': 'chat_messages',
      'groupId': groupId,
    });
  }

  void sendChatMessage(String groupId, String message, String userId) {
    sendMessage({
      'type': 'chat_message',
      'groupId': groupId,
      'message': message,
      'userId': userId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  void sendOrderUpdate(String orderId, String status, Map<String, dynamic> data) {
    sendMessage({
      'type': 'order_update',
      'orderId': orderId,
      'status': status,
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  void sendLocationUpdate(double latitude, double longitude, String orderId) {
    sendMessage({
      'type': 'location_update',
      'latitude': latitude,
      'longitude': longitude,
      'orderId': orderId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  void sendTypingIndicator(String groupId, String userId, bool isTyping) {
    sendMessage({
      'type': 'typing_indicator',
      'groupId': groupId,
      'userId': userId,
      'isTyping': isTyping,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  void sendUserPresence(String userId, String status) {
    sendMessage({
      'type': 'user_presence',
      'userId': userId,
      'status': status,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Real-time Features
  void startLiveTracking(String orderId) {
    sendMessage({
      'type': 'start_tracking',
      'orderId': orderId,
    });
  }

  void stopLiveTracking(String orderId) {
    sendMessage({
      'type': 'stop_tracking',
      'orderId': orderId,
    });
  }

  void joinGroupOrder(String groupId, String userId) {
    sendMessage({
      'type': 'join_group',
      'groupId': groupId,
      'userId': userId,
    });
  }

  void leaveGroupOrder(String groupId, String userId) {
    sendMessage({
      'type': 'leave_group',
      'groupId': groupId,
      'userId': userId,
    });
  }

  void updateGroupOrder(String groupId, Map<String, dynamic> orderData) {
    sendMessage({
      'type': 'update_group_order',
      'groupId': groupId,
      'data': orderData,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Analytics
  void trackRealtimeEvent(String eventType, Map<String, dynamic> data) {
    sendMessage({
      'type': 'analytics',
      'eventType': eventType,
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Connection Status
  bool get isConnected => _isConnected;
  
  int get reconnectAttempts => _reconnectAttempts;

  // Cleanup
  void dispose() {
    disconnect();
    _messageController?.close();
    _connectionController?.close();
  }
}

// Real-time Event Types
class RealtimeEventTypes {
  static const String orderUpdate = 'order_update';
  static const String locationUpdate = 'location_update';
  static const String chatMessage = 'chat_message';
  static const String typingIndicator = 'typing_indicator';
  static const String userPresence = 'user_presence';
  static const String groupOrderUpdate = 'group_order_update';
  static const String notification = 'notification';
  static const String restaurantUpdate = 'restaurant_update';
  static const String analytics = 'analytics';
  static const String ping = 'ping';
  static const String pong = 'pong';
}

// Connection Status
class ConnectionStatus {
  static const String connected = 'connected';
  static const String disconnected = 'disconnected';
  static const String connecting = 'connecting';
  static const String error = 'error';
  static const String reconnecting = 'reconnecting';
}
