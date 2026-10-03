class Isp {
  final int? id;
  final String? ruc;
  final String name;


  Isp({
    this.id,
    required this.ruc,
    required this.name,
  });


  factory Isp.fromJson(Map<String, dynamic> json) {
    return Isp(
      id: json['id'],
      ruc: json['ruc'],
      name: json['name'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ruc': ruc,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'Isp(id: $id, ruc: $ruc, name: $name)';
  }
}

