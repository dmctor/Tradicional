import 'dart:convert';
import 'package:http/http.dart' as http;

import '../configs/constants.dart';
import '../models/http_error.dart';
import '../models/service_http_response.dart';
import '../models/entities/admin.dart';
import '../models/responses/user_token.dart'; // Importa tu nuevo modelo

class AdminService {
  Future<ServiceHttpResponse?> signIn(Admin inputAdmin) async {
    ServiceHttpResponse serviceResponse = ServiceHttpResponse();
    final url = Uri.parse(BASE_URL + 'admins/sign-in'); // Asegúrate de que coincida

    final body = {
      'username': inputAdmin.username,
      'password': inputAdmin.password,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      print('👉 URL: $url');
      print('👉 Body enviado: $body');
      print('👉 Status Code: ${response.statusCode}');
      print('👉 Response Body: ${response.body}');


      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        Admin admin = Admin.fromJson(responseData["admin"]);
        final String? token = responseData['token'] as String?;

        UserToken adminToken = UserToken(admin: admin, token: token!);
        print(token);
        serviceResponse.status = 200;
        serviceResponse.body = adminToken;
      } else {
        final responseData = json.decode(response.body);
        HttpError error = HttpError.fromJson(responseData);
        serviceResponse.status = response.statusCode;
        serviceResponse.body = error;
      }
    } catch (e) {
      print('Ocurrió un error: $e');
      serviceResponse.status = 500;
      serviceResponse.body = null;
    }

    return serviceResponse;
  }
}
