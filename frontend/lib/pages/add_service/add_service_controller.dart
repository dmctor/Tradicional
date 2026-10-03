import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helloworld/models/entities/company.dart';
import 'package:helloworld/models/entities/dependency.dart';
import 'package:helloworld/models/entities/isp.dart';
import 'package:helloworld/models/entities/isp_service.dart' as model;
import 'package:helloworld/models/entities/provider.dart';
import 'package:helloworld/models/entities/provider_service.dart';
import 'package:helloworld/services/dependency_service.dart';
import 'package:helloworld/services/provider_service_service.dart';
import 'package:helloworld/services/isp_service_service.dart' as service;
import 'package:helloworld/services/isp_service.dart' as service;
import 'package:shared_preferences/shared_preferences.dart';

class AddServiceController extends GetxController {
  final descripcion = TextEditingController();
  final precio = TextEditingController();

  final descripcionController = TextEditingController();
  final precioController = TextEditingController();
  final codigoPagoController = TextEditingController();

  final selectedIspId = RxnInt();
  final selectedDependencyId = RxnInt();

  var ispList = <Isp>[].obs;
  var dependencyList = <Dependency>[].obs;

  var isLoading = false.obs;

  Provider? currentProvider;
  Company? currentCompany;

  void limpiarCampos(bool isp) {
    if (isp) {
      descripcionController.clear();
      precioController.clear();
      codigoPagoController.clear();
      selectedIspId.value = null;
    } else {
      descripcion.clear();
      precio.clear();
    }
  }

  bool validarCampos(bool isp) {
    if (isp) {
      return descripcionController.text.isNotEmpty &&
          precioController.text.isNotEmpty &&
          codigoPagoController.text.isNotEmpty &&
          selectedIspId.value != null;
    } else {
      return descripcion.text.isNotEmpty && precio.text.isNotEmpty;
    }
  }

  void mostrarSnackbarSeguro(String titulo, String mensaje,
      {Color backgroundColor = Colors.redAccent,
      Color colorText = Colors.white}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(titulo, mensaje,
          backgroundColor: backgroundColor, colorText: colorText);
    });
  }

  void gotoRegisterService(BuildContext context, bool volver) {
    Navigator.pushNamed(context, '/registerService', arguments: volver);
  }

  Future<void> guardarNuevoServicio(
      BuildContext context, int providerId) async {
    print("Descripcion: ${descripcionController.text}");
    print("Precio: ${precioController.text}");
    print("Codigo Pago: ${codigoPagoController.text}");
    print("Selected ISP: ${selectedIspId.value}");
    print("Selected ISP ID: ${selectedIspId.value}");

    if (!validarCampos(true)) {
      mostrarSnackbarSeguro('Error', 'Todos los campos son obligatorios.');
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');
      final ispService = model.IspService(
        id: null,
        ispId: selectedIspId.value!,
        providerId: providerId,
        description: descripcionController.text.trim(),
        cost: double.tryParse(precioController.text.trim()) ?? 0.0,
        payCode: codigoPagoController.text.trim(),
      );

      // 🚩 DEBUG: imprimir antes de enviar
      print("📤 Enviando datos al backend...");

      final response =
          await service.IspServiceService().createNewService(ispService, token!);

      // 🚩 DEBUG: imprimir respuesta recibida
      print("✅ Respuesta recibida: ${response.body}");

      if (response.status == 201) {
        mostrarDialogosConfirmacion(context, true);
      } else if (response.status == 409) {
        mostrarSnackbarSeguro('Duplicado', 'El servicio ya existe.',
            backgroundColor: Colors.orange, colorText: Colors.black);
      } else {
        mostrarSnackbarSeguro('Error', 'No se pudo registrar el servicio.');
      }
    } catch (e) {
      mostrarSnackbarSeguro('Error', 'Ocurrió un problema: $e');
    }
  }

  void mostrarDialogosConfirmacion(BuildContext context, bool isp) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 240, 161, 225),
          title: const Text(
            '¿Estás seguro de que \n la información es \n correcta?',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirmar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 240, 161, 225),
            title: const Text(
              'Información registrada \n correctamente',
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      limpiarCampos(isp);
                    },
                    child: const Text('Registrar otro'),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      gotoRegisterService(context, true);
                    },
                    child: const Text('Volver'),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> guardarNuevoProviderService(
      BuildContext context, int providerId, int dependencyId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');
    if (!validarCampos(false)) {
      mostrarSnackbarSeguro('Error', 'Todos los campos son obligatorios.');
      return;
    }

    try {
      final nuevoServicio = ProviderService(
        id: null,
        dependencyId: dependencyId,
        providerId: providerId,
        description: descripcion.text.trim(),
        price: double.tryParse(precio.text.trim()) ?? 0.0,
      );

      final response = await ProviderServiceService()
          .createNewService(token!, nuevoServicio);

      if (response.status == 201) {
        mostrarDialogosConfirmacion(context, false);
      } else if (response.status == 409) {
        mostrarSnackbarSeguro('Duplicado', 'El servicio ya existe.',
            backgroundColor: Colors.orange, colorText: Colors.black);
      } else {
        mostrarSnackbarSeguro('Error', 'No se pudo registrar el servicio.');
      }
    } catch (e) {
      mostrarSnackbarSeguro('Error', 'Ocurrió un problema: $e');
    }
  }

  Future<void> cargarIsps() async {
    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');
      final ispService = service.IspService();
      final response = await ispService.fetchAllNamesWithId(token!);

      if (response?.status == 200 && response?.body != null) {
        final List<dynamic> data = response!.body;
        final List<Isp> loadedIsps = data.map((e) => Isp.fromJson(e)).toList();
        ispList.assignAll(loadedIsps);
      } else {
        ispList.clear();
        mostrarSnackbarSeguro('Info', 'No hay ISPs disponibles.',
            backgroundColor: Colors.orange, colorText: Colors.black);
      }
    } catch (e) {
      mostrarSnackbarSeguro('Error', 'No se pudo cargar los ISPs.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cargarDependencias() async {
    if (currentProvider == null || currentCompany == null) {
      dependencyList.clear();
      return;
    }

    try {
      // Obtener el token desde SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      final dependencyService = DependencyService();
      final response = await dependencyService.fetchAllProviderNames(token!);

      if (response.status == 200 && response.body != null) {
        final List<dynamic> data = response.body;
        final List<Dependency> loadedDeps =
            data.map((e) => Dependency.fromJson(e)).toList();
        dependencyList.assignAll(loadedDeps);
      } else {
        dependencyList.clear();
        mostrarSnackbarSeguro('Info', 'No hay dependencias disponibles.',
            backgroundColor: Colors.orange, colorText: Colors.black);
      }
    } catch (e) {
      mostrarSnackbarSeguro('Error', 'No se pudo cargar las dependencias.');
    }
  }

  @override
  void onInit() {
    super.onInit();
    cargarIsps();
    cargarDependencias();
  }

  @override
  void onClose() {
    descripcion.dispose();
    precio.dispose();
    descripcionController.dispose();
    precioController.dispose();
    codigoPagoController.dispose();
    super.onClose();
  }
}
