import 'package:dartz/dartz.dart';
import 'package:e_commerce_clean/data/data_source/local_data_source.dart';
import 'package:e_commerce_clean/data/mapper/mapper.dart';

import '../../domain/model/models.dart';
import '../../domain/repository/repository.dart';
import '../data_source/remote_data_source.dart';
import '../network/error_handler.dart';
import '../network/failure.dart';
import '../network/network_info.dart';
import '../network/requests.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  final NetworkInfo _networkInfo;

  RepositoryImpl(
      this._remoteDataSource, this._localDataSource, this._networkInfo);

  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      /// its connected to internet , its safe to call api

      try {
        final response = await _remoteDataSource.login(loginRequest);
        if (response.status == ApiInternalStatus.SUCCESS) {
          /// success
          /// return data
          /// return either right
          return Right(response.toDomain());
        } else {
          /// failure -- business error
          /// return either left
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      /// return internet connection error

      return Left(DataSource.NO_INTERNET_CONECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, Authentication>> register(
      RegisterRequest registerRequest) async {
    if (await _networkInfo.isConnected) {
      /// its connected to internet , its safe to call api

      try {
        final response = await _remoteDataSource.register(registerRequest);
        if (response.status == ApiInternalStatus.SUCCESS) {
          /// success
          /// return data
          /// return either right
          return Right(response.toDomain());
        } else {
          /// failure -- business error
          /// return either left
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      /// return internet connection error

      return Left(DataSource.NO_INTERNET_CONECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, HomeObject>> getHomeData() async {
    try {
      /// get response from cache
      final response = await _localDataSource.getHomeData();
      return Right(response.toDomain());
    } catch (cacheError) {
      /// cache is not existing  or cache is not valid
      /// its the time to get from API side
      if (await _networkInfo.isConnected) {
        /// its connected to internet , its safe to call api

        try {
          final response = await _remoteDataSource.getHomeData();
          if (response.status == ApiInternalStatus.SUCCESS) {
            /// success
            /// return data
            /// return either right
            /// save response in cache (local data source)
            _localDataSource.saveHomeToCache(response);
            return Right(response.toDomain());
          } else {
            /// failure -- business error
            /// return either left
            return Left(Failure(ApiInternalStatus.FAILURE,
                response.message ?? ResponseMessage.DEFAULT));
          }
        } catch (error) {
          return Left(ErrorHandler.handle(error).failure);
        }
      } else {
        /// return internet connection error

        return Left(DataSource.NO_INTERNET_CONECTION.getFailure());
      }
    }
  }


}
