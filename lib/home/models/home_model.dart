class HomeModel {
  final String id;
  final String name;
  final String skill;
  final String location;
  final String contact;

  HomeModel({
    String? id,
    String? name,
    String? skill,
    String? location,
    String? contact,
  }) : id = id ?? '',
       name = name ?? '',
       skill = skill ?? '',
       location = location ?? '',
       contact = contact ?? '';

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      skill: json['skill'] as String?,
      location: json['location'] as String?,
      contact: json['contact'] as String?,
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
