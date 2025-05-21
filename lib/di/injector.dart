
import 'package:get_it/get_it.dart';
import '../common/local/cache/local_db.dart';
import '../common/local/cache/local_db_impl.dart';
import '../common/local/shared_prefs/shared_pref.dart';
import '../common/local/shared_prefs/shared_pref_impl.dart';
import '../common/network/dio_client.dart';
import '../common/hotel_storage_provider.dart';

final injector = GetIt.instance;

Future<void> initSingletons() async {
  // Register core services
  injector.registerLazySingleton<SharedPref>(() => SharedPrefImplementation());
  injector.registerSingleton<DioClient>(DioClient());

  // Optionally register local DB if needed
  // injector.registerLazySingleton<LocalDb>(() => LocalDbImpl());
  // await injector<LocalDb>().initDb();
}