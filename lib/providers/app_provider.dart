import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import '../models/chapter.dart';
import '../models/shloka.dart';

class AppProvider extends ChangeNotifier {
  String _translationLang = 'hi';
  bool _isDarkMode = false;
  double _fontSize = 16.0;
  List<ChapterInfo> _chapters = [];
  List<Shloka> _currentShlokas = [];
  int _currentChapter = 1;
  Set<String> _bookmarks = {};

  // In-memory Marathi translation cache keyed by shloka id.
  final Map<String, String> _marathiCache = {};
  final GoogleTranslator _translator = GoogleTranslator();

  String get translationLang => _translationLang;
  bool get isDarkMode => _isDarkMode;
  double get fontSize => _fontSize;
  List<ChapterInfo> get chapters => _chapters;
  List<Shloka> get currentShlokas => _currentShlokas;
  int get currentChapter => _currentChapter;
  Set<String> get bookmarks => _bookmarks;

  AppProvider() {
    _loadPreferences();
    loadChapters();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkMode') ?? false;
    _fontSize = prefs.getDouble('fontSize') ?? 16.0;
    _translationLang = prefs.getString('translationLang') ?? 'hi';
    _bookmarks = Set<String>.from(prefs.getStringList('bookmarks') ?? []);
    notifyListeners();
  }

  Future<void> loadChapters() async {
    final jsonStr = await rootBundle.loadString('assets/database/contains.json');
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    _chapters = (data['items'] as List)
        .map((e) => ChapterInfo.fromJson(e as Map<String, dynamic>))
        .toList();
    notifyListeners();
  }

  Future<void> loadChapter(int chapterNum) async {
    _currentChapter = chapterNum;
    final jsonStr =
        await rootBundle.loadString('assets/database/chapter$chapterNum.json');
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    _currentShlokas = (data['items'] as List)
        .map((e) => Shloka.fromJson(e as Map<String, dynamic>))
        .toList();
    notifyListeners();
  }

  // Translates hindiText to Marathi. Returns cached result if available.
  Future<String?> getMarathiTranslation(String cacheKey, String hindiText) async {
    if (_marathiCache.containsKey(cacheKey)) return _marathiCache[cacheKey];
    try {
      final result = await _translator.translate(hindiText, from: 'hi', to: 'mr');
      _marathiCache[cacheKey] = result.text;
      return result.text;
    } catch (_) {
      return null;
    }
  }

  void setTranslationLang(String code) async {
    _translationLang = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('translationLang', code);
    notifyListeners();
  }

  void toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode);
    notifyListeners();
  }

  void setFontSize(double size) async {
    _fontSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', size);
    notifyListeners();
  }

  void toggleBookmark(String key) async {
    if (_bookmarks.contains(key)) {
      _bookmarks.remove(key);
    } else {
      _bookmarks.add(key);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bookmarks', _bookmarks.toList());
    notifyListeners();
  }

  bool isBookmarked(String key) => _bookmarks.contains(key);
}
