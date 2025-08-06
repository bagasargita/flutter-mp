import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_mob/core/api/api_client.dart';
import 'package:smart_mob/core/error/failures.dart';
import 'package:smart_mob/core/utils/either.dart';
import 'package:smart_mob/features/auth/domain/entities/user.dart';
import 'package:smart_mob/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';

  AuthRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.login(
        credentials: {'email': email, 'password': password},
      );

      final userData = response.data!['user'] as Map<String, dynamic>;
      final user = User.fromJson(userData);

      await _saveUserData(user);
      await _saveToken(response.data!['access_token'] as String);

      return Right(user);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure(message: 'Invalid credentials'));
      }
      return Left(
        ServerFailure(
          message: e.message ?? 'Login failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(NetworkFailure(message: 'Network error occurred'));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    try {
      final response = await _apiClient.register(
        userData: {
          'email': email,
          'password': password,
          'name': name,
          if (phoneNumber != null) 'phone_number': phoneNumber,
        },
      );

      final userData = response.data!['user'] as Map<String, dynamic>;
      final user = User.fromJson(userData);

      await _saveUserData(user);
      await _saveToken(response.data!['access_token'] as String);

      return Right(user);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        return Left(InvalidInputFailure(message: 'Email already exists'));
      }
      return Left(
        ServerFailure(
          message: e.message ?? 'Registration failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(NetworkFailure(message: 'Network error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _apiClient.logout();
      await _clearUserData();
      return Right(null);
    } catch (e) {
      await _clearUserData();
      return Right(null);
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);

      if (userJson == null) {
        return Right(null);
      }

      final userData = Map<String, dynamic>.from(jsonDecode(userJson) as Map);
      final user = User.fromJson(userData);

      return Right(user);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get user data'));
    }
  }

  @override
  Future<Either<Failure, void>> saveUser(User user) async {
    try {
      await _saveUserData(user);
      return Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to save user data'));
    }
  }

  @override
  Future<Either<Failure, void>> clearUser() async {
    try {
      await _clearUserData();
      return Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to clear user data'));
    }
  }

  Future<void> _saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }
}
