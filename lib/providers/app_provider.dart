import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chapter.dart';
import '../models/shloka.dart';

enum Language { hindi, english }

class AppProvider extends ChangeNotifier {
  Language _language = Language.hindi;
  bool _isDarkMode = false;
  double _fontSize = 16.0;
  List<ChapterInfo> _chapters = [];
  List<Shloka> _currentShlokas = [];
  int _currentChapter = 1;
  Set<String> _bookmarks = {};

  Language get language => _language;
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
    final langIndex = prefs.getInt('language') ?? 0;
    _language = Language.values[langIndex];
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
    final jsonStr = await rootBundle.loadString('assets/database/chapter$chapterNum.json');
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    _currentShlokas = (data['items'] as List)
        .map((e) => Shloka.fromJson(e as Map<String, dynamic>))
        .toList();
    notifyListeners();
  }

  void setLanguage(Language lang) async {
    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('language', lang.index);
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
