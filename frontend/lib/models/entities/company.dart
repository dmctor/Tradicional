class Company {
  int? id;
  int addressId;
  String ruc;
  String name;

  Company({
    this.id,
    required this.addressId,
    required this.ruc,
    required this.name,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      addressId: json['address_id'],
      ruc: json['ruc'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address_id': addressId,
      'ruc': ruc,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'Company(id: $id, addressId: $addressId, ruc: $ruc, name: $name)';
  }
}
