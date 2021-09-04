class RestApiException implements Exception {
  final int? responseCode;

  RestApiException(this.responseCode);
}
