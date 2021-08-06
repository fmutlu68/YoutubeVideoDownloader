import 'package:flutter/material.dart';
import 'package:flutter_bloc_app_2/models/abstract/i_entity.dart';

class YoutubeVideo implements IEntity {
  int id;
  int categoryId;

  String name;
  String videoPath;
  String musicPath;
  String videoImage64;
  String youtubeVideoLink;
  String videoQuality;

  bool isVideoDownloaded;
  bool isAudioDownloaded;

  IconData videoIsDownloadedIcon;
  IconData audioIsDownloadedIcon;

  YoutubeVideo(
      {this.id,
      this.categoryId,
      this.name,
      this.videoImage64,
      this.youtubeVideoLink,
      this.musicPath,
      this.videoQuality,
      this.videoPath}) {
    if (this.videoPath != null) {
      this.isVideoDownloaded = true;
      this.videoIsDownloadedIcon = Icons.ondemand_video_outlined;
    } else {
      this.isVideoDownloaded = false;
      this.videoIsDownloadedIcon = Icons.download_rounded;
    }
    if (this.musicPath != null) {
      this.isAudioDownloaded = true;
      this.audioIsDownloadedIcon = Icons.music_video_rounded;
    } else {
      this.isAudioDownloaded = false;
      this.audioIsDownloadedIcon = Icons.download_rounded;
    }
  }
  YoutubeVideo.from_data(dynamic d) {
    if (d["id"].runtimeType == int && d["id"] != null) {
      this.id = d["id"];
    }
    name = d["name"];
    categoryId = d["category_id"];

    if (d["video_path"] != null && d["video_path"].runtimeType == String) {
      videoPath = d["video_path"];
      videoIsDownloadedIcon = Icons.ondemand_video_outlined;
      isVideoDownloaded = true;
    } else {
      isVideoDownloaded = false;
      videoIsDownloadedIcon = Icons.download_rounded;
    }

    if (d["music_path"] != null && d["music_path"].runtimeType == String) {
      musicPath = d["music_path"];
      audioIsDownloadedIcon = Icons.ondemand_video_outlined;
      isAudioDownloaded = true;
    } else {
      isAudioDownloaded = false;
      audioIsDownloadedIcon = Icons.download_rounded;
    }
    if (d["video_image_64"] != null &&
        d["video_image_64"].runtimeType is String) {
      videoImage64 = d["video_image_64"];
    }
    if (d["video_quality"] != null &&
        d["video_quality"].runtimeType == String) {
      videoQuality = d["video_quality"];
    }
    youtubeVideoLink = d["youtube_video_link"];
  }

  Map<String, dynamic> convertToMap() {
    Map<String, dynamic> data = new Map();
    if (id != null) {
      data["id"] = id;
    }
    data["name"] = name;
    if (videoImage64 != null) {
      data["video_image_64"] = videoImage64;
    }
    data["category_id"] = categoryId;
    if (videoPath != null) {
      data["video_path"] = videoPath;
    }
    if (videoQuality != null) {
      data["video_quality"] = videoQuality;
    }
    if (musicPath != null) {
      data["music_path"] = musicPath;
    }
    data["youtube_video_link"] = youtubeVideoLink;
    return data;
  }
}
