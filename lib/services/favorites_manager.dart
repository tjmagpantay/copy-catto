import 'package:shared_preferences/shared_preferences.dart';
import '../models/content_item.dart';

class FavoritesManager {
  static final FavoritesManager _instance = FavoritesManager._internal();
  factory FavoritesManager() => _instance;
  FavoritesManager._internal();

  static const String _favoritesKey = 'favorites';
  final Set<String> _favoriteIds = {};
  final List<Function> _listeners = [];

  // Initialize and load favorites from storage
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = prefs.getStringList(_favoritesKey) ?? [];
    _favoriteIds.addAll(savedIds);
  }

  // Add a listener for favorites changes
  void addListener(Function listener) {
    _listeners.add(listener);
  }

  // Remove a listener
  void removeListener(Function listener) {
    _listeners.remove(listener);
  }

  // Notify all listeners
  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  // Check if an item is favorited
  bool isFavorite(String id) {
    return _favoriteIds.contains(id);
  }

  // Toggle favorite status
  Future<void> toggleFavorite(ContentItem item) async {
    if (_favoriteIds.contains(item.id)) {
      _favoriteIds.remove(item.id);
    } else {
      _favoriteIds.add(item.id);
    }
    
    // Save to storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, _favoriteIds.toList());
    
    // Notify listeners
    _notifyListeners();
  }

  // Get all favorite IDs
  Set<String> get favoriteIds => Set.from(_favoriteIds);

  // Clear all favorites
  Future<void> clearAll() async {
    _favoriteIds.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoritesKey);
    _notifyListeners();
  }
}
