import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/service_http_response.dart';
import '../models/entities/isp.dart';
import 'package:http/http.dart' as http;
import '../configs/constants.dart';


class IspService {
  List<Isp> services = [];
  Future<void> fetchAll() async {
    final String lectura = await rootBundle.loadString('assets/jsons/isp.json');
    final List<dynamic> data = jsonDecode(lectura);
    services = data
        .map((element) => Isp.fromJson(element as Map<String, dynamic>))
        .toList();
  }

  Future<ServiceHttpResponse?> getIspById(int id) async {
    ServiceHttpResponse serviceResponse = ServiceHttpResponse();
    if (services.isEmpty) {
      await fetchAll();
    }
    try {
      serviceResponse.status = 200;
      serviceResponse.body = services.firstWhere((service) => service.id == id);
      return serviceResponse;
    } catch (e) {
      serviceResponse.status = 404;
      serviceResponse.body = null;
      return serviceResponse;
    }
  }

Future<ServiceHttpResponse?> fetchAllNamesWithId(String token) async {
  ServiceHttpResponse serviceResponse = ServiceHttpResponse();

  try {
    print("🔄 Intentando conectarse al backend...");
    
    final response = await http.get(
      Uri.parse(BASE_URL + 'isps'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // opcional pero recomendable
      },
    );

    print("🌐 Status Code: ${response.statusCode}");
    print("📦 Body crudo: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      // DEBUG NUEVO
      print("🔍 DATA decodificada: $data");

      serviceResponse.status = 200;
      serviceResponse.body = data;
      print("✅ ISPs cargados correctamente, cantidad: ${data.length}");
    } else {
      print("⚠️ Error de status code: ${response.statusCode}");
      serviceResponse.status = response.statusCode;
      serviceResponse.body = null;
    }
  } catch (e) {
    print("❌ Error de conexión: $e");
    serviceResponse.status = 500;
    serviceResponse.body = null;
  }

  return serviceResponse;
}



}

