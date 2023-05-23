import 'dart:html';

class TimeElement {
  final int hour;
  final int minute;

  TimeElement({
    required this.hour,
    required this.minute,
  });

  factory TimeElement.fromJson(Map<String, dynamic> json) {
    return TimeElement(
      hour: json['hour'],
      minute: json['minute'],
    );
  }
}

class Movie {
  final String id;
  final String title;
  final String category;
  final String description;
  final String? partner;
  final int age;
  final String type;
  final String image;
  final String video;
  final String imagesStars;
  final List? listProjection;
  final TimeElement? timestamps;

  Movie({
    required this.title,
    required this.timestamps,
    required this.category,
    required this.id,
    required this.description,
    this.partner,
    required this.age,
    required this.type,
    required this.image,
    required this.video,
    required this.imagesStars,
    this.listProjection,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'].toString(),
      id: json['_id'].toString(),
      category: json['categorie'],
      age: json['age'],
      type: json['type'].toString(),
      description: json['description'].toString(),
      image: json['image'].toString(),
      partner: json['partner'].toString(),
      timestamps: json['timestamps'] != null
          ? TimeElement.fromJson(json['timestamps'])
          : null,
      imagesStars:json['imagesStars'].toString(),
      video: json['video'].toString(),
    );
  }
}
