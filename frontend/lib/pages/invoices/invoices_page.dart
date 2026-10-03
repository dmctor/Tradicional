import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'invoices_controller.dart';
import '../../components/custom_nav_bar.dart';
import '../../selected_provider_controller.dart';

class InvoicesPage extends StatelessWidget {
  final InvoicesController controller = Get.put(InvoicesController());

  @override
  Widget build(BuildContext context) {
    final provider = Get.find<SelectedProviderController>().provider;
    print('✅ Proveedor cargado: ${provider.name}, RUC: ${provider.ruc}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
      if (arguments != null &&
          arguments['providerServices'] != null &&
          arguments['ispServices'] != null) {
        controller.loadInvoices(
          providerServices: arguments['providerServices'],
          ispServices: arguments['ispServices'],
        );
      }

      // 🔽 Datos de ejemplo para mostrar en la tabla
      controller.services.value = [
        InvoiceItem(
          servicio: 'Internet Hogar',
          isp: 'Claro Perú',
          monto: 'S/ 120.00',
          estado: 'Pendiente',
        ),
        InvoiceItem(
          servicio: 'Hosting Web',
          isp: 'Movistar Empresas',
          monto: 'S/ 80.00',
          estado: 'Pendiente',
        ),
        InvoiceItem(
          servicio: 'Dominio .com',
          isp: 'Entel',
          monto: 'S/ 40.00',
          estado: 'Facturado',
        ),
      ];
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          Navigator.pushReplacementNamed(context, '/sign-in');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Servicios a facturar',
            style: TextStyle(color: Color(0xFF2E3281)),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          leading: const BackButton(),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Obx(() => _buildDropdownMes(context)),
              const SizedBox(height: 16),
              Obx(() => _buildTablaServicios()),
              const SizedBox(height: 20),
              Obx(() => _buildBotonFacturar(context)),
            ],
          ),
        ),
        bottomNavigationBar: const CustomNavBar(selectedIndex: 2),
      ),
    );
  }

  Widget _buildDropdownMes(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFDDE3FA),
        border: Border.all(color: const Color(0xFF5563BC)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: const Color(0xFFE7E8F2),
          value: controller.selectedMonth.value,
          icon: const Icon(Icons.arrow_drop_down),
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold),
          items: controller.months
              .map((month) => DropdownMenuItem(
                    value: month,
                    child: Text(month),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              controller.selectedMonth.value = value;
              final arguments = ModalRoute.of(context)
                      ?.settings
                      .arguments as Map? ??
                  {};
              controller.loadInvoices(
                providerServices: arguments['providerServices'] ?? [],
                ispServices: arguments['ispServices'] ?? [],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTablaServicios() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE7E8F2),
        border: Border.all(color: const Color(0xFF5563BC)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFDDE3FA),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: const [
                SizedBox(width: 40),
                Expanded(
                    child: Text('Servicio',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black))),
                Expanded(
                    child: Text('ISP',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black))),
                Expanded(
                    child: Text('Monto',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black))),
                Expanded(
                    child: Text('Estado',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black))),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: controller.services.length,
              itemBuilder: (BuildContext context, int index) {
                final item = controller.services[index];
                final selected = controller.selectedServices.contains(index);
                final isFacturado = item.estado != 'Pendiente';

                return InkWell(
                  onTap: isFacturado
                      ? null
                      : () => controller.toggleServiceSelection(index),
                  child: Container(
                    color:
                        selected ? const Color(0xFFEEEEEE) : Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 12),
                    child: Row(
                      children: [
                        Checkbox(
                          value: selected,
                          onChanged: isFacturado
                              ? null
                              : (_) =>
                                  controller.toggleServiceSelection(index),
                          activeColor: Colors.white,
                          checkColor: Colors.black,
                          side: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        Expanded(
                          child: Text(item.servicio,
                              style: const TextStyle(color: Colors.black)),
                        ),
                        Expanded(
                          child: Text(item.isp,
                              style: const TextStyle(color: Colors.black)),
                        ),
                        Expanded(
                          child: Text(item.monto,
                              style: const TextStyle(color: Colors.black)),
                        ),
                        Expanded(
                          child: Text(item.estado,
                              style: const TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonFacturar(BuildContext context) {
    final enabled = controller.selectedServices.isNotEmpty;
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: enabled
            ? () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: const Color(0xFFFAD8FD),
                    content: const Text(
                      '¿Estás seguro de marcar como facturadas las facturas seleccionadas?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3C2F4E),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    actionsAlignment: MainAxisAlignment.center,
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF3C2F4E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            'CONFIRMAR',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onPressed: () => Navigator.pop(ctx, true),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  await controller.confirmInvoices();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Se marcaron como facturadas.')),
                  );
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFBBCFFC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'FACTURAR',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
