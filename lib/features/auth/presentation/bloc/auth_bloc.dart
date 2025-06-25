
import 'package:blogpost_colln/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogpost_colln/core/usercase/usecase.dart';
import 'package:blogpost_colln/core/common/entities/user.dart';
import 'package:blogpost_colln/features/auth/domain/usecases/current_user.dart';
import 'package:blogpost_colln/features/auth/domain/usecases/sign_out.dart';
import 'package:blogpost_colln/features/auth/domain/usecases/user_login.dart';
import 'package:blogpost_colln/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  final SignOut _signOut;


  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
    required SignOut signOut,
    })
      : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser=currentUser,
        _appUserCubit=appUserCubit,
        _signOut=signOut,
        super(AuthInitial()) {
    on<AuthEvent>((_,emit)=>(AuthLoading()));
    on<AuthsignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);  
    on<AuthIsUserLoggedin>(_isUserLoggedIn);
    on<AuthSignOut>(_onLogout);

  }

  void  _onAuthSignUp(AuthsignUp event, Emitter<AuthState> emit) async {
    final res = await _userSignUp(UserSignUpParams(email: event.email, password: event.password, name: event.name));

    res.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => _emitAuthSuccess(user,emit));
  }

  void  _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final res = await _userLogin(UserLoginParams(email: event.email, password: event.password));

    res.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => _emitAuthSuccess(user,emit),
    );
  }

  void _isUserLoggedIn(AuthIsUserLoggedin event, Emitter<AuthState> emit) async{
    final res=await _currentUser(NoParams());
   res.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) { 
        _emitAuthSuccess(user, emit);
        }
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }


void _onLogout(AuthSignOut event, Emitter<AuthState> emit) async {
  emit(AuthLoading());

  final result = await _signOut(NoParams());

  result.fold(
    (failure) => emit(AuthFailure(message: failure.message)),
    (_) {
      _appUserCubit.logout(); // or updateUser(null)
      emit(AuthLoggedOut()); // ✅ Correct state
    },
  );
}

}