import 'dart:async';

import 'package:flutter_bloc_app_2/blocs/abstract/i_category_bloc.dart';
import 'package:flutter_bloc_app_2/data/concrete/in_memory/in_memory_category_service.dart';
import 'package:flutter_bloc_app_2/models/concrete/category.dart';

class InMemoryCategoryBloc implements ICategoryBloc {
  final _inMemoryCategoryStreamController = StreamController.broadcast();

  Stream get getStream => _inMemoryCategoryStreamController.stream;

  void addToCategories(Category category) {
    InMemoryCategoryService.addToCategories(category);
    _inMemoryCategoryStreamController.sink
        .add(InMemoryCategoryService.getAllCategories());
  }

  void updateFromCategories(Category category) {
    InMemoryCategoryService.updateFromCategories(category);
    _inMemoryCategoryStreamController.sink
        .add(InMemoryCategoryService.getAllCategories());
  }

  void removeFromCategories(Category category) {
    InMemoryCategoryService.removeFromCategories(category);
    _inMemoryCategoryStreamController.sink
        .add(InMemoryCategoryService.getAllCategories());
  }

  List<Category> getAllCategories() =>
      InMemoryCategoryService.getAllCategories();
}

final inMemoryCategoryBloc = new InMemoryCategoryBloc();
