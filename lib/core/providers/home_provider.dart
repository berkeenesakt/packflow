import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gen/gen.dart';
import 'package:packflow/core/repositories/packing_list_repository.dart';
import 'package:packflow/generated/locale_keys.g.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider({
    required this.packingListRepository,
  }) {
    loadRecentLists();
    loadInProgressLists();
    loadFullyPackedLists();
  }

  final PackingListRepository packingListRepository;

  bool isLoading = true;
  List<PackingList> _recentLists = [];
  List<PackingList> _inProgressLists = [];
  List<PackingList> _fullyPackedLists = [];
  String _travelTip = '';

  List<PackingList> get recentLists => _recentLists;
  List<PackingList> get inProgressLists => _inProgressLists;
  List<PackingList> get fullyPackedLists => _fullyPackedLists;
  String get travelTip => _travelTip;

  Future<void> loadRecentLists() async {
    final allLists = await packingListRepository.getAllPackingLists();

    // Sort by creation date, most recent first
    allLists.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // Take the 3 most recent lists
    _recentLists = allLists.take(3).toList();

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadInProgressLists() async {
    final allLists = await packingListRepository.getAllPackingLists();

    // Lists that are not fully packed (progress < 1.0)
    _inProgressLists = allLists.where((list) => list.progress < 1.0 && list.totalItems > 0).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    // Take the 3 most recent in-progress lists
    _inProgressLists = _inProgressLists.take(3).toList();

    notifyListeners();
  }

  Future<void> loadFullyPackedLists() async {
    final allLists = await packingListRepository.getAllPackingLists();

    // Lists that are fully packed (progress = 1.0) and have at least one item
    _fullyPackedLists = allLists.where((list) => list.progress == 1.0 && list.totalItems > 0).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    // Take the 3 most recent fully packed lists
    _fullyPackedLists = _fullyPackedLists.take(3).toList();

    notifyListeners();
  }

  void _generateRandomTravelTip() {
    final tips = [
      LocaleKeys.home_passport_reminder,
      LocaleKeys.home_charger_reminder,
      LocaleKeys.home_medicine_reminder,
    ];

    final random = Random();
    _travelTip = tips[random.nextInt(tips.length)];
  }

  void refresh() {
    loadRecentLists();
    loadInProgressLists();
    loadFullyPackedLists();
  }
}
