
import 'package:dio/dio.dart';
import 'package:e_commerce_clean/data/network/failure.dart';

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioError) {
      /// dio error so its an error from response of the API or from dio itself
      failure = _handleError(error);
    } else {
      /// default error
      failure = DataSource.DEFAULT.getFailure();
    }
  }
}

Failure _handleError(DioError error) {
  switch (error.type) {
    case DioErrorType.connectTimeout:
      return DataSource.CONCET_TIMEOUT.getFailure();
    case DioErrorType.sendTimeout:
      return DataSource.SEND_TIMEOUT.getFailure();
    case DioErrorType.receiveTimeout:
      return DataSource.RECIEVE_TIMEOUT.getFailure();
    case DioErrorType.response:
      if (error.response != null &&
          error.response?.statusCode != null &&
          error.response?.statusMessage != null) {
        return Failure(error.response?.statusCode ?? 0,
            error.response?.statusMessage ?? '');
      } else {
        return DataSource.DEFAULT.getFailure();
      }
    case DioErrorType.cancel:
      return DataSource.CANCEL.getFailure();
    case DioErrorType.other:
      return DataSource.DEFAULT.getFailure();
  }
}

enum DataSource {
  SUCCESS,
  NO_CONTENT,
  BAD_REQUSTE,
  FORBIDOEN,
  UNAUTHORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONCET_TIMEOUT,
  CANCEL,
  RECIEVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONECTION,
  DEFAULT
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.SUCCESS:
        return Failure(ResponseCode.SUCCESS, ResponseMessage.SUCCESS);
      case DataSource.NO_CONTENT:
        return Failure(ResponseCode.NO_CONTENT, ResponseMessage.NO_CONTENT);
      case DataSource.BAD_REQUSTE:
        return Failure(ResponseCode.BAD_REQUSTE, ResponseMessage.BAD_REQUSTE);
      case DataSource.FORBIDOEN:
        return Failure(ResponseCode.FORBIDOEN, ResponseMessage.FORBIDOEN);
      case DataSource.UNAUTHORISED:
        return Failure(ResponseCode.UNAUTHORISED, ResponseMessage.UNAUTHORISED);
      case DataSource.NOT_FOUND:
        return Failure(ResponseCode.NOT_FOUND, ResponseMessage.NOT_FOUND);
      case DataSource.INTERNAL_SERVER_ERROR:
        return Failure(ResponseCode.INTERNAL_SERVER_ERROR,
            ResponseMessage.INTERNAL_SERVER_ERROR);
      case DataSource.CONCET_TIMEOUT:
        return Failure(
            ResponseCode.CONCET_TIMEOUT, ResponseMessage.CONCET_TIMEOUT);
      case DataSource.CANCEL:
        return Failure(ResponseCode.CANCEL, ResponseMessage.CANCEL);
      case DataSource.RECIEVE_TIMEOUT:
        return Failure(
            ResponseCode.RECIEVE_TIMEOUT, ResponseMessage.RECIEVE_TIMEOUT);
      case DataSource.SEND_TIMEOUT:
        return Failure(ResponseCode.SEND_TIMEOUT, ResponseMessage.SEND_TIMEOUT);
      case DataSource.CACHE_ERROR:
        return Failure(ResponseCode.CACHE_ERROR, ResponseMessage.CACHE_ERROR);
      case DataSource.NO_INTERNET_CONECTION:
        return Failure(ResponseCode.NO_INTERNET_CONECTION,
            ResponseMessage.NO_INTERNET_CONECTION);
      case DataSource.DEFAULT:
        return Failure(ResponseCode.DEFAULT, ResponseMessage.DEFAULT);
    }
  }
}

class ResponseCode {
  static const int SUCCESS = 200;

  /// success with data
  static const int NO_CONTENT = 201;

  /// success with data(no content)
  static const int BAD_REQUSTE = 400;

  /// failure  API rejected request
  static const int FORBIDOEN = 403;

  /// failure user
  static const int UNAUTHORISED = 401;

  /// failure user is not authorised
  /// static const int NOT_FOUND  = 403 ; /// failure  API rejected request
  static const int INTERNAL_SERVER_ERROR = 500;

  /// failure , crash in server side
  static const int NOT_FOUND = 404;

  /// failure not found

  /// local status code
  static const int CONCET_TIMEOUT = -1;

  static const int CANCEL = -2;

  static const int RECIEVE_TIMEOUT = -3;

  static const int SEND_TIMEOUT = -4;

  static const int CACHE_ERROR = -5;

  static const int NO_INTERNET_CONECTION = -6;

  static const int DEFAULT = -7;
}

class ResponseMessage {
  static const String SUCCESS = 'Success';

  /// success with data
  static const String NO_CONTENT = 'Success';

  /// success with data(no content)
  static const String BAD_REQUSTE = 'Bad request , Try again later';

  /// failure  API rejected request
  static const String FORBIDOEN = 'Forbidden Bad request , Try again later';

  /// failure user
  static const String UNAUTHORISED = 'User is unauthorised , Try again later';

  /// failure user is not authorised
  static const String NOT_FOUND = '';

  /// failure  API rejected request
  static const String INTERNAL_SERVER_ERROR =
      'Some thing want wrong , Try again later';

  /// failure , crash in server side

  /// local status code
  static const String CONCET_TIMEOUT = 'Time out error, Try again later';

  static const String CANCEL = 'Request was cancelled ,Try again later';

  static const String RECIEVE_TIMEOUT = 'Time out error, Try again later';

  static const String SEND_TIMEOUT = 'Time out error, Try again later';

  static const String CACHE_ERROR = 'Cache error, Try again later';

  static const String NO_INTERNET_CONECTION =
      'Please chek your internet connection';

  static const String DEFAULT = 'Some thing want wrong , Try again later';
}

class ApiInternalStatus{
  static const int SUCCESS = 0 ;
  static const int FAILURE = 1 ;
}