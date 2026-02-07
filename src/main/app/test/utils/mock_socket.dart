import 'dart:async';

import 'package:spend_spent_spent/utils/models/socket_message.dart';
import 'package:spend_spent_spent/utils/reconnectable_web_socket.dart';

class MockSocket extends ReconnectableWebSocket {
  MockSocket({required super.uri});

  final StreamController<String> _sentMessageStreamController = StreamController<String>.broadcast();

  Stream<String> get sentMessageStream => _sentMessageStreamController.stream;

  @override
  void connect() {
    print('Connected to socket');
  }

  @override
  void send(String message) {
    _sentMessageStreamController.add(message);
  }

  void receiveMessage(SssSocketMessage message){
    controller.add(message);
  }

  @override
  Future<void> close() async {
    print('Disconnected from socket');
  }
}
