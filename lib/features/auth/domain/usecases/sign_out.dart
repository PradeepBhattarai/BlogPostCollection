import 'package:fpdart/fpdart.dart';
import 'package:blogpost_colln/core/error/failure.dart';
import 'package:blogpost_colln/core/usercase/usecase.dart';
import 'package:blogpost_colln/features/auth/domain/repository/auth_repository.dart';

class SignOut implements UseCase<void, NoParams> {
  final AuthRepository authRepository;

  SignOut(this.authRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return authRepository.signOut();
  }
}
