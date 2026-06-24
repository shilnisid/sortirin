import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sortirin/app/app.dart';
import 'package:sortirin/core/config/env_config.dart';
import 'package:sortirin/core/network/supabase_client.dart';
import 'package:sortirin/core/services/camera_service.dart';
import 'package:sortirin/core/services/local_storage_service.dart';
import 'package:sortirin/core/services/notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize Firebase (for FCM push notifications)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize core services
  await LocalStorageService.init();
  await CameraService.init();
  await NotificationService.init();

  // Initialize Supabase
  await SupabaseClientService.init(
    supabaseUrl: EnvConfig.supabaseUrl,
    supabasePublishableKey: EnvConfig.supabasePublishableKey,
  );

  runApp(const App());
}
