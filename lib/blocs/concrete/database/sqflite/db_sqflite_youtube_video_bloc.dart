import 'dart:async';

import 'package:flutter_bloc_app_2/blocs/abstract/i_youtube_video_bloc.dart';
import 'package:flutter_bloc_app_2/data/concrete/sqflite_plugin/sqflite_youtube_video_service.dart';
import 'package:flutter_bloc_app_2/models/concrete/youtube_video.dart';

class DbSqfliteYoutubeVideoBloc implements IYoutubeVideoBloc {
  final _sqfliteYoutubeVideoStreamController = StreamController.broadcast();
  List<YoutubeVideo> videos;
  Stream get getStream => _sqfliteYoutubeVideoStreamController.stream;

  Future<String> add(YoutubeVideo video) async {
    int result = 0;
    result = await SqfliteYoutubeVideoService.addToVideos(video);
    if (result > 0) {
      _sqfliteYoutubeVideoStreamController.sink
          .add(SqfliteYoutubeVideoService.getAllVideos());
      return "Video Ekleme İşlemi Başarılı";
    }
    return "Video Ekleme İşlemi Başarısız.";
  }

  Future<String> delete(YoutubeVideo video) async {
    int result = 0;
    result = await SqfliteYoutubeVideoService.deleteFromVideos(video);
    if (result > 0) {
      _sqfliteYoutubeVideoStreamController.sink
          .add(SqfliteYoutubeVideoService.getAllVideos());
      return "Video Silme İşlemi Başarılı";
    }
    return "Video Silme İşlemi Başarısız.";
  }

  Future<String> update(YoutubeVideo video) async {
    int result = 0;
    result = await SqfliteYoutubeVideoService.updateFromVideos(video);
    if (result > 0) {
      _sqfliteYoutubeVideoStreamController.sink
          .add(SqfliteYoutubeVideoService.getAllVideos());
      return "Video Güncelleme İşlemi Başarılı";
    }
    return "Video Güncelleme İşlemi Başarısız.";
  }

  Future<List<YoutubeVideo>> getAll() async =>
      await SqfliteYoutubeVideoService.getAllVideos();

  Future<List<YoutubeVideo>> getAllByCategory(int categoryId) async {
    return await SqfliteYoutubeVideoService.getAllVideosByCategoryId(
        categoryId);
  }

  void updateData() {
    _sqfliteYoutubeVideoStreamController.sink
        .add(SqfliteYoutubeVideoService.getAllVideos());
  }
}

final dbSqfliteYoutubeVideoBloc = new DbSqfliteYoutubeVideoBloc();
