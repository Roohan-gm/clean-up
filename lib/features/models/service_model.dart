class ServicesModel {
  final String id;
  final String name;
  final double price;
  final String image;
  final String description;
  int quantity;

  ServicesModel(
      {required this.id,
      required this.name,
      required this.price,
      required this.description,
      this.quantity = 1,
      required this.image});

  // Factory constructor with enhancements
  factory ServicesModel.fromJson(Map<String, dynamic> json) {
    // Ensure price is treated as a double
    final price = json['price'];
    final priceAsDouble = price is int ? price.toDouble() : price.toDouble();

    return ServicesModel(
      id: json['id'] ?? '',
      // Defaults to an empty string if 'id' is null or missing
      name: json['name'] ?? '',
      // Defaults to an empty string if 'name' is null or missing
      price: priceAsDouble, // Always store as double
      // Converts 'price' to double, defaults to 0.0 if null
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      // Defaults to an empty string if 'image' is null or missing
      quantity: json['quantity'] ??
          1, // Defaults to an empty string if 'image' is null or missing
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'description': description,
      'quantity': quantity
    };
  }
}
