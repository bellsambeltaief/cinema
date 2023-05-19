class Movie {
  final String title;
  final String category;

  Movie

  ({required this.title, required this.category});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      category: json['category'],
    );
  }
}
