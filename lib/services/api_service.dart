import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/app_user.dart';
import '../models/post.dart';
import 'api_exceptions.dart';

/// Centralised networking layer for the app.
///
/// Talks to the public JSONPlaceholder REST API and converts every
/// failure mode (no connection, timeout, bad status code, malformed
/// JSON) into a typed [ApiException] so the UI can react accordingly.
class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration _timeout = Duration(seconds: 12);

  Future<dynamic> _getJson(String path) async {
    final uri = Uri.parse('$_baseUrl$path');
    late http.Response response;

    try {
      response = await _client.get(uri).timeout(_timeout);
    } on TimeoutException {
      throw TimeoutApiException();
    } on SocketException {
      throw NoConnectionException();
    } on HttpException {
      throw NoConnectionException('Could not reach the server. Please try again.');
    } on FormatException {
      throw ParsingException();
    } catch (e) {
      throw UnknownApiException(e.toString());
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ServerException(response.statusCode);
    }

    try {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      throw ParsingException();
    }
  }

  /// GET /posts — used for the "HTTP Requests and JSON Parsing" task.
  Future<List<Post>> fetchPosts() async {
    final data = await _getJson('/posts');
    if (data is! List) throw ParsingException();
    return data
        .map((e) => Post.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  /// GET /users — used for the "Fetching and Displaying User Data" task.
  Future<List<AppUser>> fetchUsers() async {
    final data = await _getJson('/users');
    if (data is! List) throw ParsingException();
    return data
        .map((e) => AppUser.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  /// GET /users/:id — fetch a single user profile.
  Future<AppUser> fetchUserById(int id) async {
    final data = await _getJson('/users/$id');
    if (data is! Map<String, dynamic>) throw ParsingException();
    return AppUser.fromJson(data);
  }

  void dispose() => _client.close();
}
