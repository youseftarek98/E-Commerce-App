
import 'package:e_commerce_clean/presentations/resources/strings_manager.dart';
import 'package:flutter/material.dart';

import '../../app/di.dart';
import '../forget_password/forget_password_view.dart';
import '../login/view/login_view.dart';
import '../main/main_view.dart';
import '../onboarding/view/onboarding_view.dart';
import '../register/view/register_view.dart';
import '../splash/splash_view.dart';
import '../stores_details/store_details_view.dart';

class Routes {
  static const String splashRoute = '/';

  static const String loginRoute = '/login';

  static const String registerRoute = '/register';

  static const String forgetPasswordRoute = '/forgetPassword';

  static const String mainRoute = '/main';

  static const String storeDetailsRoute = '/storeDetails';

  static const String onBoardingRoute = '/onBoarding';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.loginRoute:
        initLoginModule();
        return MaterialPageRoute(builder: (_) => const LoginView());
      case Routes.registerRoute:
        initRegisterModule();
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case Routes.forgetPasswordRoute:
        return MaterialPageRoute(builder: (_) => const ForgetPasswordView());
      case Routes.mainRoute:
        initHomeModule();
        return MaterialPageRoute(builder: (_) => const MainView());
      case Routes.storeDetailsRoute:
        return MaterialPageRoute(builder: (_) => const StoreDetailsView());
      case Routes.onBoardingRoute:
        return MaterialPageRoute(builder: (_) => const OnBoardingView());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text(AppStrings.noRouteFound),
              ),
              body: const Center(child: Text(AppStrings.noRouteFound)),
            ));
  }
}
