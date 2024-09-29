class Product {
  String? id;
  String? name;
  String? description;
  String? price;

  Product({required this.id, required this.name, required this.description, required this.price});

  factory Product.fromJson(Map<String, String> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
    );
  }
}

