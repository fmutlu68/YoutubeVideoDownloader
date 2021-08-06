import 'package:flutter_bloc_app_2/models/concrete/category.dart';

import 'i_service.dart';

abstract class ICategoryService implements IService {
  static void addToCategories(Category category) {}

  static void removeFromCategories(Category category) {}

  static void updateFromCategories(Category category) {}

  static List<Category> getAllCategories() {}
}
