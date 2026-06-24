import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Dio interceptor that auto-refreshes the Supabase JWT when expired.
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Attempt token refresh via Supabase
      try {
        await Supabase.instance.client.auth.refreshSession();
        final session = Supabase.instance.client.auth.currentSession;
        if (session != null && err.requestOptions.headers.containsKey('Authorization')) {
          err.requestOptions.headers['Authorization'] =
              'Bearer ${session.accessToken}';
          // Retry the request
          final response = await Dio().fetch(err.requestOptions);
          return handler.resolve(response);
        }
      } catch (_) {
        // Refresh failed — pass through
      }
    }
    handler.next(err);
  }
}
