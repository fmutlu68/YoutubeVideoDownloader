import 'dart:io';

import 'package:flutter_bloc_app_2/data/abstract/iyoutube_video_service.dart';
import 'package:flutter_bloc_app_2/data/concrete/sqflite_plugin/db_helper.dart';
import 'package:flutter_bloc_app_2/models/concrete/youtube_video.dart';

class SqfliteYoutubeVideoService implements IYoutubeVideoService {
  static DbHelper _dbHelper = new DbHelper();
  static SqfliteYoutubeVideoService _singleton =
      new SqfliteYoutubeVideoService._internal();

  factory SqfliteYoutubeVideoService() {
    return _singleton;
  }

  SqfliteYoutubeVideoService._internal();

  static Future<int> addToVideos(YoutubeVideo video) async {
    var result =
        await (await _dbHelper.db).insert("videos", video.convertToMap());
    return result;
  }

  static Future<int> deleteFromVideos(YoutubeVideo video) async {
    var result = await (await _dbHelper.db)
        .rawDelete("delete from videos where id=${video.id}");
    if (video.videoPath is String && video.videoPath != null) {
      File(video.videoPath).delete(recursive: true);
    }
    return result;
  }

  static Future<int> updateFromVideos(YoutubeVideo video) async {
    var result = await (await _dbHelper.db).update(
        "videos", video.convertToMap(),
        where: "id=?", whereArgs: [video.id]);
    return result;
  }

  static Future<List<YoutubeVideo>> getAllVideos() async {
    var result = await (await _dbHelper.db).query("videos");
    return List.generate(result.length, (i) {
      return YoutubeVideo.from_data(result[i]);
    });
  }

  static Future<List<YoutubeVideo>> getAllVideosByCategoryId(
      int categoryId) async {
    var result = (await (await _dbHelper.db).query("videos"))
        .where((element) => element["category_id"] == categoryId);
    return List.generate(result.length, (i) {
      return YoutubeVideo.from_data(result.elementAt(i));
    });
  }
}
