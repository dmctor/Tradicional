class Contact {
  int? id;
  int dependencyId;
  String name;
  String lastName;
  String cellphone;
  String rank;
  String position;
  String birthday;

  Contact({
    this.id,
    required this.dependencyId,
    required this.name,
    required this.lastName,
    required this.cellphone,
    required this.rank,
    required this.position,
    required this.birthday,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      dependencyId: json['dependency_id'],
      name: json['name'],
      lastName: json['last_name'],
      cellphone: json['cellphone'],
      rank: json['rank'],
      position: json['position'],
      birthday: json['birthday'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dependency_id': dependencyId,
      'name': name,
      'last_name': lastName,
      'cellphone': cellphone,
      'rank': rank,
      'position': position,
      'birthday': birthday,
    };
  }

  @override
  String toString() {
    return 'Contact(id: $id, dependencyId: $dependencyId, name: $name, lastName: $lastName, '
        'cellphone: $cellphone, rank: $rank, position: $position, birthday: $birthday)';
  }
}
