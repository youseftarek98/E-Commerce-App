import 'package:dio/dio.dart';
import 'package:e_commerce_clean/data/data_source/local_data_source.dart';
import 'package:e_commerce_clean/domain/usecase/home_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../data/data_source/remote_data_source.dart';
import '../data/network/app_api.dart';
import '../data/network/dio_factory.dart';
import '../data/network/network_info.dart';
import '../data/repository/repository_impl.dart';
import '../domain/repository/repository.dart';
import '../domain/usecase/login_usecase.dart';
import '../domain/usecase/register_usecase.dart';

import '../presentations/login/viewmodel/login_viewmodel.dart';
import '../presentations/main/pages/home/viewmodel/home_viewmodel.dart';
import '../presentations/register/viewmodel/register_viewmodel.dart';

import 'app_prefs.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  /// app module , its a module where we put all generic dependencies

  /// shared prefs instance
  final sharedPrefs = await SharedPreferences.getInstance();

  /// instance.registerSingleton(instance) ;

  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  /// app prefs instance
  /// AppPreferences appPreferences = AppPreferences(sharedPrefs);

  instance
      .registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));

  /// network info instance
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));

  /// instance dio factory
  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));

  /// instance app service client
  Dio dio = await instance<DioFactory>().getDio();
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  ///remote data source

  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(instance<AppServiceClient>()));

  /// local data source
  instance.registerLazySingleton<LocalDataSource>(
          () => LocalDataSourceImp());

   //instance.registerLazySingleton<LocalDataSource>(() =>  LocalDataSourceImp());

  /// instance repository
  instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(instance(), instance(), instance()));
}

initLoginModule() {
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
    instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
  }
}

initRegisterModule() {
  if (!GetIt.I.isRegistered<RegisterUseCase>()) {
    instance
        .registerFactory<RegisterUseCase>(() => RegisterUseCase(instance()));
    instance.registerFactory<RegisterViewModel>(
        () => RegisterViewModel(instance()));
    instance.registerFactory<ImagePicker>(() => ImagePicker());
  }
}

initHomeModule() {
  if (!GetIt.I.isRegistered<HomeUseCase>()) {
    instance.registerFactory<HomeUseCase>(() => HomeUseCase(instance()));
    instance.registerFactory<HomeViewModel>(() => HomeViewModel(instance()));
  }
}

