part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {}

class AuthLogoutRequested extends AuthEvent {}

class AuthSwitchAccountRequested extends AuthEvent {
  final SaveUserModel selected;

  const AuthSwitchAccountRequested(this.selected);

  @override
  List<Object?> get props => [selected];
}
