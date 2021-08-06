import 'package:flutter_bloc_app_2/models/abstract/i_entity.dart';

class DownloadingAudio implements IEntity {
  double _downloadingStatus = 0.0;
  String _fileName = "Dosya Henüz Oluşturulmadı.";
  String _fileSize = "";
  String _musicPath = "";
  String _musicDownloadingState = "İndirmeyi Başlatınız";

  double get getStatus => _downloadingStatus;
  set setStatus(double newStatus) => _downloadingStatus = newStatus;

  String get getName => _fileName;
  set setName(String newName) => _fileName = newName;

  String get getPath => _musicPath;
  set setPath(String newPath) => _musicPath = newPath;

  String get getDownloadingState => _musicDownloadingState;
  set setDownloadingState(String newDownloadingState) =>
      _musicDownloadingState = newDownloadingState;

  String get getSize => _fileSize;
  set setSize(String newSize) => _fileSize = newSize;

  @override
  int id;
}
