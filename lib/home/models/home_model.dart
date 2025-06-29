class HomeModel {
  final String id;
  final String name;
  final String skill;
  final String location;
  final String contact;
  final String image;
  final num price;

  HomeModel({
    this.id = '',
    this.name = '',
    this.skill = '',
    this.location = '',
    this.contact = '',
    this.image = '',
    this.price = 0,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      skill: json['skill'] ?? '',
      location: json['location'] ?? '',
      contact: json['contact'] ?? '',
      price: json['price'] ?? 0,
      image: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'skill': skill,
      'location': location,
      'contact': contact,
    };
  }
}
