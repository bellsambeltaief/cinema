class Movie {
  final String id;
  final String title;
  final String category;
  final String? description;
  final String? partner;
  final int age;
  final String type;
  final String image;
  final String? video;
  final String? imagesStars;
  final List? listProjection;

  Movie({
    required this.title,
    required this.category,
    required this.id,
    this.description,
    this.partner,
    required this.age,
    required this.type,
    required this.image,
    this.video,
    this.imagesStars,
    this.listProjection,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'].toString(),
      id: json['_id'].toString(),
      category: json['categorie'].toString(),
      age: json['age'],
      type: json['type'].toString(),
      description: json['description'].toString(),
      image: json['image'].toString(),
      partner: json['partner'].toString(),
    );
  }
}
