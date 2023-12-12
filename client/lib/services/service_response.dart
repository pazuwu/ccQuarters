class ServiceResponse<T> {
  T data;
  ErrorType error;

  ServiceResponse({required this.data, this.error = ErrorType.none});
}

enum ErrorType {
  unauthorized,
  notFound,
  badRequest,
  forbidden,
  unknown,
  none,
}
