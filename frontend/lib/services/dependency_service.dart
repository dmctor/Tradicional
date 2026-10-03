import 'dart:convert';
import 'package:http/http.dart' as http;
import '../configs/constants.dart';
import '../models/http_error.dart';
import '../models/service_http_response.dart';
import '../models/entities/dependency.dart';

class DependencyService {
  Future<ServiceHttpResponse> getDependencyById(int id, String token) async {
    ServiceHttpResponse serviceResponse = ServiceHttpResponse();
    final url = Uri.parse(BASE_URL + 'dependencies/$id');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        serviceResponse.status = 200;
        serviceResponse.body = Dependency.fromJson(data);
      } else {
        final error = HttpError.fromJson(jsonDecode(response.body));
        serviceResponse.status = response.statusCode;
        serviceResponse.body = error;
      }
    } catch (e) {
      print('Error al obtener dependencia: $e');
      serviceResponse.status = 500;
      serviceResponse.body = null;
    }

    return serviceResponse;
  }

  Future<ServiceHttpResponse> fetchByProviderAndCompany(
    int? providerId,
    int companyId,
    String token,
  ) async {
    ServiceHttpResponse serviceResponse = ServiceHttpResponse();
    final url = Uri.parse(
      BASE_URL + 'dependencies/provider/$providerId/company/$companyId',
    );

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
        final dependencies = data.map((e) => Dependency.fromJson(e)).toList();
        serviceResponse.status = 200;
        serviceResponse.body = dependencies;
      } else {
        final error = HttpError.fromJson(jsonDecode(response.body));
        serviceResponse.status = response.statusCode;
        serviceResponse.body = error;
      }
    } catch (e) {
      print('Error al obtener dependencias: $e');
      serviceResponse.status = 500;
      serviceResponse.body = null;
    }

    return serviceResponse;
  }

  Future<ServiceHttpResponse> fetchAllProviderNames(String token) async {
    ServiceHttpResponse serviceResponse = ServiceHttpResponse();
    final url = Uri.parse(BASE_URL + 'dependencies/providers/names');

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
        serviceResponse.status = 200;
        serviceResponse.body = data;
      } else {
        final error = HttpError.fromJson(jsonDecode(response.body));
        serviceResponse.status = response.statusCode;
        serviceResponse.body = error;
      }
    } catch (e) {
      print('Error al obtener nombres de proveedores: $e');
      serviceResponse.status = 500;
      serviceResponse.body = null;
    }

    return serviceResponse;
  }
}
