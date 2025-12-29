class ApiResponse<T> {
  final String status;
  final String message;
  final T? data;
  final dynamic errors;

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
    this.errors,
  });

  bool get isSuccess => status == 'success';

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic)? parser) {
    return ApiResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null && parser != null ? parser(json['data']) : null,
      errors: json['errors'],
    );
  }
}
