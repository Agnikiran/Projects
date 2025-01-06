import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  late final FlutterSecureStorage storage;
  final AndroidOptions aOptions =
      const AndroidOptions(encryptedSharedPreferences: true);
  final IOSOptions iOptions = const IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  );

  SecureStorage() {
    storage = FlutterSecureStorage(aOptions: aOptions, iOptions: iOptions);
  }

  Future<void> write({required String key, required String? value}) async {
    await storage.write(
        key: key, value: value, aOptions: aOptions, iOptions: iOptions);
  }

  Future<String?> read({required String key}) async {
    return await storage.read(key: key, aOptions: aOptions, iOptions: iOptions);
  }

  Future<bool> containsKey({required String key}) async {
    return await storage.containsKey(
        key: key, aOptions: aOptions, iOptions: iOptions);
  }

  Future<void> delete({required String key}) async {
    await storage.delete(key: key, aOptions: aOptions, iOptions: iOptions);
  }

  void writeAll(Map<String, String?> data) {
    data.forEach((key, value) async {
      await storage.write(
          key: key, value: value, aOptions: aOptions, iOptions: iOptions);
    });
  }

  Future<Map<String, String>> readAll() async {
    return await storage.readAll(aOptions: aOptions, iOptions: iOptions);
  }

  Future<void> deleteAll() async {
    return await storage.deleteAll(aOptions: aOptions, iOptions: iOptions);
  }
}
