
import 'package:dartz/dartz.dart';
import 'package:e_commerce_clean/domain/usecase/base_usecase.dart';

import '../../data/network/failure.dart';
import '../../data/network/requests.dart';
import '../model/models.dart';
import '../repository/repository.dart';

class RegisterUseCase
    implements BaseUseCase<RegisterUseCaseInput, Authentication> {
  final Repository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
      RegisterUseCaseInput input) async {
    return await _repository.register(RegisterRequest(
        input.userName,
        input.countryMobileCode,
        input.mobileNumber,
        input.email,
        input.password,
        input.profilePicture));
  }
}

class RegisterUseCaseInput {
  String userName;

  String countryMobileCode;

  String mobileNumber;

  String email;

  String password;

  String profilePicture;

  RegisterUseCaseInput(this.userName, this.countryMobileCode, this.mobileNumber,
      this.email, this.password, this.profilePicture);
}
