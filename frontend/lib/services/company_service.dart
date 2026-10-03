import 'dart:convert';
import 'package:http/http.dart' as http;

import '../configs/constants.dart';
import '../models/http_error.dart';
import '../models/service_http_response.dart';
import '../models/entities/company.dart';

class CompanyService {
  /// Obtiene todas las empresas desde el backend
  Future<ServiceHttpResponse?> fetchAll(String token) async {
    final ServiceHttpResponse serviceResponse = ServiceHttpResponse();
    final Uri url = Uri.parse(BASE_URL + 'companies');

    try {
      final http.Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Company> companies = data
            .map((map) => Company.fromJson(map as Map<String, dynamic>))
            .toList();
        serviceResponse.status = 200;
        serviceResponse.body = companies;
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final HttpError error = HttpError.fromJson(responseData);
        serviceResponse.status = response.statusCode;
        serviceResponse.body = error;
      }
    } catch (e) {
      print('Ocurrió un error en fetchAll: $e');
      serviceResponse.status = 500;
      serviceResponse.body = null;
    }

    return serviceResponse;
  }

  /// Obtiene el RUC de una empresa por ID desde el backend
  Future<ServiceHttpResponse?> getCompanyRucById(int id, String token) async {
    final ServiceHttpResponse serviceResponse = ServiceHttpResponse();
    final Uri url = Uri.parse(BASE_URL + 'companies/$id/ruc');

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
        serviceResponse.status = 200;
        serviceResponse.body = data['ruc'];
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final HttpError error = HttpError.fromJson(responseData);
        serviceResponse.status = response.statusCode;
        serviceResponse.body = error;
      }
    } catch (e) {
      print('Ocurrió un error en getCompanyRucById: $e');
      serviceResponse.status = 500;
      serviceResponse.body = null;
    }

    return serviceResponse;
  }
}
