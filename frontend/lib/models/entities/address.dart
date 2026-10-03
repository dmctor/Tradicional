class Address {
  int? id;
  String address;
  String district;
  String province;
  String department;
  String sector;

  Address({
    this.id,
    required this.address,
    required this.district,
    required this.province,
    required this.department,
    required this.sector,
  });

  // Método para crear una instancia desde un mapa (JSON)
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      address: json['address'],
      district: json['district'],
      province: json['province'],
      department: json['department'],
      sector: json['sector'],
    );
  }

  // Método para convertir la instancia a un mapa (JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address': address,
      'district': district,
      'province': province,
      'department': department,
      'sector': sector,
    };
  }

  @override
  String toString() {
    return 'Address(id: $id, address: $address, district: $district, province: $province, department: $department, sector: $sector)';
  }
}
