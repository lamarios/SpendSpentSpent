import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:spend_spent_spent/utils/models/socket_message.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ReconnectableWebSocket {
  final Logger _log = Logger('Reconnectable Web Socket');
  final Uri uri;
  final Map<String, dynamic>? headers;
  final bool isWeb;

  WebSocketChannel? _channel;
  final StreamController<SssSocketMessage> _controller = StreamController<SssSocketMessage>.broadcast();

  Stream<SssSocketMessage> get stream => _controller.stream;

  StreamSubscription? _subscription;
  Function()? onConnected;
  Function()? onDisconnected;

  bool _manuallyClosed = false;
  int _reconnectDelay = 2; // seconds, grows with backoff

  ReconnectableWebSocket({required this.uri, this.headers, this.isWeb = false});

  void connect() {
    _log.fine('connecting to socket ${uri.toString()}');
    _manuallyClosed = false;

    try {
      _channel = WebSocketChannel.connect(uri);

      _subscription = _channel!.stream.listen(
        (message) {
          _log.fine("Received web socket message: $message");
          final decoded = jsonDecode(message);
          _controller.add(SssSocketMessage.fromJson(decoded));
        },
        onDone: _handleDisconnect,
        onError: (error) {
          _log.info("WebSocket error: $error");
          _handleDisconnect();
        },
      );

      if (onConnected != null) onConnected!();
      _log.fine("✅ Connected to $uri");

      _reconnectDelay = 2; // reset on success
    } catch (e) {
      _log.fine("❌ Connection failed: $e");
      _scheduleReconnect();
    }
  }

  void send(String message) {
    _channel?.sink.add(message);
  }

  Future<void> close() async {
    _manuallyClosed = true;
    await _subscription?.cancel();
    await _channel?.sink.close();
    _subscription = null;
    _channel = null;
    if (onDisconnected != null) onDisconnected!();
  }

  Future<void> _handleDisconnect() async {
    await _subscription?.cancel();
    await _channel?.sink.close();
    _subscription = null;
    _channel = null;

    if (_manuallyClosed) {
      _log.fine("🔌 Disconnected manually.");
      return;
    }

    _log.fine("⚡ Connection lost, will retry in $_reconnectDelay seconds...");
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    Future.delayed(Duration(seconds: _reconnectDelay), () {
      if (!_manuallyClosed) {
        connect();
        _reconnectDelay = (_reconnectDelay * 2).clamp(2, 60);
      }
    });
  }
}
