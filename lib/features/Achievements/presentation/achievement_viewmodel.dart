import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../data/models/achievement.dart';

/// ViewModel that loads SVG achievement assets from the Flutter asset manifest,
/// groups them into categories by folder or filename heuristics, and exposes
/// paginated lists per category. This uses lazy loading and notifies listeners
/// for UI updates.
class AchievementViewModel with ChangeNotifier {
  final String assetPrefix = 'assets/achievements/svg_medals/';

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // category -> full list of achievements (from manifest)
  final Map<String, List<Achievement>> _allByCategory = {};

  // category -> currently exposed (paged) list
  final Map<String, List<Achievement>> _pagedByCategory = {};

  // page size per load
  final int pageSize;

  AchievementViewModel({this.pageSize = 12});

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      final assetKeys = manifestMap.keys
          .where((k) => k.startsWith(assetPrefix) && k.toLowerCase().endsWith('.svg'))
          .toList();

      // simple category heuristics: use subfolder if present, otherwise prefix of filename
      for (final asset in assetKeys) {
        final relative = asset.substring(assetPrefix.length);
        String category = 'General';
        String filename = relative;
        if (relative.contains('/')) {
          final parts = relative.split('/');
          category = parts.first;
          filename = parts.last;
        } else if (relative.contains('_')) {
          category = relative.split('_').first;
        }

        final id = asset; // use asset path as id
        final title = _prettyTitleFromFileName(filename);

        final achievement = Achievement(
          id: id,
          title: title,
          description: title,
          assetPath: asset,
          category: category,
          unlocked: false,
        );

        _allByCategory.putIfAbsent(category, () => []).add(achievement);
      }

      // sort categories and items
      for (final cat in _allByCategory.keys) {
        _allByCategory[cat]!.sort((a, b) => a.title.compareTo(b.title));
        _pagedByCategory[cat] = [];
        // load initial page
        _loadPageForCategory(cat);
      }
    } catch (e) {
      if (kDebugMode) print('Error loading achievements manifest: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  List<String> get categories {
    final keys = _allByCategory.keys.toList()..sort();
    return keys;
  }

  List<Achievement> itemsForCategory(String category) {
    return _pagedByCategory[category] ?? [];
  }

  bool canLoadMore(String category) {
    final all = _allByCategory[category] ?? [];
    final paged = _pagedByCategory[category] ?? [];
    return paged.length < all.length;
  }

  Future<void> loadMore(String category) async {
    if (!canLoadMore(category)) return;
    // simulate small delay for UX
    await Future.delayed(const Duration(milliseconds: 250));
    _loadPageForCategory(category);
    notifyListeners();
  }

  void _loadPageForCategory(String category) {
    final all = _allByCategory[category] ?? [];
    final paged = _pagedByCategory.putIfAbsent(category, () => []);
    final remaining = all.length - paged.length;
    if (remaining <= 0) return;
    final take = remaining < pageSize ? remaining : pageSize;
    paged.addAll(all.sublist(paged.length, paged.length + take));
  }

  void unlockAchievement(String id) {
    for (final cat in _allByCategory.keys) {
      final list = _allByCategory[cat]!;
      final idx = list.indexWhere((a) => a.id == id);
      if (idx != -1) {
        final a = list[idx];
        final updated = a.copyWith(unlocked: true, unlockedAt: DateTime.now());
        list[idx] = updated;
        // reflect in paged lists if present
        final pList = _pagedByCategory[cat];
        if (pList != null) {
          final pIdx = pList.indexWhere((x) => x.id == id);
          if (pIdx != -1) pList[pIdx] = updated;
        }
        notifyListeners();
        return;
      }
    }
  }

  static String _prettyTitleFromFileName(String filename) {
    final noExt = filename.split('.').first;
    final parts = noExt.split(RegExp(r'[-_ ]+'));
    final capitalized = parts.map((p) => p.isEmpty ? p : '${p[0].toUpperCase()}${p.substring(1)}').join(' ');
    return capitalized;
  }
}

