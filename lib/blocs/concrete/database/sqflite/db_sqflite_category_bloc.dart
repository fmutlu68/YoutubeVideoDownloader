import 'dart:async';

import 'package:flutter_bloc_app_2/blocs/abstract/i_category_bloc.dart';
import 'package:flutter_bloc_app_2/data/concrete/sqflite_plugin/sqflite_category_service.dart';
import 'package:flutter_bloc_app_2/models/concrete/category.dart';

class DbSqfliteCategoryBloc implements ICategoryBloc {
  final _sqfliteCategoryStreamController = StreamController.broadcast();

  Stream get getStream => _sqfliteCategoryStreamController.stream;

  Future<String> add(Category category) async {
    int result = 0;
    result = await SqfliteCategoryService.addToCategories(category);
    if (result > 0) {
      _sqfliteCategoryStreamController.sink
          .add(SqfliteCategoryService.getAllCategories());
      return "Kategori Ekleme İşlemi Başarılı";
    }
    return "Kategori Ekleme İşlemi Başarısız.";
  }

  Future<String> delete(Category category) async {
    int result = 0;
    result = await SqfliteCategoryService.deleteFromCategories(category);
    if (result > 0) {
      _sqfliteCategoryStreamController.sink
          .add(SqfliteCategoryService.getAllCategories());
      return "Kategori Silme İşlemi Başarılı";
    }
    return "Kategori Silme İşlemi Başarısız.";
  }

  Future<String> update(Category category) async {
    int result = 0;
    result = await SqfliteCategoryService.updateFromCategories(category);
    if (result > 0) {
      _sqfliteCategoryStreamController.sink
          .add(SqfliteCategoryService.getAllCategories());
      return "Kategori Güncelleme İşlemi Başarılı";
    }
    return "Kategori Güncelleme İşlemi Başarısız.";
  }

  Future<List<Category>> getAll() async {
    return await SqfliteCategoryService.getAllCategories();
  }

  Future<Category> getById(int categoryId) async {
    return await SqfliteCategoryService.getCategoryById(categoryId);
  }
}

final dbSqfliteCategoryBloc = new DbSqfliteCategoryBloc();
