import 'package:clnapp/model/user_setting.dart';
import 'package:get_it/get_it.dart';

class AppProvider {
  void registerDependence<T extends Object>(T implementation,
      {bool eager = false}) {
    GetIt.instance.registerSingleton<T>(implementation);
  }

  void registerLazyDependence<T extends Object>(FactoryFunc<T> factoryFunc) {
    GetIt.instance.registerLazySingleton<T>(factoryFunc);
  }

  void unregisterDependence<T extends Object>() {
    if (GetIt.instance.isRegistered<T>()) {
      GetIt.instance.unregister<T>();
    }
  }

  void overrideDependence<T extends Object>(T instance) {
    unregisterDependence<T>();
    registerDependence<T>(instance);
  }

  T get<T extends Object>() => GetIt.instance.get<T>();

  /// Main init method to initialize the Provider of the application
  /// this will call from the framework
  Future<AppProvider> init() async {
    registerDependence<Setting>(Setting(), eager: true);
    return this;
  }
}
