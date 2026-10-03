import 'dart:convert';
import 'package:http/http.dart' as http;
import '../configs/constants.dart';
import '../models/http_error.dart';
import '../models/service_http_response.dart';
import '../models/entities/contact.dart';

class ContactService {
  Future<ServiceHttpResponse> fetchByDependency(
    int dependencyId,
    String token,
  ) async {
    ServiceHttpResponse serviceResponse = ServiceHttpResponse();
    final url = Uri.parse(BASE_URL + 'contacts/dependency/$dependencyId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final contacts = data.map((e) => Contact.fromJson(e)).toList();
        serviceResponse.status = 200;
        serviceResponse.body = contacts;
      } else {
        final error = HttpError.fromJson(jsonDecode(response.body));
        serviceResponse.status = response.statusCode;
        serviceResponse.body = error;
      }
    } catch (e) {
      print('Error al obtener contactos por dependencia: $e');
      serviceResponse.status = 500;
      serviceResponse.body = null;
    }

    return serviceResponse;
  }
}
