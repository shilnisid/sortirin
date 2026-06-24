import 'package:get/get.dart';
import 'package:sortirin/core/services/local_storage_service.dart';

/// Global bindings initialized before any route.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LocalStorageService(), permanent: true);
  }
}
