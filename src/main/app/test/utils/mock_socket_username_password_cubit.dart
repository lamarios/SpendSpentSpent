import 'package:spend_spent_spent/identity/states/username_password.dart';

import 'mock_socket.dart';

class MockSocketUsernamePasswordCubit extends UsernamePasswordCubit {
  MockSocketUsernamePasswordCubit(super.initialState);

  @override
  Future<void> connectToSocket() async {
    socket = MockSocket(uri: Uri.parse('http://example.com'));
    socket?.connect();
  }
}
