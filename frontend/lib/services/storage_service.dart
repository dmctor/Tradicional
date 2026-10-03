import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  bool _initialized = false;
  late SharedPreferences _prefs;

  // Inicializa SharedPreferences
  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  bool get isInitialized => _initialized;

  // Guardar token JWT
  Future<void> saveToken(String token) async {
    print("1++++++++++++++++++++++++++++++++++++++++++++++++");
    print(token);
    print("2++++++++++++++++++++++++++++++++++++++++++++++++");
    if (!_initialized) {
      throw Exception("StorageService no ha sido inicializado.");
    }
    await _prefs.setString('jwt_token', token);
  }

  // Leer token
  String? getToken() {
    return _prefs.getString('jwt_token');
  }

  // Borrar token
  Future<void> deleteToken() async {
    await _prefs.remove('jwt_token');
  }

  // Opcional: limpiar todo
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
