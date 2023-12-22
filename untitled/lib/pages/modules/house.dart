class House {
  String? name;
  String? phone;
  String? address;
  String? price;
  String? description;
  List<String>? images;

  House({
    this.name,
    this.phone,
    this.address,
    this.price,
    this.description,
    this.images,
  });

  // Convert House object to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'price': price,
      'description': description,
      'images': images,
    };
  }

  // Create a House object from a Map
  static House fromMap(Map<String, dynamic> map) {
    return House(
      name: map['name'],
      phone: map['phone'],
      address: map['address'],
      price: map['price'],
      description: map['description'],
      images: List<String>.from(map['images'] ?? []),
    );
  }
}
