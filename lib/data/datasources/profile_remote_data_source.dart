import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user_profile_model.dart';

class ProfileRemoteDataSource {
  final http.Client client;

  const ProfileRemoteDataSource(this.client);

  Future<UserProfileModel> fetchProfile() async {
    final response = await client.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil data profile: \'${response.statusCode}\'');
    }

    final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
    return UserProfileModel.fromJson(jsonMap);
  }
}
