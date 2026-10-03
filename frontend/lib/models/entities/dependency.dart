class Dependency {
  int? id;
  int companyId;
  int providerId;
  String name;
  DateTime signDate;
  String validityTime;
  DateTime terminationDate;
  String anniversary;
  String equipment;

  Dependency({
    this.id,
    required this.companyId,
    required this.providerId,
    required this.name,
    required this.signDate,
    required this.validityTime,
    required this.terminationDate,
    required this.anniversary,
    required this.equipment,
  });

  factory Dependency.fromJson(Map<String, dynamic> json) {
    return Dependency(
      id: json['id'],
      companyId: json['company_id'],
      providerId: json['provider_id'],
      name: json['name'],
      signDate: DateTime.parse(json['sign_date']),
      validityTime: json['validity_time'],
      terminationDate: DateTime.parse(json['termination_date']),
      anniversary: json['anniversary'],
      equipment: json['equipment'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company_id': companyId,
      'provider_id': providerId,
      'name': name,
      'sign_date': signDate.toIso8601String(),
      'validity_time': validityTime,
      'termination_date': terminationDate.toIso8601String(),
      'anniversary': anniversary,
      'equipment': equipment,
    };
  }

  @override
  String toString() {
    return 'Dependency(id: $id, companyId: $companyId, providerId: $providerId, name: $name, '
        'signDate: $signDate, validityTime: $validityTime, terminationDate: $terminationDate, '
        'anniversary: $anniversary, equipment: $equipment)';
  }
}
