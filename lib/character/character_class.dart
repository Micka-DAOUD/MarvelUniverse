class Character {
  final String name;
  final String description;
  final String imageUrl;

  Character({
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    String imagePath = json['thumbnail']['path'];
    String imageExtension = json['thumbnail']['extension'];

    return Character(
      name: json['name'],
      description: json['description'],
      imageUrl: "$imagePath.$imageExtension",
    );
  }
}