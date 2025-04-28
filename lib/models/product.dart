class Product {
  final int id;
  final String title;
  final double price;
  final double rating;

  Product({required this.id, required this.title, required this.price, required this.rating});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      rating: (json['rating']['rate'] as num).toDouble(),
    );
  }
}
