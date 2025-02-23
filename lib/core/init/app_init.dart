import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class AppInit {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize EasyLocalization
    await EasyLocalization.ensureInitialized();

    // Initialize Hive
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    // Open Hive boxes
    await Hive.openBox<bool>('app');
    await Hive.openBox<Map<dynamic, dynamic>>('packing_lists');
    await Firebase.initializeApp();
  }
}
