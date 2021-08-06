import 'package:flutter_bloc_app_2/models/abstract/i_entity.dart';

class Category implements IEntity {
  int id;
  int parentId;
  int countHasVideo;
  int countHasDownloadedVideo;
  int countHasDownloadedAudio;

  String categoryName;
  String directoryPath;

  Category({this.id, this.categoryName, this.directoryPath});

  Category.with_parent(
      {this.id, this.categoryName, this.directoryPath, this.parentId});

  Category.from_data(dynamic o) {
    print("Category From Data ${o["id"].runtimeType == int}");
    if (o["id"].runtimeType == int && o["id"] != null) {
      id = o["id"];
    }
    categoryName = o["category_name"];
    directoryPath = o["directory_path"];
    if (o["parent_id"].runtimeType == int && o["parent_id"] != null) {
      parentId = o["parent_id"];
    }
  }

  Map<String, dynamic> convertToMap() {
    var map = new Map<String, dynamic>();

    if (id != null) map["id"] = id;

    map["category_name"] = categoryName;

    if (parentId != null) map["parent_id"] = parentId;

    map["directory_path"] = directoryPath;
    return map;
  }
}
