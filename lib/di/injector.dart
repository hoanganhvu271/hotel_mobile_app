import 'package:get_it/get_it.dart';

import '../common/local/cache/local_db.dart';
import '../common/local/cache/local_db_impl.dart';
import '../common/local/shared_prefs/shared_pref.dart';
import '../common/local/shared_prefs/shared_pref_impl.dart';
import '../common/network/dio_client.dart';

final injector = GetIt.instance;

Future<void> initSingletons() async {
  // injector.registerLazySingleton<LocalDb>(() => LocalDbImpl());
  injector.registerLazySingleton<SharedPref>(() => SharedPrefImplementation());
  injector.registerSingleton<DioClient>(DioClient());
  //initiating db
  // await injector<LocalDb>().initDb();
}