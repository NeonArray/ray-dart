library;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ray_dart/src/exceptions/stop_execution_requested.dart';
import 'package:ray_dart/src/request.dart';

final class Client {
  int port;
  String host;
  String url;
  String projectName = '';

  Client({this.port = 23517, this.host = 'localhost'}) : url = '$host:$port';

  // Do not need futures here because we don't really give a shit if it
  // delivers. Plus it makes the fluent api style not possible afaik
  void send(Request request) {
    try {
      http
          .post(
            Uri.parse('http://$url'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'User-Agent': 'Ray 1.0',
              'Accept-Encoding': '',
            },
            encoding: Encoding.getByName('utf-8'),
            body: request.toJson(),
          )
          .timeout(const Duration(seconds: 2));
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<http.Response> _sendRaw(String uri) async {
    try {
      return await http.get(
        Uri.parse('http://$url/$uri'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'User-Agent': 'Ray 1.0',
          'Accept-Encoding': '',
        },
      ).timeout(const Duration(seconds: 2));
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> lockExists(String lockName) async {
    var queryString = Uri(queryParameters: {
      'hostname': host,
      'project_name': projectName,
    }).query;

    try {
      var url = '/locks/$lockName?$queryString';
      var response = await _sendRaw(url);
      if (response.statusCode != 200) {
        return false;
      }
      var data = jsonDecode(response.body);
      if (data.stop_execution ?? false) {
        throw StopExecutionRequested("Pause execution requested in Ray.");
      }

      return data.active ?? false;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
