class IspService {
  final int? id;
  final int ispId;
  final int providerId;
  final String description;
  final double cost;
  final String payCode;


  IspService({
    this.id,
    required this.ispId,
    required this.providerId,
    required this.description,
    required this.cost,
    required this.payCode,
  });


  factory IspService.fromJson(Map<String, dynamic> json) {
    return IspService(
      id: json['id'],
      ispId: json['isp_id'],
      providerId: json['provider_id'],
      description: json['description'],
      cost: (json['cost'] as num).toDouble(),
      payCode: json['pay_code'],
    );
  }


  Map<String, dynamic> toJson() => {
        'id': id,
        'isp_id': ispId,
        'provider_id': providerId,
        'description': description,
        'cost': cost,
        'pay_code': payCode,
      };
  @override
  String toString() {
    return 'IspService(id: $id, ispId: $ispId, providerId: $providerId, '
           'description: $description, cost: $cost, payCode: $payCode)';
  }

  fetchAll() {}
}

