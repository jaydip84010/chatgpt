import 'package:dio/dio.dart';

// Represent exceptions from Server/Remote data source.
class RemoteDataException implements Exception {
  DioError dioError;

  RemoteDataException({required this.dioError});
}

// Represent exceptions from Cache.
class LocalDataException implements Exception {
  String error;

  LocalDataException(this.error);
}

class RouteDataException implements Exception {
  final String message;
  RouteDataException(this.message);
}
