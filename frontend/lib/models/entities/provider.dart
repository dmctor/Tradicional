class Provider {
  int? id;
  String ruc;
  String name;
  String logo;

  Provider({
    this.id,
    required this.ruc,
    required this.name,
    required this.logo,
  });

  // Crear instancia desde JSON
  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json['id'],
      ruc: json['ruc'],
      name: json['name'],
      logo: json['logo'],
    );
  }

  // Convertir instancia a mapa (para guardar o enviar)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ruc': ruc,
      'name': name,
      'logo': logo,
    };
  }

  @override
  String toString() {
    return 'Provider(id: $id, ruc: $ruc, name: $name, logo: $logo)';
  }
}
