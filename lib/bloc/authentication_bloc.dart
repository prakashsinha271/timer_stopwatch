import 'package:bloc/bloc.dart';

import '../services/api_client.dart';

// Events
abstract class AuthenticationEvent {}

class LoginEvent extends AuthenticationEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

// States
abstract class AuthenticationState {}

class AuthenticatedState extends AuthenticationState {}

class UnauthenticatedState extends AuthenticationState {}

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final APIClient apiClient;

  AuthenticationBloc(this.apiClient) : super(UnauthenticatedState()) {
    on<LoginEvent>((event, emit) async {
      try {
        final response = await apiClient.login(event.email, event.password);
        print(response.statusCode);
        if (response.statusCode == 200) {
          emit(AuthenticatedState());
        } else {
          emit(UnauthenticatedState());
        }
      } catch (_) {
        emit(UnauthenticatedState());
      }
    });
  }

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {}
}
