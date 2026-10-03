import 'dart:convert';
//import 'package:flutter/services.dart';

import '../models/entities/provider_service.dart';
import '../models/service_http_response.dart';

import '../configs/constants.dart';
import 'package:http/http.dart' as http;
import '../models/http_error.dart';

class ProviderServiceService {
  Future<ServiceHttpResponse> fetchByProvider(String token, int providerId) async {
    final url = Uri.parse(BASE_URL + 'providerServices/by-provider');
    final ServiceHttpResponse serviceResponse = ServiceHttpResponse();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'providerId': providerId,
        }),
      );

      if (response.statusCode == 200) {
        //  Lista de servicios encontrada
        final List<dynamic> responseData = json.decode(response.body);
        final services = responseData
            .map((map) => ProviderService.fromJson(map as Map<String, dynamic>))
            .toList();

        serviceResponse.status = 200;
        serviceResponse.body = services;
      } else if (response.statusCode == 404) {
        //  No hay servicios para este proveedor
        final responseData = json.decode(response.body);
        serviceResponse.status = 404;
        serviceResponse.body = HttpError.fromJson(responseData);
      } else {
        //  Otros errores del servidor
        print('Error en fetchByProvider. Código: ${response.statusCode}');
        final responseData = json.decode(response.body);
        serviceResponse.status = response.statusCode;
        serviceResponse.body = HttpError.fromJson(responseData);
      }
    } catch (e) {
      print('Ocurrió un error: $e');
      serviceResponse.status = 500;
      serviceResponse.body = null;
    }

    return serviceResponse;
  }

  Future<ServiceHttpResponse> createNewService(String token, ProviderService newService) async {
    final url = Uri.parse(BASE_URL + 'providerServices/create');
    final ServiceHttpResponse serviceResponse = ServiceHttpResponse();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "description": newService.description,
          "dependencyId": newService.dependencyId,
          "providerId": newService.providerId,
          "price": newService.price,
        }),
      );

      if (response.statusCode == 201) {
        //  Creado correctamente
        serviceResponse.status = 201;
        serviceResponse.body = true;
      } else if (response.statusCode == 409) {
        //  Ya existe un servicio igual
        final responseData = json.decode(response.body);
        serviceResponse.status = 409;
        serviceResponse.body = HttpError.fromJson(responseData);
      } else {
        //  Otros errores
        print('Error al crear servicio. Código: ${response.statusCode}');
        final responseData = json.decode(response.body);
        serviceResponse.status = response.statusCode;
        serviceResponse.body = HttpError.fromJson(responseData);
      }
    } catch (e) {
      print('Ocurrió un error: $e');
      serviceResponse.status = 500;
      serviceResponse.body = null;
    }

    return serviceResponse;
  }
}
