class ProviderService {
  int? id;
  int dependencyId;
  int providerId;
  String description;
  double price;

  ProviderService({
    this.id,
    required this.dependencyId,
    required this.providerId,
    required this.description,
    required this.price,
  });

  // Crear una instancia desde un JSON
  factory ProviderService.fromJson(Map<String, dynamic> json) {
    return ProviderService(
      id: json['id'],
      dependencyId: json['dependency_id'],
      providerId: json['provider_id'],
      description: json['description'],
      price: (json['price'] as num).toDouble(), // asegura double
    );
  }

  // Convertir la instancia a JSON (Map)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dependency_id': dependencyId,
      'provider_id': providerId,
      'description': description,
      'price': price,
    };
  }

  @override
  String toString() {
    return 'ProviderService(id: $id, dependencyId: $dependencyId, providerId: $providerId, description: $description, price: $price)';
  }
}
