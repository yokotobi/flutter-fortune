class Fortune {
  final int id;
  final String title;
  final String description;
  final String love;
  final String work;
  final String health;

  Fortune({
    required this.id,
    required this.title,
    required this.description,
    required this.love,
    required this.work,
    required this.health,
  });

  factory Fortune.fromJson(Map<String, dynamic> json) {
    return Fortune(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      love: json['love'] as String,
      work: json['work'] as String,
      health: json['health'] as String,
    );
  }
}
