class VTServiceResponse<T> {
  final T? data;
  final ErrorType? error;

  VTServiceResponse({this.data, this.error});
}

enum ErrorType {
  unauthorized,
  notFound,
  badRequest,
  unknown,
}
