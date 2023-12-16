class VTServiceResponse<T> {
  final T? data;
  final ErrorType error;

  VTServiceResponse({this.data, this.error = ErrorType.none});
}

enum ErrorType {
  unauthorized,
  notFound,
  badRequest,
  alreadyExists,
  unknown,
  noInternet,
  none
}
