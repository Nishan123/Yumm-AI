import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yumm_ai/core/services/storage/user_session_service.dart';

final searchHistoryServiceProvider = Provider<SearchHistoryService>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return SearchHistoryService(prefs: prefs);
});

class SearchHistoryService {
  final SharedPreferences _prefs;
  static const String _keySearchHistory = 'search_history';
  static const int _maxHistoryLength = 10;

  SearchHistoryService({required SharedPreferences prefs}) : _prefs = prefs;

  List<String> getSearchHistory() {
    return _prefs.getStringList(_keySearchHistory) ?? [];
  }

  Future<void> saveSearchTerm(String term) async {
    if (term.trim().isEmpty) return;

    List<String> history = getSearchHistory();
    // Remove if already exists to move it to the top
    history.remove(term);
    // Add to the beginning
    history.insert(0, term);

    // Keep only max length
    if (history.length > _maxHistoryLength) {
      history = history.sublist(0, _maxHistoryLength);
    }

    await _prefs.setStringList(_keySearchHistory, history);
  }

  Future<void> clearSearchHistory() async {
    await _prefs.remove(_keySearchHistory);
  }

  Future<void> removeSearchTerm(String term) async {
    List<String> history = getSearchHistory();
    history.remove(term);
    await _prefs.setStringList(_keySearchHistory, history);
  }
}
