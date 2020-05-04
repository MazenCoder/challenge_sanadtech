import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:challengesanadtech/core/database/app_database.dart';
import 'package:challengesanadtech/core/network/network_info.dart';
import 'package:challengesanadtech/core/util/app_utils_impl.dart';
import 'package:challengesanadtech/core/util/app_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';


final GetIt sl = GetIt.instance;

Future<void> setup() async {
  await init();
  await initUtilsImpl();

}

Future<void> init() async {
  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton(() => http.Client());

  var db = AppDatabase.instance;
  sl.registerLazySingleton(() => db);
}

Future<void> initUtilsImpl() async {
  //sl.registerLazySingleton<AppUtils>(() => AppUtilsImpl(preferences: sl()),);
  sl.registerSingleton<AppUtils>(AppUtilsImpl(preferences: sl(),
      client: sl(), networkInfo: sl(), database: sl()), signalsReady: true);
}