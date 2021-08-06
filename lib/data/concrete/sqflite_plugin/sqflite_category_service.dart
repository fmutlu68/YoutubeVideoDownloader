import 'dart:io';

import 'package:flutter_bloc_app_2/data/abstract/icategory_service.dart';
import 'package:flutter_bloc_app_2/data/concrete/sqflite_plugin/db_helper.dart';
import 'package:flutter_bloc_app_2/models/concrete/category.dart';
import 'package:path_provider/path_provider.dart';

class SqfliteCategoryService implements ICategoryService {
  static DbHelper _dbHelper = _dbHelper = new DbHelper();
  static SqfliteCategoryService _singleton =
      new SqfliteCategoryService._internal();

  factory SqfliteCategoryService() {
    return _singleton;
  }

  SqfliteCategoryService._internal();

  static Future<int> addToCategories(Category category) async {
    String mainPath = (await _dbHelper.createVideoDownloaderDir()).path;
    Directory mainDirPath =
        await (Directory("$mainPath/Videolar Ve Ses Dosyaları")
            .create(recursive: true));
    String mainCategoryPath = category.parentId == null
        ? await mainDirPath.path
        : (await getCategoryById(category.parentId)).directoryPath;
    print("Category Path: ${'$mainCategoryPath/${category.categoryName}'}");
    Directory dir =
        await Directory("$mainCategoryPath/${category.categoryName}")
            .create(recursive: true);
    category.directoryPath = dir.path;
    var result = await (await _dbHelper.db)
        .insert("categories", category.convertToMap());
    return result;
  }

  static Future<int> deleteFromCategories(Category category) async {
    var result = await (await _dbHelper.db)
        .rawDelete("delete from videos where id=${category.id}");
    if (category.directoryPath.runtimeType is String &&
        category.directoryPath != null) {
      File(category.directoryPath).delete(recursive: true);
    }
    return result;
  }

  static Future<int> updateFromCategories(Category category) async {
    List<Category> test = await getAllCategories();
    test.forEach((element) async {
      if (element.id == category.id) {
        if (category.categoryName != element.categoryName) {
          print("İfe Girildi");
          category = await _changeDirectory(element, category);
        }
      }
    });
    var result = await (await _dbHelper.db).update(
        "categories", category.convertToMap(),
        where: "id=?", whereArgs: [category.id]);
    return result;
  }

  static Future<List<Category>> getAllCategories() async {
    var result = await (await _dbHelper.db).query("categories");
    return List.generate(result.length, (index) {
      return Category.from_data(result[index]);
    });
  }

  static Future<Category> _changeDirectory(
      Category element, Category category) async {
    print("İfe Girildi");
    Directory dir = Directory(element.directoryPath);
    Directory newDir = await dir.rename(
        '${(await getDownloadsDirectory()).path}/Youtube Video İndirici - İndirilen Videolar/${category.categoryName}');
    category.directoryPath = newDir.path;
    print("Updating Category Path: ${category.directoryPath}");
    return category;
  }

  static Future<Category> getCategoryById(int id) async {
    Category c;
    (await getAllCategories()).forEach((element) {
      if (element.id == id) {
        c = element;
      }
    });
    return c;
  }
}
