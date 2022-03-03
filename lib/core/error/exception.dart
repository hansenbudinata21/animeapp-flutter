class ServerException implements Exception {
  final int? statusCode;
  final String statusMessage;

  ServerException({
    required this.statusCode,
    required this.statusMessage,
  });
}

class CacheException implements Exception {}
