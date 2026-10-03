import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:helloworld/models/entities/contact.dart';
import 'package:helloworld/models/entities/dependency.dart';
import 'package:helloworld/models/service_http_response.dart';
import 'package:helloworld/services/contact_service.dart';

class ViewContactsController extends GetxController {
  final ContactService contactService = ContactService(); // Instancia directa
  var isLoading = true.obs;
  var contacts = <Contact>[].obs;
  var errorMessage = ''.obs;

  void loadContacts(Dependency dependency) async {
    try {
      isLoading(true);
      errorMessage('');

      // Obtener el token desde SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      // Llamar al servicio con token y ID de dependencia
      final ServiceHttpResponse response =
          await contactService.fetchByDependency(dependency.id!, token!);

      if (response.status == 200) {
        if (response.body is List<Contact>) {
          contacts.assignAll(response.body as List<Contact>);
        } else if (response.body is List) {
          contacts.assignAll(
              (response.body as List).map((e) => Contact.fromJson(e)).toList());
        }
      } else {
        errorMessage(response.body?.toString() ?? 'Error al cargar contactos');
      }
    } catch (e) {
      errorMessage('Error al cargar contactos: $e');
    } finally {
      isLoading(false);
    }
  }
}
