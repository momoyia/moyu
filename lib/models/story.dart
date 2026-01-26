class Story {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final String content;
  final int likes;
  final DateTime createdAt;
  final List<String>? tags;
  final String? location;
  final String? avatarUrl;
  final String? category;
  final String? discoveryCategory;

  Story({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.content,
    required this.likes,
    required this.createdAt,
    this.tags,
    this.location,
    this.avatarUrl,
    this.category,
    this.discoveryCategory,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      content: json['content'] ?? '',
      likes: json['likes'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      location: json['location'],
      avatarUrl: json['avatarUrl'],
      category: json['category'],
      discoveryCategory: json['discoveryCategory'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'imageUrl': imageUrl,
      'content': content,
      'likes': likes,
      'createdAt': createdAt.toIso8601String(),
      'tags': tags,
      'location': location,
      'avatarUrl': avatarUrl,
      'category': category,
      'discoveryCategory': discoveryCategory,
    };
  }
}
