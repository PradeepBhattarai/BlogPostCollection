import 'dart:async';
import 'dart:math';

import 'package:blogpost_colln/core/error/exception.dart';
import 'package:blogpost_colln/core/error/failure.dart';
import 'package:blogpost_colln/core/network/connection_checker.dart';
import 'package:blogpost_colln/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blogpost_colln/core/common/entities/user.dart';
import 'package:blogpost_colln/features/auth/data/model/usr_model.dart';
import 'package:blogpost_colln/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

class AuthRepositoryImpl implements AuthRepository{
  final  AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;


  AuthRepositoryImpl({required this.remoteDataSource,required this.connectionChecker});

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({required String email, required String password}) async{
    return _getUser(
      connectionChecker,
      () async => await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({required String email, required String password, required String name}) async{
    return _getUser(
      connectionChecker,
      () async => await remoteDataSource.signUpWithEmailPassword(
        email: email,
        password: password,
        name: name,
      ),
    );
  }
  
  @override
  Future<Either<Failure, User>> currentUser() async{
    try{

      if(!await (connectionChecker.isConnected)){
        final session=remoteDataSource.currentUserSession;
        if(session==null){
          return left(Failure(message: 'User not logged in!'));

        }
        return right(UserModel(id:session.user.id,email:session.user.email??'',name:''));
    }

      final user= await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return Left(Failure(message: 'User is not currently logged in'));
      }

      return Right(user);


    }on ServerException catch(e) {
      return Left(Failure(message: e.toString()));
    }
  }
  
  @override
@override
@override
Future<Either<Failure, void>> signOut() async {
  try {
    if (!await connectionChecker.isConnected) {
      return left(Failure(message: 'No internet connection'));
    }

    await remoteDataSource.signOut();
    print('success');

    return right(null);
  } on ServerException catch (e) {
    return left(Failure(message: e.message));
  } catch (e) {
    return left(Failure(message: 'Unexpected error: $e'));
  }
}

}
Future <Either<Failure,User>> _getUser(
  ConnectionChecker connectionChecker,
  Future<User> Function() fn,
  ) async {
  try {
    if(!await (connectionChecker.isConnected)){
      return left(Failure(message: 'No internet connection'));
    }
    final user = await fn();
    return Right(user);
  }on AuthException catch(e){
      throw  ServerException(e.message);
    }on ServerException catch (e) {
    return Left(Failure(message: e.message));
  }
}
