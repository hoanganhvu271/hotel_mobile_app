import 'package:isar/isar.dart';
import 'local_db.dart';
import 'package:path_provider/path_provider.dart';

class LocalDbImpl extends LocalDb {
  late Isar db;

  @override
  Future<void> initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    db = await Isar.open(
      [
        //Thêm các schema từ models vào đây.
      ],
      directory: dir.path,
    );
  }

  @override
  Isar getDb() {
    return db;
  }

  @override
  Future<void> cleanDb() async {
    await db.writeTxn(() => cleanDb());
  }
}