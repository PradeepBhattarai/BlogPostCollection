import 'package:blogpost_colln/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';


abstract interface class UseCase<SuccessType,Params>{
  Future<Either<Failure, SuccessType>> call(Params params);
}


class NoParams {}