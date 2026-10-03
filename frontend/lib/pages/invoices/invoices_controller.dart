import 'package:get/get.dart';

class InvoiceItem {
  final String servicio;
  final String isp;
  final String monto;
  String estado;

  InvoiceItem({
    required this.servicio,
    required this.isp,
    required this.monto,
    required this.estado,
  });
}

class InvoicesController extends GetxController {
  var months = ['Enero 2025', 'Febrero 2025', 'Marzo 2025', 'Abril 2025', 'Mayo 2025'].obs;
  var selectedMonth = 'Abril 2025'.obs;

  var services = <InvoiceItem>[].obs;
  var selectedServices = <int>[].obs;

  /// Carga las facturas desde el JSON decodificado
  void loadInvoices({
    required List<dynamic> providerServices,
    required List<dynamic> ispServices,
  }) {
    services.clear();
    selectedServices.clear();

    for (int i = 0; i < providerServices.length; i++) {
      final provider = providerServices[i];
      final isp = ispServices.firstWhere(
        (isp) => isp['id'] == provider['ispId'],
        orElse: () => {'name': 'Desconocido'},
      );

      services.add(InvoiceItem(
        servicio: provider['name'] ?? 'Servicio ${i + 1}',
        isp: isp['name'] ?? 'ISP desconocido',
        monto: 'S/${provider['price'] ?? '0'}',
        estado: provider['status'] ?? 'Pendiente',
      ));
    }
  }

  void toggleServiceSelection(int index) {
    if (services[index].estado != 'Pendiente') return;

    if (selectedServices.contains(index)) {
      selectedServices.remove(index);
    } else {
      selectedServices.add(index);
    }
  }

  Future<void> confirmInvoices() async {
    for (var index in selectedServices) {
      services[index].estado = 'Facturado';
    }
    selectedServices.clear();
    services.refresh();
  }
}