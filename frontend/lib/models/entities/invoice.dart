class Invoice {
  int? id;
  String invoiceNumber;
  String serviceType; // "Proveedor" o "ISP"
  int serviceId;
  int invoiceMonth; // número del mes: 1 = enero, 2 = febrero, etc.
  bool invoiced;
  DateTime issueDate;
  DateTime dueDate;

  Invoice({
    this.id,
    required this.invoiceNumber,
    required this.serviceType,
    required this.serviceId,
    required this.invoiceMonth,
    required this.invoiced,
    required this.issueDate,
    required this.dueDate,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      invoiceNumber: json['invoice_number'],
      serviceType: json['service_type'],
      serviceId: json['service_id'],
      invoiceMonth: json['invoice_month'],
      invoiced: json['invoiced'],
      issueDate: DateTime.parse(json['issue_date']),
      dueDate: DateTime.parse(json['due_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_number': invoiceNumber,
      'service_type': serviceType,
      'service_id': serviceId,
      'invoice_month': invoiceMonth,
      'invoiced': invoiced,
      'issue_date': issueDate.toIso8601String(),
      'due_date': dueDate.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Invoice(id: $id, invoiceNumber: $invoiceNumber, serviceType: $serviceType, serviceId: $serviceId, '
        'invoiceMonth: $invoiceMonth, invoiced: $invoiced, issueDate: $issueDate, dueDate: $dueDate)';
  }
}
