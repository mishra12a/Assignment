import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:product_management_system_frontend/services/NetworkServices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/user.dart';

class ApiService {
  static const String baseUrl = "http://localhost:3000";
  // Fetch Products
  static Future<List<dynamic>> getProducts() async {
   final request_parser = NetworkService();
    final response = await request_parser.get("/api/getproducts");
   print("productsList response-------------------->: ${response}");
    return response;
  }

  // Add Product
  static Future<void> addProduct(String name, String description, String price) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var headers = {
      'authorization': token!,
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('http://localhost:3000/api/products'));
    request.body =
        json.encode({"name": name, "description": description, "price": price});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      print("code nahi chalraha");
    }
  }
}
