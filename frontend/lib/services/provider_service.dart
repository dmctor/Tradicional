import 'dart:convert';
import 'package:http/http.dart' as http;
import '../configs/constants.dart';
import '../models/http_error.dart';
import '../models/service_http_response.dart';
import '../models/entities/provider.dart';

class ProviderService {
  Future<ServiceHttpResponse?> fetchByIds(List<int> ids, String token) async {
    ServiceHttpResponse serviceResponse = ServiceHttpResponse();
    final url = Uri.parse(BASE_URL + 'providers/fetch-by-ids'); // cambia si tu endpoint es otro

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'ids': ids}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final providers = data
            .map((map) => Provider.fromJson(map as Map<String, dynamic>))
            .toList();
        serviceResponse.status = 200;
        serviceResponse.body = providers;
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
