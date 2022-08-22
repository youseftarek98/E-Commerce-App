import 'dart:async';

import '../../../domain/usecase/login_usecase.dart';
import '../../common/freezed_data_class.dart';
import '../../common/state_renderer/state_rendere_impl.dart';
import '../../common/state_renderer/state_renderer.dart';
import '../../base/base_view_model.dart';

class LoginViewModel extends BaseViewModel
    with LoginViewModelInputs, LoginViewModelOutputs {
  final StreamController _userNameStreamController =
      StreamController<String>.broadcast();
  final StreamController _passwordStreamController =
      StreamController<String>.broadcast();
  final StreamController _areAllInputsValidStreamController =
      StreamController<void>.broadcast();

  StreamController isUserLoggedSuccessfullyStreamController =
      StreamController<bool>();

  var loginObject = LoginObject('', '');
  final LoginUseCase _loginUseCase;

  LoginViewModel(this._loginUseCase);

  /// Inputs
  @override
  void dispose() {
    super.dispose();
    _userNameStreamController.close();
    _passwordStreamController.close();
    _areAllInputsValidStreamController.close();
    isUserLoggedSuccessfullyStreamController.close();
  }

  @override
  void start() {
    /// view model should tell view please show content state
    inputState.add(ContentState());
  }

  @override
  Sink get inputUserName => _userNameStreamController.sink;

  @override
  Sink get inputUserPassword => _passwordStreamController.sink;

  @override
  Sink get inputAreAllInputsValid => _areAllInputsValidStreamController.sink;

  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    loginObject = loginObject.copyWith(userName: userName);
    inputAreAllInputsValid.add(null);
  }

  @override
  setUserPassword(String password) {
    inputUserPassword.add(password);
    loginObject = loginObject.copyWith(password: password);
    inputAreAllInputsValid.add(null);
  }

  @override
  login() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _loginUseCase.execute(
            LoginUseCaseInput(loginObject.userName, loginObject.password)))
        .fold(
            (failure) => {
                  /// left -> failure
                  inputState.add(ErrorState(
                      StateRendererType.popupErrorState, failure.message))
                }, (data) {
      /// right -> data ()success

      /// content
      inputState.add(ContentState());

      /// navigate to main screen
      isUserLoggedSuccessfullyStreamController.add(true);
    });
  }

  /// Outputs
  @override
  Stream<bool> get outIsUserNameValid => _userNameStreamController.stream
      .map((userName) => _isUserNameValid(userName));

  @override
  Stream<bool> get outIsUserPasswordValid => _passwordStreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  Stream<bool> get outAreAllOutputsValid =>
      _areAllInputsValidStreamController.stream
          .map((_) => _areAllInputsValid());

  bool _isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  bool _isUserNameValid(String userName) {
    return userName.isNotEmpty;
  }

  bool _areAllInputsValid() {
    return _isPasswordValid(loginObject.password) &&
        _isUserNameValid(loginObject.userName);
  }
}

abstract class LoginViewModelInputs {
  setUserName(String userName);

  setUserPassword(String password);

  login();

  Sink get inputUserName;

  Sink get inputUserPassword;

  Sink get inputAreAllInputsValid;
}

abstract class LoginViewModelOutputs {
  Stream<bool> get outIsUserNameValid;

  Stream<bool> get outIsUserPasswordValid;

  Stream<bool> get outAreAllOutputsValid;
}
