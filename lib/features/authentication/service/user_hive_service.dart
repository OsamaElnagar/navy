import 'package:hive/hive.dart';
import '../model/user_response.dart';

class UserHiveService {
  final Box<UserResponse> userBox;

  UserHiveService(this.userBox);

  Future<UserResponse> saveUser(UserResponse userResponse) async {
    await userBox.put('user', userResponse);
    return userResponse;
  }

  Future<UserResponse> updateUser(User user) async {
    final existingResponse = getUser();
    if (existingResponse == null) {
      throw Exception('No user data found');
    }

    final updatedResponse = existingResponse.copyWith(user: user);
    await userBox.put('user', updatedResponse);
    return updatedResponse;
  }

  UserResponse? getUser() {
    return userBox.get('user');
  }

  Future<void> clearUser() async {
    await userBox.delete('user');
  }
}
