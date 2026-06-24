import 'package:hive_flutter/hive_flutter.dart';

/// Hive wrapper for local storage (offline queue, cache).
class LocalStorageService {
  static const String _boxName = 'sortirin_local';

  static late Box _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  // ── Generic CRUD ──

  static void put(String key, dynamic value) => _box.put(key, value);

  static dynamic get(String key) => _box.get(key);

  static void delete(String key) => _box.delete(key);

  static bool containsKey(String key) => _box.containsKey(key);

  static Future<void> clear() => _box.clear();

  // ── Convenience typed getters ──

  static String? getString(String key) => _box.get(key) as String?;

  static int? getInt(String key) => _box.get(key) as int?;

  static bool? getBool(String key) => _box.get(key) as bool?;

  static List<T>? getList<T>(String key) {
    final value = _box.get(key);
    if (value is List) return value.cast<T>();
    return null;
  }

  // ── Offline queue ──

  static Future<void> queueSubmission(Map<String, dynamic> submission) async {
    final queue = getList<Map<String, dynamic>>('offline_queue') ?? [];
    queue.add(submission);
    put('offline_queue', queue);
  }

  static List<Map<String, dynamic>>? getQueuedSubmissions() =>
      getList<Map<String, dynamic>>('offline_queue');

  static Future<void> clearQueue() async => delete('offline_queue');
}
