class Website {
  final int id;
  final String name;

  Website({required this.id, required this.name});

  factory Website.fromJson(Map<String, dynamic> json) {
    return Website(
      id: json['id'],
      name: json['name'],
    );
  }
}
