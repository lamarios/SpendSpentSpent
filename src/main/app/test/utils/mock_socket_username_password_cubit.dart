import 'package:spend_spent_spent/identity/states/username_password.dart';

class MockSocketUsernamePasswordCubit extends UsernamePasswordCubit {
  MockSocketUsernamePasswordCubit(super.initialState);

  @override
  Future<void> connectToSocket() async {
    print('connecting to socket');
  }
}
