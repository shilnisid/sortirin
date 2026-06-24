import 'package:flutter/material.dart';
import 'package:sortirin/app/app.dart';
import 'package:sortirin/core/services/camera_service.dart';
import 'package:sortirin/core/services/local_storage_service.dart';
import 'package:sortirin/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize core services
  await LocalStorageService.init();
  await CameraService.init();
  await NotificationService.init();

  // TODO: Initialize Supabase when credentials are configured
  // await SupabaseClientService.init(
  //   supabaseUrl: dotenv.env['SUPABASE_URL']!,
  //   supabaseAnonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  // );

  runApp(const App());
}
