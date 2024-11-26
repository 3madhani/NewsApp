import 'package:dio/dio.dart';

abstract class Failure {
  final String errMessage;
  Failure({required this.errMessage});
}

class ServerFailure extends Failure {
  ServerFailure({required super.errMessage});

  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        return ServerFailure(errMessage: "Request to API server was cancelled");
      case DioExceptionType.connectionTimeout:
        return ServerFailure(errMessage: "Connection timeout with API server");
      case DioExceptionType.receiveTimeout:
        return ServerFailure(
            errMessage: "Receive timeout in connection with API server");
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
            dioError.response!.statusCode!, dioError.response!.data);
      case DioExceptionType.sendTimeout:
        return ServerFailure(
            errMessage: "Send timeout in connection with API server");
      case DioExceptionType.unknown:
        if (dioError.message!.contains("SocketException")) {
          return ServerFailure(errMessage: "No internet connection");
        }
      default:
        return ServerFailure(
            errMessage: "Oops! Something went wrong, please try again later");
    }
    return ServerFailure(
        errMessage: "Oops! Something went wrong, please try again later");
  }

  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(errMessage: response['error']['message']);
    } else if (statusCode == 404) {
      return ServerFailure(errMessage: "Your request was not found");
    } else if (statusCode == 500) {
      return ServerFailure(errMessage: "Internal server error");
    } else {
      return ServerFailure(
          errMessage: "Oops! Something went wrong, please try again later");
    }
  }
}
