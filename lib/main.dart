import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_login/screens/login_screen.dart';
import 'package:user_login/services/api_client.dart';
import 'bloc/authentication_bloc.dart';
import 'constants/strings.dart';

/// Dart Entry point
void main() {
  final authenticationBloc = AuthenticationBloc(APIClient());
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => authenticationBloc,
        ),
      ],
      child: MyApp(authenticationBloc),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthenticationBloc authenticationBloc;

  MyApp(this.authenticationBloc);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      debugShowCheckedModeBanner: false,
      /// Login Screen
      home: LoginScreen(authenticationBloc: authenticationBloc),
    );
  }
}