import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DbHelper {
  Database _db;
  Future<Database> get db async {
    if (_db == null) {
      this._db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    String dbPath = join((await createVideoDownloaderDir()).path, "youtube.db");
    var db;
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      sqfliteFfiInit();
      var databaseFactory = databaseFactoryFfi;

      var db = await databaseFactory.openDatabase(dbPath,
          options: OpenDatabaseOptions(
            onCreate: createDb,
            version: 1,
          ));
      return db;
    } else {
      String dbPath = join(await getDatabasesPath(), "youtube.db");
      db = await openDatabase(
        dbPath,
        version: 1,
        onCreate: createDb,
      );
      return db;
    }
  }

  void createDb(Database db, int version) {
    db.execute(
        "CREATE TABLE videos(id integer primary key, name text, video_image_64 text, video_path text, category_id integer, youtube_video_link text, video_quality text, music_path text)");
    db.execute(
        "CREATE TABLE categories(id integer primary key, category_name text, parent_id int, directory_path text)");
  }

  Future<Directory> createVideoDownloaderDir() async {
    Directory mainDirectory;
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      mainDirectory = await path_provider.getDownloadsDirectory();
      Directory videoDownloaderDirectory =
          new Directory(mainDirectory.path + "/Youtube Video İndirici");
      if (videoDownloaderDirectory.existsSync() == false) {
        videoDownloaderDirectory =
            await videoDownloaderDirectory.create(recursive: true);
      }
      return videoDownloaderDirectory;
    } else {
      mainDirectory = await path_provider.getApplicationDocumentsDirectory();
      print("Main Directory: ${mainDirectory.path}");
      Directory videoDownloaderDirectory =
          new Directory(mainDirectory.path + "/Youtube Video İndirici");
      if (videoDownloaderDirectory.existsSync() == false) {
        videoDownloaderDirectory =
            await videoDownloaderDirectory.create(recursive: true);
      }
      return videoDownloaderDirectory;
    }
  }
}
