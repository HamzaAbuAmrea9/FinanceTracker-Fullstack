
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/api_service.dart';

final apiServiceProvider = Provider((ref) => ApiService());
final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(apiServiceProvider), ref.read(secureStorageProvider));
});

enum AuthStatus { initial, authenticated, unauthenticated, loading, error }

class AuthState {
  final AuthStatus status;
  final String? token;
  final String? errorMessage;

  AuthState({this.status = AuthStatus.initial, this.token, this.errorMessage});
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _apiService;
  final FlutterSecureStorage _storage;

  AuthNotifier(this._apiService, this._storage) : super(AuthState()) {
    _tryAutoLogin();
  }

  Future<void> _tryAutoLogin() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token != null && token.isNotEmpty) {
      state = AuthState(status: AuthStatus.authenticated, token: token);
    } else {
      state = AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> login(String username, String password) async {
    state = AuthState(status: AuthStatus.loading);
    try {
      final token = await _apiService.login(username, password);
      if (token != null) {
        await _storage.write(key: 'jwt_token', value: token);
        state = AuthState(status: AuthStatus.authenticated, token: token);
      } else {
        state = AuthState(status: AuthStatus.error, errorMessage: 'Login Failed. Please check your credentials.');
      }
    } catch (e) {
      state = AuthState(status: AuthStatus.error, errorMessage: 'An error occurred during login.');
    }
  }

  
  Future<bool> register(String username, String password) async {
    state = AuthState(status: AuthStatus.loading);
    try {
      final success = await _apiService.register(username, password);
      if (success) {
        
        state = AuthState(status: AuthStatus.unauthenticated);
        return true;
      } else {
        state = AuthState(status: AuthStatus.error, errorMessage: 'Registration Failed. Username may already exist.');
        return false;
      }
    } catch (e) {
      state = AuthState(status: AuthStatus.error, errorMessage: 'An error occurred during registration.');
      return false;
    }
  }
  
  

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    state = AuthState(status: AuthStatus.unauthenticated);
  }
}