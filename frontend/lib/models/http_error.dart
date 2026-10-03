class HttpError {
  String? message;
  String? detail;

  HttpError({this.message, this.detail});

  // Factory: Crear desde un Map/JSON
  factory HttpError.fromJson(Map<String, dynamic> json) {
    return HttpError(
      message: json['message'] ?? 'No message provided',
      detail: json['detail'],
    );
  }

  // Método para convertir a Map
  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'detail': detail,
    };
  }

  // toString override
  @override
  String toString() {
    return 'HttpError(message: $message, detail: $detail)';
  }
}
