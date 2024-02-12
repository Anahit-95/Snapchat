import 'package:snapchat/core/common/repositories/validation_repository/validation_repo_impl.dart';
import 'package:snapchat/core/models/user_model.dart';

abstract class UsersDBRepo {
  Future<void> insertUser(UserModel user);

  Future<List<UserModel>> getAllUsers();

  Future<UserModel?> getUserByUsername(String username);
  Future<UserModel?> getUserByEmail(String email);
  Future<UserModel?> getUserByPhone(String phoneCode, String phoneNumber);

  Future<UserModel?> loginUser({
    required String password,
    required String text,
    required ValidationRepoImpl validationRepo,
  });

  Future<void> updateUser({
    required String oldUsername,
    required UserModel updatedUser,
  });
}
