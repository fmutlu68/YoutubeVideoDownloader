import 'package:flutter_bloc_app_2/data/abstract/iyoutube_video_service.dart';
import 'package:flutter_bloc_app_2/models/concrete/youtube_video.dart';

class InMemoryYoutubeVideoService implements IYoutubeVideoService {
  static List<YoutubeVideo> videos = new List<YoutubeVideo>();

  static InMemoryYoutubeVideoService _singleton =
      new InMemoryYoutubeVideoService._internal();

  factory InMemoryYoutubeVideoService() {
    return _singleton;
  }
  InMemoryYoutubeVideoService._internal();

  @override
  static void addToVideos(YoutubeVideo video) {
    videos.add(video);
  }

  @override
  static void removeFromVideos(YoutubeVideo video) {
    videos.remove(video);
  }

  @override
  static void updateFromVideos(YoutubeVideo video) {
    YoutubeVideo updatedVideo =
        videos.firstWhere((element) => element.id == video.id);
    updatedVideo.categoryId = video.categoryId;
    updatedVideo.name = video.name;
    updatedVideo.videoImage64 = video.videoImage64;
    updatedVideo.youtubeVideoLink = video.youtubeVideoLink;
  }

  @override
  static List<YoutubeVideo> getAllVideos() => videos;
}
