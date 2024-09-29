import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkService {
  static const String baseUrl = "http://localhost:3000";
  String? apiKey = "";

  Future<Response> postRequest(
      String endpoint, Map<String, dynamic> body) async {
    // print('the key is $apiKey');
    final String url = baseUrl + endpoint;
    final headers = {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer $apiKey',
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      // Handle exceptions
      print("Exception: $e");
      throw Exception('Failed to make API request');
    }
  }

  Future<Map<String, dynamic>> postRequest_null(String endpoint) async {
    final String url = baseUrl + endpoint;
    final headers = {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer $apiKey',
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
      );
      return _handleResponse(response);
    } catch (e) {
      // Handle exceptions
      print("Exception: $e");
      throw Exception('Failed to make API request');
    }
  }

  Future<dynamic> get(String endpoint) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apiKey = prefs.getString('token');
    print('the key is $apiKey');
    try {
      final String url = baseUrl + endpoint;
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$apiKey',
        },
      );
      return _handleResponse(response);
    } catch (e) {
      // An error occurred
      print('Error at network service: $e');
    }
  }

  Future<dynamic> Delete(String endpoint) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apiKey = prefs.getString('token');
    try {
      final String url = baseUrl + endpoint;
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$apiKey',
        },
      );
      return _handleResponse(response);
    } catch (e) {
      // An error occurred
      print('Error: $e');
    }
  }

  Future<dynamic> put(String endpoint, Map<String, String> body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apiKey = prefs.getString('token');
    try {
      final String url = baseUrl + endpoint;
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$apiKey'
        },
        body: jsonEncode(body),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to make API request');
      }
      return _handleResponse(response);
    } catch (e) {
      print('Error in put: $e');
    }
  }

  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      // Successful request, parse the response
      dynamic responseData = jsonDecode(response.body);
      return responseData;
    } else {
      // Handle error
      print("Error: ${response.statusCode}");
      print("Response: ${response.body}");
      throw Exception('Failed to make API request');
    }
  }
}
