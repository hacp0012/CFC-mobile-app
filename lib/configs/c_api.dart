import 'package:cfc_christ/database/app_preferences.dart';
import 'package:cfc_christ/database/c_database.dart';
import 'package:cfc_christ/env.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager_dio/flutter_cache_manager_dio.dart';

/// API request handler.
class CApi {
  /// Get auth token key.
  static String? authToken = CAppPreferences().loginToken;

  static final Dio _dio = Dio(BaseOptions(
    baseUrl: '${Env.API_URL}/api/v1',
    headers: {'Accept': 'application/json'},
    receiveDataWhenStatusError: true,
    validateStatus: (status) => kDebugMode,
  ));

  static CacheOptions cacheOptions = CacheOptions(
    // store: MemCacheStore(maxEntrySize: 7340032, maxSize: 1024000000),
    // store: DbCacheStore(databasePath: CDatabase().dbPath ?? '', databaseName: "dioDbCacheStore"),
    store: FileCacheStore(CDatabase().tempDir ?? ''),
    policy: CachePolicy.request,
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    allowPostMethod: true,
    hitCacheOnErrorExcept: [], // For offline behavior.
    // maxStale: const Duration(days: 7),
    // hitCacheOnErrorExcept: [401, 403],
  );

  /// Call Dio API instance.
  static Dio get request {
    /// Get auth token key.
    String? authToken = CAppPreferences().loginToken;

    // API Authentication.
    // _dio.interceptors.add(PrettyDioLogger(request: false, requestBody: false, enabled: kDebugMode));
    _dio.options.headers['Authorization'] = authToken != null ? 'Bearer $authToken' : null;

    return _dio;
  }

  /// Call Dio API instance without cache.
  static Dio get requestWithCache {
    /// Get auth token key.
    String? authToken = CAppPreferences().loginToken;

    // API Authentication.
    _dio.options.headers['Authorization'] = authToken != null ? 'Bearer $authToken' : null;
    _dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));

    return _dio;
  }

  /// Initialize Cache manager.
  static void initializeCacheStore() {
    _dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
    DioCacheManager.initialize(_dio);
  }

  // -------------------------------------------------------------------------------------------------------------------------
  /// Dowload file.
  static download() {}
}
