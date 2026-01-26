import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/place.dart';

class StorageService {
  static const String _favoritesKey = 'favorites';
  static const String _visitedKey = 'visited';
  static const String _nicknameKey = 'nickname';
  static const String _bioKey = 'bio';
  static const String _blockedAuthorsKey = 'blocked_authors';
  static const String _hiddenStoriesKey = 'hidden_stories';
  static const String _likedStoriesKey = 'liked_stories';
  static const String _itinerariesKey = 'itineraries';

  Future<String> getNickname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nicknameKey) ?? '漫游雨林的树懒';
  }

  Future<void> saveNickname(String nickname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nicknameKey, nickname);
  }

  Future<String> getBio() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_bioKey) ?? '慢慢走，欣赏啊～生活不止眼前的苟且 🌿';
  }

  Future<void> saveBio(String bio) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_bioKey, bio);
  }

  // 拉黑作者
  Future<void> blockAuthor(String authorName) async {
    final prefs = await SharedPreferences.getInstance();
    final blocked = prefs.getStringList(_blockedAuthorsKey) ?? [];
    if (!blocked.contains(authorName)) {
      blocked.add(authorName);
      await prefs.setStringList(_blockedAuthorsKey, blocked);
    }
  }

  Future<List<String>> getBlockedAuthors() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_blockedAuthorsKey) ?? [];
  }

  Future<bool> isAuthorBlocked(String authorName) async {
    final blocked = await getBlockedAuthors();
    return blocked.contains(authorName);
  }

  Future<void> saveBlockedAuthors(List<String> authors) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_blockedAuthorsKey, authors);
  }

  // 屏蔽内容
  Future<void> hideStory(String storyId) async {
    final prefs = await SharedPreferences.getInstance();
    final hidden = prefs.getStringList(_hiddenStoriesKey) ?? [];
    if (!hidden.contains(storyId)) {
      hidden.add(storyId);
      await prefs.setStringList(_hiddenStoriesKey, hidden);
    }
  }

  Future<List<String>> getHiddenStories() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_hiddenStoriesKey) ?? [];
  }

  Future<bool> isStoryHidden(String storyId) async {
    final hidden = await getHiddenStories();
    return hidden.contains(storyId);
  }

  Future<void> saveHiddenStories(List<String> stories) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_hiddenStoriesKey, stories);
  }

  // 点赞故事
  Future<void> likeStory(String storyId) async {
    final prefs = await SharedPreferences.getInstance();
    final liked = prefs.getStringList(_likedStoriesKey) ?? [];
    if (!liked.contains(storyId)) {
      liked.add(storyId);
      await prefs.setStringList(_likedStoriesKey, liked);
    }
  }

  Future<void> unlikeStory(String storyId) async {
    final prefs = await SharedPreferences.getInstance();
    final liked = prefs.getStringList(_likedStoriesKey) ?? [];
    liked.remove(storyId);
    await prefs.setStringList(_likedStoriesKey, liked);
  }

  Future<List<String>> getLikedStories() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_likedStoriesKey) ?? [];
  }

  Future<bool> isStoryLiked(String storyId) async {
    final liked = await getLikedStories();
    return liked.contains(storyId);
  }

  // 行程管理
  Future<List<Map<String, dynamic>>> getItineraries() async {
    final prefs = await SharedPreferences.getInstance();
    final String? itinerariesJson = prefs.getString(_itinerariesKey);

    if (itinerariesJson == null) {
      // 返回默认行程
      final defaultItinerary = {
        'id': 'default_2',
        'title': '云南大理之旅',
        'destination': '大理',
        'departureDate': '2024-04-15',
        'duration': '3天2夜',
        'distance': '约2000公里',
        'imageUrl':
            'assets/images/outside/johannes-andersson-UCd78vfC8vU-unsplash.jpg',
        'color': 0xFF10B981,
      };

      // 保存默认行程
      await saveItineraries([defaultItinerary]);
      return [defaultItinerary];
    }

    final List<dynamic> decoded = jsonDecode(itinerariesJson);
    return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  Future<void> saveItineraries(List<Map<String, dynamic>> itineraries) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(itineraries);
    await prefs.setString(_itinerariesKey, encoded);
  }

  Future<void> addItinerary(Map<String, dynamic> itinerary) async {
    final itineraries = await getItineraries();
    itineraries.insert(0, itinerary); // 添加到列表开头
    await saveItineraries(itineraries);
  }

  Future<void> deleteItinerary(String id) async {
    final itineraries = await getItineraries();
    itineraries.removeWhere((item) => item['id'] == id);
    await saveItineraries(itineraries);
  }

  Future<List<Place>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(_favoritesKey);
    if (favoritesJson == null) return [];

    final List<dynamic> decoded = jsonDecode(favoritesJson);
    return decoded.map((json) => Place.fromJson(json)).toList();
  }

  Future<void> saveFavorites(List<Place> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded =
        jsonEncode(favorites.map((p) => p.toJson()).toList());
    await prefs.setString(_favoritesKey, encoded);
  }

  Future<void> addFavorite(Place place) async {
    final favorites = await getFavorites();
    if (!favorites.any((p) => p.id == place.id)) {
      favorites.add(place);
      await saveFavorites(favorites);
    }
  }

  Future<void> removeFavorite(String placeId) async {
    final favorites = await getFavorites();
    favorites.removeWhere((p) => p.id == placeId);
    await saveFavorites(favorites);
  }

  Future<bool> isFavorite(String placeId) async {
    final favorites = await getFavorites();
    return favorites.any((p) => p.id == placeId);
  }

  Future<List<String>> getVisitedPlaces() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_visitedKey) ?? [];
  }

  Future<void> addVisitedPlace(String placeId) async {
    final prefs = await SharedPreferences.getInstance();
    final visited = await getVisitedPlaces();
    if (!visited.contains(placeId)) {
      visited.add(placeId);
      await prefs.setStringList(_visitedKey, visited);
    }
  }
}
