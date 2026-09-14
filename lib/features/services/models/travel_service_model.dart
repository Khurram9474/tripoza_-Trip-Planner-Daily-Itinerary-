class TravelService {
  final String id;
  final String name;
  final String category; // 'Hotels' | 'Tours' | 'Transportation' | 'Activities'
  final String location;
  final String description;
  final String imageUrl;
  final double rating;
  final double price;
  final String priceUnit; // e.g. 'per night', 'per person', 'per trip'
  final List<String> features;
  final bool isAvailable;

  const TravelService({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.price,
    required this.priceUnit,
    required this.features,
    this.isAvailable = true,
  });

  factory TravelService.fromJson(Map<String, dynamic> json) {
    return TravelService(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      location: json['location'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      priceUnit: json['priceUnit'] as String,
      features: List<String>.from(json['features'] as List),
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'location': location,
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
      'price': price,
      'priceUnit': priceUnit,
      'features': features,
      'isAvailable': isAvailable,
    };
  }
}