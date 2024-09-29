import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/NetworkServices.dart';
import '../services/api_services.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;
  List<dynamic> productsList = [];
  bool Overlay = false;
  bool Overlay_update = false;

  get getOverlay {
    return Overlay;
  }

  bool get showOverlay_update => Overlay_update;

  set showOverlay(bool showOverlay) {
    Overlay = showOverlay;
    notifyListeners();
  }
  set showOverlay_update(bool showOverlay) {
    Overlay_update = showOverlay;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    productsList = await ApiService.getProducts();
    map_products();
    print("productsList-------------------->: $productsList");
    notifyListeners(); // Notify listeners about the updated product list
  }

  Future<void> addProduct(String name, String description, String price) async {
    await ApiService.addProduct(name, description, price);
    await fetchProducts();
    notifyListeners(); // Refresh the product list after adding
  }

  void map_products() {
    _products.clear();
    for (var product in productsList) {
      _products.add(
        Product(
          id: product['id'].toString(),
          name: product['name'],
          description: product['description'],
          price: product['price'].toString(),
        ),
      );
    }
  }

  void deleteProduct(Product product) async{
    final id=int.parse(product.id!);
    _products.remove(product);
    notifyListeners();
    final response_paeser = NetworkService();
    await response_paeser.Delete("/api/products/$id");
    await fetchProducts();
    notifyListeners();
  }

  void updateProduct(String id, String name, String description, String price) async {
    final product = _products.firstWhere((p) => p.id == id);
    if (product != null) {
      final product_id = int.parse(id);
      final response_paeser = NetworkService();
      final body = {
        "name": name,
        "description": description,
        "price": price
      };
      await response_paeser.put("/api/products/$product_id", body);
      product.name = name;
      product.description = description;
      product.price = price;
      await fetchProducts();
      notifyListeners();
    }
  }
}
