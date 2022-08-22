import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';

import '../../common/state_renderer/state_rendere_impl.dart';

import '../../resources/assets_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/routes.dart';
import '../../resources/strings_manager.dart';
import '../../resources/values_manager.dart';
import '../viewmodel/login_viewmodel.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginViewModel _viewModel = instance<LoginViewModel>();

  final AppPreferences _appPreferences = instance<AppPreferences>();

  final TextEditingController _userNameController = TextEditingController();

  final TextEditingController _userPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  _bind() {
    _viewModel.start();

    /// call view model , start your job
    _userNameController
        .addListener(() => _viewModel.setUserName(_userNameController.text));
    _userPasswordController.addListener(
        () => _viewModel.setUserPassword(_userPasswordController.text));
    _viewModel.isUserLoggedSuccessfullyStreamController.stream
        .listen((isLoggedIn) {
      if (isLoggedIn) {
        /// navigate to main screen
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _appPreferences.setUserLoggedIn();
          Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
        });
      }
    });
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (_, snapshot) {
          return snapshot.data?.getScreenWidget(_, _getContentWidget(), () {
                _viewModel.login();
              }) ??
              _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
      //  height: double.infinity,
      padding: const EdgeInsets.only(top: AppPadding.p100),
      color: ColorManager.white,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Center(

                  ///child: SvgPicture.asset(ImageAssets.iconLogo),
                  child: Image(
                image: AssetImage(ImageAssets.splashLogo),
                height: 250,
                width: 250,
              )),
              const SizedBox(
                height: AppSize.s28,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: StreamBuilder<bool>(
                    stream: _viewModel.outIsUserNameValid,
                    builder: (_, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _userNameController,
                        decoration: InputDecoration(
                            hintText: AppStrings.userName,
                            labelText: AppStrings.userName,
                            errorText: (snapshot.data ?? true)
                                ? null
                                : AppStrings.userNameError),
                      );
                    }),
              ),
              const SizedBox(
                height: AppSize.s28,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: StreamBuilder<bool>(
                    stream: _viewModel.outIsUserPasswordValid,
                    builder: (_, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: _userPasswordController,
                        decoration: InputDecoration(
                            hintText: AppStrings.password,
                            labelText: AppStrings.password,
                            errorText: (snapshot.data ?? true)
                                ? null
                                : AppStrings.passwordError),
                      );
                    }),
              ),
              const SizedBox(
                height: AppSize.s28,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: StreamBuilder<bool>(
                    stream: _viewModel.outAreAllOutputsValid,
                    builder: (_, snapshot) {
                      return SizedBox(
                        width: double.infinity,
                        height: AppSize.s40,
                        child: ElevatedButton(
                          onPressed: (snapshot.data ?? false)
                              ? () {
                                  _viewModel.login();
                                }
                              : null,
                          child: const Text(AppStrings.login),
                        ),
                      );
                    }),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                      top: AppPadding.p8,
                      left: AppPadding.p8,
                      right: AppPadding.p8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, Routes.forgetPasswordRoute);
                          },
                          child: Text(
                            AppStrings.forgetPassword,
                            style: Theme.of(context).textTheme.titleMedium,
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, Routes.registerRoute);
                          },
                          child: Text(
                            AppStrings.registerText,
                            style: Theme.of(context).textTheme.titleMedium,
                          )),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
