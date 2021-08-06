import 'dart:async';

import 'package:flutter_bloc_app_2/blocs/abstract/i_downloader_bloc.dart';
import 'package:flutter_bloc_app_2/blocs/concrete/database/sqflite/db_sqflite_youtube_video_bloc.dart';
import 'package:flutter_bloc_app_2/data/concrete/downloader/downloader_service.dart';
import 'package:flutter_bloc_app_2/models/concrete/downloading_audio.dart';
import 'package:flutter_bloc_app_2/models/concrete/downloading_video.dart';
import 'package:flutter_bloc_app_2/models/concrete/youtube_video.dart';

class VideoDownloaderBloc implements IDownlaoderBloc {
  final _videoDownloaderStreamController = StreamController.broadcast();

  Stream get getStream => _videoDownloaderStreamController.stream;

  DownloaderService _downloaderService = new DownloaderService();

  DownloadingAudio get getAudio => _downloaderService.getAudio;

  DownloadingVideo get getVideo => _downloaderService.getVideo;

  Future<void> downloadVideo(YoutubeVideo video) async {
    await _downloaderService.downloadVideo(video);
    dbSqfliteYoutubeVideoBloc.update(video);
  }

  Future<void> downloadAudio(YoutubeVideo video) async {
    await _downloaderService.downloadOnlyAudio(video);
    dbSqfliteYoutubeVideoBloc.update(video);
  }
}

final videoDownloaderBloc = new VideoDownloaderBloc();
