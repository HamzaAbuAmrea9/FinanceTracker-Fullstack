import 'dart:io';
import 'package:finance_tracker_app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/auth_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

// This class is necessary for HTTPS to work with the local .NET certificate in debug mode.
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Tracker',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      
      home: const AuthGate(),
    );
  }
}


class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Based on the authentication status, show the correct screen.
    if (authState.status == AuthStatus.authenticated) {
      return const HomeScreen();
    }
    
    // For all other states (unauthenticated, initial, loading, error) show the LoginScreen.
    
    // The LoginScreen will show a loading indicator if the state is 'loading'.
    return const LoginScreen();
  }
}