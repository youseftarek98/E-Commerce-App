import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/app_prefs.dart';
import '../../app/di.dart';

import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/constant_manager.dart';
import '../resources/routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;

  final AppPreferences _appPreferences = instance<AppPreferences>();

  _startDelay() {
    _timer = Timer( const Duration(seconds: AppConstants.splashDelay), _goNext);
  }

  _goNext() async {
    _appPreferences.isUserLoggedIn().then((isUserLoggedIn) => {
          if (isUserLoggedIn)
            {
              /// navigate to main screen
              Navigator.pushReplacementNamed(context, Routes.mainRoute)
            }
          else
            {
              _appPreferences
                  .isOnBoardingScreen()
                  .then((isOnBoardingScreen) => {
                        if (isOnBoardingScreen)
                          {
                            /// navigate to login screen

                            Navigator.pushReplacementNamed(
                                context, Routes.loginRoute)
                          }
                        else
                          {
                            /// navigate to on boarding  screen
                            Navigator.pushReplacementNamed(
                                context, Routes.onBoardingRoute)
                          }
                      })
            }
        });
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: const Center(
        child: Image(image: AssetImage(ImageAssets.splashLogo)),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
