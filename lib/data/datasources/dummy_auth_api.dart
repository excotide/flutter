import 'dart:convert';

import 'package:http/http.dart' as http;

class DummyAuthApi {
  static const _baseUrl = 'https://dummyjson.com';
  static const _loginPaths = [
    '/auth/login',
    '/user/login',
    '/users/login',
  ];

  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    final username = await _resolveUsername(identifier);

    String? lastError;
    for (final path in _loginPaths) {
      final response = await http.post(
        Uri.parse('$_baseUrl$path'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'expiresInMins': 30,
        }),
      );

      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return jsonMap;
      }

      lastError = jsonMap['message'] as String?;
    }

    throw Exception(lastError ?? 'Login gagal');
  }

  Future<String> _resolveUsername(String identifier) async {
    final cleaned = identifier.trim();
    if (!cleaned.contains('@')) {
      return cleaned;
    }

    final uri = Uri.parse('$_baseUrl/users/filter').replace(
      queryParameters: {
        'key': 'email',
        'value': cleaned,
      },
    );

    final response = await http.get(uri);
    final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      throw Exception(
        jsonMap['message'] as String? ?? 'Gagal memproses email login',
      );
    }

    final users = (jsonMap['users'] as List<dynamic>? ?? []);
    if (users.isEmpty) {
      throw Exception('Email tidak ditemukan');
    }

    return (users.first as Map<String, dynamic>)['username'] as String? ?? cleaned;
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final split = fullName.trim().split(RegExp(r'\s+'));
    final firstName = split.isNotEmpty ? split.first : 'User';
    final lastName = split.length > 1 ? split.sublist(1).join(' ') : 'Dummy';
    final username = email.split('@').first;

    final response = await http.post(
      Uri.parse('$_baseUrl/users/add'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'username': username,
        'password': password,
      }),
    );

    final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonMap;
    }

    throw Exception(jsonMap['message'] as String? ?? 'Register gagal');
  }
}
