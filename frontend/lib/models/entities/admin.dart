class Admin {
  int? id;
  String username;
  String? password;
  List<int>? listProvider;

  Admin({
    this.id,
    required this.username,
    this.password,
    this.listProvider,
  });

  // Método para crear una instancia desde un mapa (JSON)
  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      listProvider: List<int>.from(json['listProvider'] ?? []),
    );
  }

  // Método para convertir la instancia a un mapa (JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'listProvider': listProvider,
    };
  }

  @override
  String toString() {
    return 'Admin(id: $id, username: $username, password: $password, listProvider: $listProvider)';
  }
}
