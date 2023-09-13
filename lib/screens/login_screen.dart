import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_login/constants/strings.dart';
import 'package:user_login/screens/timer_screen.dart';
import '../bloc/authentication_bloc.dart';
import '../bloc/connectivity_service.dart';
import '../widgets/genie_dialog.dart';

class LoginScreen extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;

  const LoginScreen({Key? key, required this.authenticationBloc})
      : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState(authenticationBloc);
}

class _LoginScreenState extends State<LoginScreen> {
  /// Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late final AuthenticationBloc authenticationBloc;
  final ConnectivityService connectivityService = ConnectivityService();

  _LoginScreenState(this.authenticationBloc);

  @override
  void initState() {
    super.initState();

    /// Check Internet connectivity
    connectivityService.connectivityStream.listen((connectivityResult) {
      if (connectivityResult == ConnectivityResult.none) {
        /// Show dialog box when network lost
        _showDialog(noInternetDescription, noInternetTitle);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(loginTitle),
        ),
        body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          /// If authenticated, navigate to timer screen
          if (state is AuthenticatedState) {
            Future.delayed(const Duration(seconds: 3), () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const TimerScreen()));
            });
          }
          /// TODO Handle UnauthenticatedState
          // else if (state is UnauthenticatedState) {
          //   return const SnackBar(content: Text(userNotFoundDescription));
          // }
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.tealAccent.shade400, Colors.teal.shade100],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /// User Icon
                  Card(
                    elevation: 5,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.tealAccent.shade400,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        shadows: <Shadow>[
                          Shadow(color: Colors.black, blurRadius: 50.0)
                        ],
                        size: 70,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Email Input Field
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: emailText,
                      prefixIcon: const Icon(Icons.alternate_email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Password Input Field
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: passwordText,
                      prefixIcon: const Icon(Icons.password_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Sign-in Button
                  ElevatedButton(
                    onPressed: () async {
                      final email = emailController.text;
                      final password = passwordController.text;

                      /// Check Network connectivity before proceed to login
                      final connectivityResult =
                          await Connectivity().checkConnectivity();
                      if (connectivityResult == ConnectivityResult.none) {
                        /// If no network, show dialog box with message
                        _showDialog(noInternetDescription, noInternetTitle);
                      } else if (email.isEmpty || password.isEmpty) {
                        /// If email or password are empty, show dialog box with message
                        _showDialog(
                            emailPasswordValidation, validationErrorTitle);
                      } else {
                        /// Else proceed for the login
                        authenticationBloc.add(LoginEvent(email, password));
                      }
                    },
                    child: const Text(loginButton),
                  ),
                ],
              ),
            ),
          );
        }));
  }

  _showDialog(String message, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GenieDialog(
          title: title,
          description: message,
        );
      },
    );
  }
}
