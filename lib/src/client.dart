library;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ray_dart/src/exceptions/stop_execution_requested.dart';
import 'package:ray_dart/src/ray.dart';
import 'package:ray_dart/src/request.dart';

final class Client {
  final String _host;
  final String _url;

  Client({int port = 23517, String host = 'localhost'})
      : _host = host,
        _url = '$host:$port';

  // Do not need futures here because we don't really give a shit if it
  // delivers. Plus it makes the fluent api style not possible afaik
  void send(Request request) {
    try {
      http
          .post(
            Uri.parse('http://$_url'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'User-Agent': 'Ray 1.0',
              'Accept-Encoding': '',
            },
            encoding: Encoding.getByName('utf-8'),
            body: request.toJson(),
          )
          .timeout(const Duration(seconds: 2));
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<http.Response> _sendRaw(String uri) async {
    try {
      return await http.get(
        Uri.parse('http://$_url/$uri'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'User-Agent': 'Ray 1.0',
          'Accept-Encoding': '',
        },
      ).timeout(const Duration(seconds: 2));
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<bool> lockExists(String lockName) async {
    final queryString = Uri(queryParameters: {
      'hostname': _host,
      'project_name': Ray.projectName,
    }).query;

    try {
      final url = '/locks/$lockName?$queryString';
      final response = await _sendRaw(url);

      if (response.statusCode != 200) {
        return false;
      }

      final data = jsonDecode(response.body);

      if (data.stop_execution ?? false) {
        throw StopExecutionRequested("Pause execution requested in Ray.");
      }

      return data.active ?? false;
    } catch (_) {
      rethrow;
    }
  }
}
