
import 'package:blogpost_colln/core/error/failure.dart';
import 'package:blogpost_colln/core/usercase/usecase.dart';
import 'package:blogpost_colln/core/common/entities/user.dart';
import 'package:blogpost_colln/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogin implements UseCase<User,UserLoginParams> {
  final AuthRepository repository;

  const UserLogin({required this.repository});

  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
    return await repository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}







class UserLoginParams{
  final String email;
  final String password;
  UserLoginParams({
    required this.email,
    required this.password,
  });
}