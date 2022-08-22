import 'package:dartz/dartz.dart';

import '../../data/network/requests.dart';
import '../../domain/model/models.dart';
import '../../data/network/failure.dart';

abstract class Repository {
  Future<Either<Failure, Authentication>> login(LoginRequest loginRequest);

  Future<Either<Failure, Authentication>> register(
      RegisterRequest registerRequest);

  Future<Either<Failure, HomeObject>> getHomeData();
}
