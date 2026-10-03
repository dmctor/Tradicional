import 'dart:convert';
//import 'package:flutter/services.dart';

import '../models/entities/invoice.dart';
import '../models/entities/isp_service.dart';
import '../models/entities/provider_service.dart';
import '../models/service_http_response.dart';

import '../configs/constants.dart';
import 'package:http/http.dart' as http;
import '../models/http_error.dart';

class InvoiceService {
  /// ✅ Obtener facturas de servicios ISP
  Future<ServiceHttpResponse> getIspInvoice(
      String token, List<IspService> ispServices) async {
    final url = Uri.parse(BASE_URL + 'invoices/isp');
    final ServiceHttpResponse serviceResponse = ServiceHttpResponse();

    try {
      // Convertir lista de servicios en JSON
      final servicesJson = ispServices.map((s) => {'id': s.id}).toList();

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'ispServices': servicesJson}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final invoices = responseData
            .map((map) => Invoice.fromJson(map as Map<String, dynamic>))
            .toList();

        serviceResponse.status = 200;
        serviceResponse.body = invoices;
      } else if (response.statusCode == 404 || response.statusCode == 400) {
        final responseData = json.decode(response.body);
        serviceResponse.status = response.statusCode;
        serviceResponse.body = HttpError.fromJson(responseData);
      } else {
        print('Error en getIspInvoice. Código: ${response.statusCode}');
        final responseData = json.decode(response.body);
        serviceResponse.status = response.statusCode;
        serviceResponse.body = HttpError.fromJson(responseData);
      }
    } catch (e) {
      print('Ocurrió un error en getIspInvoice: $e');
      serviceResponse.status = 500;
      serviceResponse.body = null;
    }

    return serviceResponse;
  }

  /// ✅ Obtener facturas de servicios Provider
  Future<ServiceHttpResponse> getProviderInvoice(
      String token, List<ProviderService> providerServices) async {
    final url = Uri.parse(BASE_URL + 'invoices/provider');
    final ServiceHttpResponse serviceResponse = ServiceHttpResponse();

    try {
      // Convertir lista de servicios en JSON
      final servicesJson = providerServices.map((s) => {'id': s.id}).toList();

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'providerServices': servicesJson}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final invoices = responseData
            .map((map) => Invoice.fromJson(map as Map<String, dynamic>))
            .toList();

        serviceResponse.status = 200;
        serviceResponse.body = invoices;
      } else if (response.statusCode == 404 || response.statusCode == 400) {
        final responseData = json.decode(response.body);
        serviceResponse.status = response.statusCode;
        serviceResponse.body = HttpError.fromJson(responseData);
      } else {
        print('Error en getProviderInvoice. Código: ${response.statusCode}');
        final responseData = json.decode(response.body);
        serviceResponse.status = response.statusCode;
        serviceResponse.body = HttpError.fromJson(responseData);
      }
    } catch (e) {
      print('Ocurrió un error en getProviderInvoice: $e');
      serviceResponse.status = 500;
      serviceResponse.body = null;
    }

    return serviceResponse;
  }

  /// ✅ Marcar una factura como facturada
  Future<ServiceHttpResponse> invoicing(String token, Invoice invoice) async {
    final url = Uri.parse(BASE_URL + 'invoices/invoice');
    final ServiceHttpResponse serviceResponse = ServiceHttpResponse();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'invoice': invoice.toJson()}),
      );

      if (response.statusCode == 200) {
        // ✅ Factura marcada como facturada
        serviceResponse.status = 200;
        serviceResponse.body = true;
      } else if (response.statusCode == 404) {
        final responseData = json.decode(response.body);
        serviceResponse.status = 404;
        serviceResponse.body = HttpError.fromJson(responseData);
      } else {
        print('Error al facturar invoice. Código: ${response.statusCode}');
        final responseData = json.decode(response.body);
        serviceResponse.status = response.statusCode;
        serviceResponse.body = HttpError.fromJson(responseData);
      }
    } catch (e) {
      print('Ocurrió un error en invoicing: $e');
      serviceResponse.status = 500;
      serviceResponse.body = false;
    }

    return serviceResponse;
  }
}
