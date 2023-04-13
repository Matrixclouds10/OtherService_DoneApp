part of 'login_cubit.dart';

abstract class LoginlState {}

class LoginViewInitial extends LoginlState {}

class LoginViewLoading extends LoginlState {}

class LoginViewError extends LoginlState {
  final ErrorModel? _error;

  ErrorModel? get error => _error;

  LoginViewError({
    required ErrorModel? error,
  }) : _error = error;
}

class LoginViewSuccessfully extends LoginlState {}

// class LoginState {
//   ///Variables
//   bool isLoading = false;
//   String? error;
//
//   LoginState();
//
//   LoginState copyWith({
//     bool? isLoading,
//     String? error,
//   }) {
//     return LoginState()
//       ..isLoading = isLoading ?? this.isLoading
//       ..error = error ?? this.error;
//   }

//
// }
