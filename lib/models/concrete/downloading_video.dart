import 'package:flutter_bloc_app_2/models/abstract/i_entity.dart';

class DownloadingVideo implements IEntity {
  double _downloadingStatus = 0.0;
  String _fileName = "Dosya Henüz Oluşturulmadı.";
  String _fileSize = "";
  String _videoQuality = "İndirmeyi Başlatınız.";
  String _videoPath = "";
  String _videoDownloadingState = "İndirmeyi Başlatınız";

  double get getStatus => _downloadingStatus;
  set setStatus(double newStatus) => _downloadingStatus = newStatus;

  String get getName => _fileName;
  set setName(String newName) => _fileName = newName;

  String get getQuality => _videoQuality;
  set setQuality(String newQuality) => _videoQuality = newQuality;

  String get getPath => _videoPath;
  set setPath(String newPath) => _videoPath = newPath;

  String get getDownloadingState => _videoDownloadingState;
  set setDownloadingState(String newDownloadingState) =>
      _videoDownloadingState = newDownloadingState;

  String get getSize => _fileSize;
  set setSize(String newSize) => _fileSize = newSize;

  @override
  int id;
}
