import 'package:flutter_bloc_app_2/data/abstract/i_service.dart';
import 'package:flutter_bloc_app_2/models/concrete/youtube_video.dart';

abstract class IYoutubeVideoService implements IService {
  static void addToVideos(YoutubeVideo video) {}
  static void removeFromVideos(YoutubeVideo video) {}
  static void updateFromVideos(YoutubeVideo video) {}
  static List<YoutubeVideo> getAllVideos() {}
}
