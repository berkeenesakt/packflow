import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gen/gen.dart';
import 'package:hive/hive.dart';
import 'package:packpal/core/repositories/hive_categories_repository.dart';
import 'package:packpal/core/utils/predefined_categories.dart';
import 'package:path_provider/path_provider.dart';

class AppInit {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize EasyLocalization
    await EasyLocalization.ensureInitialized();

    // Initialize Hive
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive
      ..init(appDocumentDir.path)
      ..registerAdapter(PackingListAdapter())
      ..registerAdapter(PackingCategoryAdapter())
      ..registerAdapter(PackingItemAdapter());

    // Open Hive boxes
    await Hive.openBox<bool>('app');
    await Hive.openBox<PackingList>('packing_lists');
    await Hive.openBox<PackingCategory>('categories');
    await Hive.openBox<PackingItem>('packing_items');
    await _initializeDefaultCategories();
    await Firebase.initializeApp();
  }

  static Future<void> _initializeDefaultCategories() async {
    final box = Hive.box<PackingCategory>('categories');

    // Only add default categories if the box is empty
    if (box.isEmpty) {
      final defaultCategories = PredefinedCategories.getDefaultCategories();
      for (final category in defaultCategories) {
        await HiveCategoriesRepository().addCategory(category);
      }
    }
  }
}
