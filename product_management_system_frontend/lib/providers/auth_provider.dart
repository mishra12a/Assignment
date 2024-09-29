import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:product_management_system_frontend/services/NetworkServices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_services.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String? _token;
  String? get token => _token;
  final apiparser = NetworkService();
  
  Future<bool> signup(String username, String password) async {
    final userdata={
      "username": username,
      "passkey": password
    };
   final Response response = await apiparser.postRequest("/api/signup", userdata);
    return response.statusCode == 200;
  }

  Future<void> login(String username, String password) async {
    final userdata={
      "username": username,
      "passkey": password
    };
    final Response response = await apiparser.postRequest("/api/login", userdata);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final token = jsonResponse['token'];
      print(token);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token',token);
    }
    notifyListeners();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    _token = null;
    notifyListeners();
  }
}
