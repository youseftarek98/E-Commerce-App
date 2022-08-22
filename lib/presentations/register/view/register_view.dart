import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../app/app_prefs.dart';
import '../../../app/constants.dart';
import '../../../app/di.dart';


import '../../common/state_renderer/state_rendere_impl.dart';

import '../../resources/assets_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/routes.dart';
import '../../resources/strings_manager.dart';
import '../../resources/values_manager.dart';
import '../viewmodel/register_viewmodel.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterViewModel _viewModel = instance<RegisterViewModel>();
  final ImagePicker _imagePicker = instance<ImagePicker>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameTextEditingController =
      TextEditingController();

  final TextEditingController _emailTextEditingController =
      TextEditingController();

  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  final TextEditingController _mobileNumberTextEditingController =
      TextEditingController();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  _bind() {
    _viewModel.start();
    _userNameTextEditingController.addListener(() {
      _viewModel.setUserName(_userNameTextEditingController.text);
    });
    _emailTextEditingController.addListener(() {
      _viewModel.setEmail(_emailTextEditingController.text);
    });
    _passwordTextEditingController.addListener(() {
      _viewModel.setPassword(_passwordTextEditingController.text);
    });
    _mobileNumberTextEditingController.addListener(() {
      _viewModel.setMobileNumber(_mobileNumberTextEditingController.text);
    });
    _viewModel.isUserRegisterSuccessfullyStreamController.stream
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
      appBar: AppBar(
        elevation: AppSize.s0,
        backgroundColor: ColorManager.white,
        iconTheme: IconThemeData(color: ColorManager.primary),
      ),
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (_, snapshot) {
          return snapshot.data?.getScreenWidget(_, _getContentWidget(), () {
                _viewModel.register();
              }) ??
              _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
      //  height: double.infinity,
      padding: const EdgeInsets.only(top: AppPadding.p28),
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
                child: StreamBuilder<String?>(
                    stream: _viewModel.outputsErrorUserName,
                    builder: (_, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _userNameTextEditingController,
                        decoration: InputDecoration(
                            hintText: AppStrings.userName,
                            labelText: AppStrings.userName,
                            errorText: snapshot.data),
                      );
                    }),
              ),
              const SizedBox(
                height: AppSize.s18,
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: CountryCodePicker(
                          onChanged: (country) {
                            /// update view model with code
                            _viewModel.setCountryCode(
                                country.dialCode ?? Constants.token);
                          },
                          initialSelection: '+20',
                          favorite: const ['+39', 'FR', '+966'],
                          // optional. Shows only country name and flag
                          showCountryOnly: true,
                          hideMainText: true,
                          // optional. Shows only country name and flag when popup is closed.
                          showOnlyCountryWhenClosed: true,
                        )),
                    Expanded(
                        flex: 4,
                        child: StreamBuilder<String?>(
                            stream: _viewModel.outputsErrorMobileNumber,
                            builder: (_, snapshot) {
                              return TextFormField(
                                keyboardType: TextInputType.phone,
                                controller: _mobileNumberTextEditingController,
                                decoration: InputDecoration(
                                    hintText: AppStrings.mobileNumber,
                                    labelText: AppStrings.mobileNumber,
                                    errorText: snapshot.data),
                              );
                            }))
                  ],
                ),
              )),
              const SizedBox(
                height: AppSize.s18,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: StreamBuilder<String?>(
                    stream: _viewModel.outputsErrorEmail,
                    builder: (_, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailTextEditingController,
                        decoration: InputDecoration(
                            hintText: AppStrings.emailHint,
                            labelText: AppStrings.emailHint,
                            errorText: snapshot.data),
                      );
                    }),
              ),
              const SizedBox(
                height: AppSize.s18,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: StreamBuilder<String?>(
                    stream: _viewModel.outputsErrorPassword,
                    builder: (_, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passwordTextEditingController,
                        decoration: InputDecoration(
                            hintText: AppStrings.password,
                            labelText: AppStrings.password,
                            errorText: snapshot.data),
                      );
                    }),
              ),
              const SizedBox(
                height: AppSize.s18,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: Container(
                  height: AppSize.s40,
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(AppSize.s8)),
                      border: Border.all(color: ColorManager.grey)),
                  child: GestureDetector(
                    child: _getMediaWidget(),
                    onTap: () {
                      _showPicker(context);
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: AppSize.s40,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: StreamBuilder<bool>(
                    stream: _viewModel.outputAreAllInputsValid,
                    builder: (_, snapshot) {
                      return SizedBox(
                        width: double.infinity,
                        height: AppSize.s40,
                        child: ElevatedButton(
                          onPressed: (snapshot.data ?? false)
                              ? () {
                                  _viewModel.register();
                                }
                              : null,
                          child: const Text(AppStrings.register),
                        ),
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: AppPadding.p18,
                    left: AppPadding.p8,
                    right: AppPadding.p8),
                child: TextButton(
                    onPressed: () {
                      // Navigator.pushReplacementNamed(
                      //     context, Routes.loginRoute);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppStrings.alreadyHaveAccount,
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagePicketByUser(File? image) {
    if (image != null && image.path.isNotEmpty) {
      /// return image
      return Image.file(image);
    } else {
      return Container();
    }
  }

  _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
              child: Wrap(
            children: [
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.camera),
                title: const Text(AppStrings.photoGallery),
                onTap: () {
                  _imageFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text(AppStrings.photoCamera),
                onTap: () {
                  _imageFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
        });
  }

  _imageFromGallery() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    _viewModel.setProfilePicture(File(image?.path ?? ''));
  }

  _imageFromCamera() async {
    var image = await _imagePicker.pickImage(source: ImageSource.camera);
    _viewModel.setProfilePicture(File(image?.path ?? ''));
  }

  Widget _getMediaWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: AppPadding.p8, right: AppPadding.p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Flexible(child: Text(AppStrings.profilepicture)),
          Flexible(
              child: StreamBuilder<File>(
            stream: _viewModel.outputProfilePicture,
            builder: (context, snapshot) {
              return _imagePicketByUser(snapshot.data);
            },
          )),
          const Flexible(
              child: Image(
            image: AssetImage(ImageAssets.profileCamera),
          )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
