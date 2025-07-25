import 'package:blogpost_colln/core/error/exception.dart';
import 'package:blogpost_colln/core/error/failure.dart';
import 'package:blogpost_colln/features/auth/data/model/usr_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;


  Future<UserModel> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  });
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();
  

  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl({required this.supabaseClient});


  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;



  @override
  Future<UserModel> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  }) async{
    try{
      final response= await supabaseClient.auth.signUp(password: password, email: email, data: {
        'name': name,
      });
      if (response.user==null){
        throw ServerException('User is null, sign up failed');
      }

      return UserModel.fromJson(response.user!.toJson()).copyWith(
        email: currentUserSession!.user.email,
      ); 

    } on AuthException catch(e){
      throw  ServerException(e.message);
    }
    catch (e) {
      throw ServerException(e.toString());  
    }
    
  }

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async{
    try{
      final response= await supabaseClient.auth.signInWithPassword(password: password, email: email);
      if (response.user==null){
        throw ServerException('User is null, sign up failed');
      }

      return UserModel.fromJson(response.user!.toJson()).copyWith(
        email: currentUserSession!.user.email,
      );

    }on AuthException catch(e){
      throw  ServerException(e.message);
    }
     catch (e) {
      throw ServerException(e.toString());  
    }
    
  }
  
  @override
  Future<UserModel?> getCurrentUserData() async{
    try{
      if(currentUserSession!=null){
        final userData= await supabaseClient.from('profiles').select().eq('id',currentUserSession!.user.id);

        return UserModel.fromJson(userData.first).copyWith(
          email: currentUserSession!.user.email,
          
        );

      }

      return null;


    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
    
  }
  
  @override
  Future<void> signOut() async {
    try{
      await supabaseClient.auth.signOut();
      print('success');
    } catch(e){
      throw ServerException(e.toString());
    }
  }
}
