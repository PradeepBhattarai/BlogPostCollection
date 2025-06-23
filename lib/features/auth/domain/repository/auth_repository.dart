import 'package:blogpost_colln/core/error/failure.dart';
import 'package:blogpost_colln/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure,User>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure,User>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure,User>> currentUser();

}