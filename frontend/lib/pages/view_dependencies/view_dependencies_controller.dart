import 'package:get/get.dart';
import 'package:helloworld/models/entities/dependency.dart';
import 'package:helloworld/services/dependency_service.dart';
import 'package:helloworld/selected_provider_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewDependenciesController extends GetxController {
  var isLoading = true.obs;
  var dependencies = <Dependency>[].obs;

  final DependencyService _dependencyService = DependencyService();
  final provider = Get.find<SelectedProviderController>().provider;

  /// Cargar dependencias según provider y company como ya tenías
  Future<void> loadDependencies(String companyId) async {
    try {
      isLoading.value = true;
      final companyIdInt = int.tryParse(companyId) ?? 0;
      final providerId = provider.id;

      // Leer el token desde SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      // Llamada al servicio usando los IDs y el token
      final response = await _dependencyService.fetchByProviderAndCompany(
        providerId,
        companyIdInt,
        token!,
      );

      if (response.status == 200) {
        dependencies.value = List<Dependency>.from(response.body);
      } else {
        dependencies.clear();
        Get.snackbar('Aviso', response.body.toString());
      }
    } catch (e) {
      Get.snackbar('Error', 'Error al cargar dependencias: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
