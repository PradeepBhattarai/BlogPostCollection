

import 'package:blogpost_colln/core/common/entities/user.dart';
import 'package:blogpost_colln/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class GoogleSignInUseCase<NoParams>{
  final AuthRepository authRepository;

  GoogleSignInUseCase(this.authRepository);


  Future<Either<String,User>> call() async{
    return await authRepository.googleSignIn();
  }
}