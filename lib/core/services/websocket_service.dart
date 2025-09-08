import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  static WebSocketService? _instance;
  static WebSocketService get instance => _instance ??= WebSocketService._();
  
  WebSocketService._();

  WebSocketChannel? _channel;
  String? _url;
  StreamController<Map<String, dynamic>>? _messageController;
  Timer? _reconnectTimer;
  bool _isConnected = false;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 5);

  // Getters
  bool get isConnected => _isConnected;
  Stream<Map<String, dynamic>>? get messageStream => _messageController?.stream;

  // Initialize WebSocket connection
  Future<void> connect(String url) async {
    try {
      _url = url;
      _messageController = StreamController<Map<String, dynamic>>.broadcast();
      
      _channel = WebSocketChannel.connect(Uri.parse(url));
      
      _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
      );
      
      _isConnected = true;
      _reconnectAttempts = 0;
      
      debugPrint('WebSocket connected to: $url');
    } catch (e) {
      debugPrint('WebSocket connection error: $e');
      _scheduleReconnect(url);
    }
  }

  // Send message
  void send(Map<String, dynamic> message) {
    if (_isConnected && _channel != null) {
      try {
        _channel!.sink.add(jsonEncode(message));
        debugPrint('WebSocket sent: $message');
      } catch (e) {
        debugPrint('WebSocket send error: $e');
      }
    }
  }

  // Subscribe to specific events
  Stream<Map<String, dynamic>> subscribe(String eventType) {
    return messageStream?.where((message) => message['type'] == eventType) ?? 
           const Stream.empty();
  }

  // Handle incoming messages
  void _onMessage(dynamic message) {
    try {
      final data = jsonDecode(message);
      _messageController?.add(data);
      debugPrint('WebSocket received: $data');
    } catch (e) {
      debugPrint('WebSocket message parse error: $e');
    }
  }

  // Handle errors
  void _onError(dynamic error) {
    debugPrint('WebSocket error: $error');
    _isConnected = false;
    _scheduleReconnect(_url ?? '');
  }

  // Handle connection close
  void _onDone() {
    debugPrint('WebSocket connection closed');
    _isConnected = false;
    _scheduleReconnect(_url ?? '');
  }

  // Schedule reconnection
  void _scheduleReconnect(String url) {
    if (_reconnectAttempts < _maxReconnectAttempts) {
      _reconnectAttempts++;
      _reconnectTimer = Timer(_reconnectDelay, () {
        debugPrint('Attempting to reconnect... (${_reconnectAttempts}/$_maxReconnectAttempts)');
        connect(url);
      });
    } else {
      debugPrint('Max reconnection attempts reached');
    }
  }

  // Disconnect
  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    await _channel?.sink.close();
    await _messageController?.close();
    _isConnected = false;
    debugPrint('WebSocket disconnected');
  }

  // Cleanup
  void dispose() {
    disconnect();
    _instance = null;
  }
}

// WebSocket message types
class WebSocketMessage {
  static const String orderUpdate = 'order_update';
  static const String trackingUpdate = 'tracking_update';
  static const String notification = 'notification';
  static const String chatMessage = 'chat_message';
  static const String restaurantUpdate = 'restaurant_update';
  static const String menuUpdate = 'menu_update';
}

// WebSocket event handlers
class WebSocketHandlers {
  static void handleOrderUpdate(Map<String, dynamic> data) {
    // Handle order status updates
    debugPrint('Order update received: $data');
  }

  static void handleTrackingUpdate(Map<String, dynamic> data) {
    // Handle tracking updates
    debugPrint('Tracking update received: $data');
  }

  static void handleNotification(Map<String, dynamic> data) {
    // Handle push notifications
    debugPrint('Notification received: $data');
  }

  static void handleChatMessage(Map<String, dynamic> data) {
    // Handle chat messages
    debugPrint('Chat message received: $data');
  }
}

// WebSocket connection manager
class WebSocketManager {
  static final WebSocketService _service = WebSocketService.instance;
  
  static Future<void> initialize() async {
    // Initialize WebSocket connection
    await _service.connect('wss://api.taeatz.com/ws');
    
    // Set up event handlers
    _service.messageStream?.listen((message) {
      final type = message['type'] as String?;
      switch (type) {
        case WebSocketMessage.orderUpdate:
          WebSocketHandlers.handleOrderUpdate(message);
          break;
        case WebSocketMessage.trackingUpdate:
          WebSocketHandlers.handleTrackingUpdate(message);
          break;
        case WebSocketMessage.notification:
          WebSocketHandlers.handleNotification(message);
          break;
        case WebSocketMessage.chatMessage:
          WebSocketHandlers.handleChatMessage(message);
          break;
      }
    });
  }

  static void sendOrderUpdate(String orderId, String status) {
    _service.send({
      'type': WebSocketMessage.orderUpdate,
      'orderId': orderId,
      'status': status,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static void sendTrackingUpdate(String orderId, Map<String, dynamic> trackingData) {
    _service.send({
      'type': WebSocketMessage.trackingUpdate,
      'orderId': orderId,
      'data': trackingData,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static void sendChatMessage(String orderId, String message) {
    _service.send({
      'type': WebSocketMessage.chatMessage,
      'orderId': orderId,
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static Future<void> disconnect() async {
    await _service.disconnect();
  }
}
