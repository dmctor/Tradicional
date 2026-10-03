import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/provider_service.dart';
import '../../models/entities/provider.dart';
import '../../selected_provider_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectCompanyController extends GetxController {
  var selectedCompany = RxnString(); // Empresa seleccionada por nombre
  var companies = <String>[].obs;    // Lista de nombres de empresas
  List<Provider> _filteredProviders = [];

  void setSelectedCompany(String? company) {
    selectedCompany.value = company;
  }

  /// Cargar los proveedores usando sus IDs
  Future<void> loadProvidersByIds(List<int> providerIds) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');
    final response = await ProviderService().fetchByIds(providerIds,token!);
    if (response?.status == 200) {
      _filteredProviders = List<Provider>.from(response!.body);
      companies.value = _filteredProviders.map((p) => p.name).toList();
    } else {
      _filteredProviders = [];
      companies.value = [];
    }
  }

  /// Guardar el Provider seleccionado en el estado global y continuar
  Future<void> continueToInvoices(BuildContext context) async {
    final selectedName = selectedCompany.value;

    if (selectedName != null) {
      final provider = _filteredProviders.firstWhere(
        (p) => p.name == selectedName,
        orElse: () => Provider(
          id: null,
          ruc: '',
          name: '',
          logo: '',
        ),
      );

      if (provider.id != null) {
        // Guardar en controlador global
        Get.find<SelectedProviderController>().setProvider(provider);

        // Navegar a financial
        Navigator.pushReplacementNamed(context, '/financial-statement');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Proveedor no válido')),
        );
      }
    }
  }
}
