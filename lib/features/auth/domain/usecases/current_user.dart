import 'package:blogpost_colln/core/error/failure.dart';
import 'package:blogpost_colln/core/usercase/usecase.dart';
import 'package:blogpost_colln/core/common/entities/user.dart';
import 'package:blogpost_colln/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<User,NoParams>{
  final AuthRepository authRepository;

  CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async{

    return await authRepository.currentUser();
    
    
  }


}

