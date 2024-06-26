import 'dart:convert';

class House {
  String? name;
  String? phone;
  String? address;
  String? price;
  String? description;
  List<String>? images;
  String? ownerId; // New field for storing the UID of the user who added the house
  String? houseId;

  House({
    this.name,
    this.phone,
    this.address,
    this.price,
    this.description,
    this.images,
    this.ownerId,
    this.houseId
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
      ownerId: map['ownerId'], // Retrieve ownerId from the map
      houseId: map['_id'],
    );
  }

  // Convert House object to a JSON string
  String toJson() {
    return json.encode(toMap());
  }

  // Create a House object from a JSON string
  static House fromJson(String jsonString) {
    final Map<String, dynamic> map = json.decode(jsonString);
    return fromMap(map);
  }
}
