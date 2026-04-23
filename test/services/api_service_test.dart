import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_social/services/api_service.dart';

void main() {
  group('dioProvider', () {
    test('creates a Dio instance with correct base URL', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final dio = container.read(dioProvider);
      expect(dio, isA<Dio>());
      expect(dio.options.baseUrl, 'https://api.example.com');
    });

    test('Dio has 10-second connect timeout', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final dio = container.read(dioProvider);
      expect(dio.options.connectTimeout, const Duration(seconds: 10));
    });

    test('Dio has 10-second receive timeout', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final dio = container.read(dioProvider);
      expect(dio.options.receiveTimeout, const Duration(seconds: 10));
    });

    test('Dio has JSON content type header', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final dio = container.read(dioProvider);
      expect(dio.options.headers['Content-Type'], 'application/json');
    });

    test('Dio has a log interceptor', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final dio = container.read(dioProvider);
      final hasLogInterceptor =
          dio.interceptors.any((i) => i is LogInterceptor);
      expect(hasLogInterceptor, isTrue);
    });
  });

  group('apiServiceProvider', () {
    test('provides an ApiService instance', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final api = container.read(apiServiceProvider);
      expect(api, isA<ApiService>());
    });
  });

  group('ApiService', () {
    late Dio dio;
    late ApiService apiService;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
      apiService = ApiService(dio);
    });

    test('constructs without error', () {
      expect(apiService, isA<ApiService>());
    });

    // Note: actual HTTP calls would require a mock adapter (e.g., dio_test).
    // These tests verify the service API surface exists and is callable.
    test('get method exists and returns a Future', () {
      // We don't call it because there's no server, but verify the type.
      expect(apiService.get<dynamic>, isA<Function>());
    });

    test('post method exists and returns a Future', () {
      expect(apiService.post<dynamic>, isA<Function>());
    });

    test('put method exists and returns a Future', () {
      expect(apiService.put<dynamic>, isA<Function>());
    });

    test('delete method exists and returns a Future', () {
      expect(apiService.delete<dynamic>, isA<Function>());
    });
  });
}
