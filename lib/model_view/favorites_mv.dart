import 'dart:convert';

import 'package:cfc_christ/database/app_preferences.dart';
import 'package:flutter_cache_manager_dio/flutter_cache_manager_dio.dart';

class FavoritesMv {
  static const String storeKey = '';

  static final FavoriteModelType type = FavoriteModelType();

  List<FavoriteModelData> get favorites {
    String? content = CAppPreferences().instance?.getString(storeKey);

    if (content != null) {
      var data = jsonDecode(content) as List<Map>;

      List<FavoriteModelData> contents = [];
      for (Map content in data) {
        contents.add(
          FavoriteModelData(type: content['type'], content: content['content'], audioPath: content['audio_path']),
        );
      }

      return contents;
    }

    return [];
  }

  /// Store will replace overrid content if it all ready exist.
  Future<void> store(String type, Map content, String? audioPath) async {
    var model = FavoriteModelData(type: type, content: content, audioPath: audioPath);

    // check if new content is unique.
    List<FavoriteModelData> newList = [];

    for (var content in favorites) {
      if (content.type != model.type && content.content['id'] != model.content['id']) {
        newList.add(content);
      } else {
        _removeAudio(content.audioPath);
      }
    }

    newList.add(model);

    _set(newList);
  }

  Future<String> downloadAudio(String type, String contentId, String audioPid) async {
    return 'no path provided. no audio file downloaded.';
  }

  void _removeAudio(String? audioPath) {
    // TODO: read the cache man doc for remove file from it.
    if (audioPath != null) DioCacheManager.instance.removeFile(audioPath);
  }

  Future<FavoriteModelData?> get(String type, String contentId) async {
    for (FavoriteModelData favorite in favorites) {
      if (favorite.type == type && favorite.content['id'] == contentId) return favorite;
    }

    return null;
  }

  bool isInFavorites(String type, String contentId) {
    for (FavoriteModelData favorite in favorites) {
      if (favorite.type == type && favorite.content['id'] == contentId) return true;
    }

    return false;
  }

  Future<void> remove(String type, String contentId) async {
    List<FavoriteModelData> newList = [];

    for (FavoriteModelData favorite in favorites) {
      if (favorite.type == type && favorite.content['id'] == contentId) {
        newList.add(favorite);
      } else {
        _removeAudio(favorite.audioPath);
      }
    }

    _set(newList);
  }

  Future<void> cleanCache() async => _set([]);

  Future<void> updateAudioPath(String type, String contentId, String audioPath) async {
    FavoriteModelData? favorite = await get(type, contentId);

    favorite?.audioPath = audioPath;

    if (favorite != null) store(type, favorite.content, audioPath);
  }

  void _set(List<FavoriteModelData> data) => CAppPreferences().instance?.setString(storeKey, jsonEncode(data));
}

class FavoriteModelType {
  final String communication = 'COM';
  final String echo = 'ECHO';
  final String teaching = 'TEACHING';
}

class FavoriteModelData {
  String type;
  Map content;
  String? audioPath;

  FavoriteModelData({required this.type, required this.content, this.audioPath});

  Map toMap() => {'type': type, 'content': content, 'audio_path': audioPath};

  @override
  String toString() => jsonEncode(toMap());
}
