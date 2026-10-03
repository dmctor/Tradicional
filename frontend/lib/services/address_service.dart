import 'dart:convert';
import 'package:http/http.dart' as http;

import '../configs/constants.dart';
import '../models/http_error.dart';
import '../models/service_http_response.dart';
import '../models/entities/address.dart';
import '../models/entities/company.dart';

class AddressService {
  /// Obtiene la dirección asociada a una empresa desde el backend
  Future<ServiceHttpResponse?> getAddress(Company company, String token) async {
    final ServiceHttpResponse serviceResponse = ServiceHttpResponse();
    final Uri url = Uri.parse(BASE_URL + 'addresses/company/${company.id}');

    try {
      final http.Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final Address address = Address.fromJson(data);
        serviceResponse.status = 200;
        serviceResponse.body = address;
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final HttpError error = HttpError.fromJson(responseData);
        serviceResponse.status = response.statusCode;
        serviceResponse.body = error;
      }
    } catch (e) {
      print('Ocurrió un error en getAddress: $e');
      serviceResponse.status = 500;
      serviceResponse.body = null;
    }

    return serviceResponse;
  }
}
