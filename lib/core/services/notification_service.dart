/// FCM push notification service — lightweight stub.
/// Full implementation requires firebase_options.dart from FlutterFire CLI.
class NotificationService {
  NotificationService._();

  static Future<void> init() async {
    // TODO: Initialize Firebase, request permissions, get FCM token
    // 1. Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    // 2. FirebaseMessaging.instance.requestPermission();
    // 3. FirebaseMessaging.instance.getToken();
    // 4. Save token to Supabase profiles table
  }

  static Future<String?> getToken() async {
    // return await FirebaseMessaging.instance.getToken();
    return null;
  }

  static Future<void> subscribeToTopic(String topic) async {
    // await FirebaseMessaging.instance.subscribeToTopic(topic);
  }
}
