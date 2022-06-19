import 'package:get_it/get_it.dart';

class AppProvider {
  void registerDependence<T extends Object>(T implementation,
      {bool eager = false}) {
    GetIt.instance.registerSingleton<T>(implementation);
  }

  void registerLazyDependence<T extends Object>(FactoryFunc<T> factoryFunc) {
    GetIt.instance.registerLazySingleton<T>(factoryFunc);
  }

  T get<T extends Object>() => GetIt.instance.get<T>();

  /// Main init method to initialize the Provider of the application
  /// this will call from the framework
  Future<AppProvider> init() async {
    return this;
  }
}
