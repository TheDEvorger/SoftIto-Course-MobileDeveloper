import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:haegaruuetn/core/data/local_realm_store.dart';
import 'package:haegaruuetn/core/models/habit.dart';
import 'package:haegaruuetn/core/services/ai/ai_error_handler.dart';
import 'package:haegaruuetn/core/services/ai/ai_persona.dart';
import 'package:haegaruuetn/core/services/ai/groq_ai_repository.dart';
import 'package:haegaruuetn/core/services/ai/pact_suggestion.dart';
import 'package:haegaruuetn/core/state/realm_controller.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Groq AI Engine Tests', () {
    late Habit sampleHabit;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      sampleHabit = Habit(
        id: 'h1',
        name: '20 dakika kitap oku',
        description: 'Bilgi seferi',
        difficulty: 1,
        createdAt: DateTime.now(),
        completedDates: [],
      );
    });

    test('1. Başarılı API yanıtı ve ahit önerisi ayrıştırma', () async {
      final mockClient = MockClient((request) async {
        expect(request.headers['X-App-Id'], 'haegaruuetn-v1');
        return http.Response(
          jsonEncode({
            'choices': [
              {
                'message': {
                  'role': 'assistant',
                  'content': 'Harika bir başlangıç yolcu!\n\n'
                      '```pact_suggestion\n'
                      '{\n'
                      '  "title": "7 Günlük Okuma Seferi",\n'
                      '  "description": "Günde 20 dakika kitap oku.",\n'
                      '  "target_habits": ["h1"],\n'
                      '  "target_days": 7,\n'
                      '  "total_days": 10,\n'
                      '  "rationale": "Zinciri başlatmak için harika bir tempo."\n'
                      '}\n'
                      '```',
                }
              }
            ]
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final repo = GroqAiRepository(
        workerUrl: 'https://proxy.test.workers.dev',
        httpClient: mockClient,
      );

      final reply = await repo.sendMessage(
        history: [],
        persona: AiPersona.sage,
        userPrompt: 'Kitap okuma alışkanlığımı nasıl geliştirebilirim?',
        availableHabits: [sampleHabit],
      );

      expect(reply.isOfflineFallback, isFalse);
      expect(reply.content.contains('Harika bir başlangıç'), isTrue);
      expect(reply.pactSuggestion, isNotNull);
      expect(reply.pactSuggestion!.title, '7 Günlük Okuma Seferi');
      expect(reply.pactSuggestion!.targetDays, 7);
      expect(reply.pactSuggestion!.habitIds, contains('h1'));
    });

    test('2. 401 yetkilendirme hatası AiErrorCode.unauthorized ile eşleşir',
        () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'error': {'message': 'Worker client secret mismatch.'}
          }),
          401,
        );
      });

      final repo = GroqAiRepository(
        workerUrl: 'https://proxy.test.workers.dev',
        httpClient: mockClient,
      );

      expect(
        () => repo.sendMessage(
          history: [],
          persona: AiPersona.commander,
          userPrompt: 'Merhaba',
          availableHabits: [sampleHabit],
        ),
        throwsA(isA<AiException>()
            .having((e) => e.code, 'code', AiErrorCode.unauthorized)),
      );
    });

    test('3. 429 kota aşımı AiErrorCode.rateLimitExceeded ile eşleşir',
        () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'error': {'message': 'Rate limit exceeded on free tier.'}
          }),
          429,
        );
      });

      final repo = GroqAiRepository(
        workerUrl: 'https://proxy.test.workers.dev',
        httpClient: mockClient,
      );

      expect(
        () => repo.sendMessage(
          history: [],
          persona: AiPersona.companion,
          userPrompt: 'Hedefimi büyütmek istiyorum',
          availableHabits: [sampleHabit],
        ),
        throwsA(isA<AiException>()
            .having((e) => e.code, 'code', AiErrorCode.rateLimitExceeded)),
      );
    });

    test('4. 500 sunucu hatası AiErrorCode.serverError ile eşleşir', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Internal server error', 500);
      });

      final repo = GroqAiRepository(
        workerUrl: 'https://proxy.test.workers.dev',
        httpClient: mockClient,
      );

      expect(
        () => repo.sendMessage(
          history: [],
          persona: AiPersona.sage,
          userPrompt: 'Bana yardım et',
          availableHabits: [sampleHabit],
        ),
        throwsA(isA<AiException>()
            .having((e) => e.code, 'code', AiErrorCode.serverError)),
      );
    });

    test('5. Ağ bağlantısı kesilmesi AiErrorCode.networkError ile eşleşir',
        () async {
      final mockClient = MockClient((request) async {
        throw http.ClientException('Connection refused');
      });

      final repo = GroqAiRepository(
        workerUrl: 'https://proxy.test.workers.dev',
        httpClient: mockClient,
      );

      expect(
        () => repo.sendMessage(
          history: [],
          persona: AiPersona.commander,
          userPrompt: 'Ağ yok',
          availableHabits: [sampleHabit],
        ),
        throwsA(isA<AiException>()
            .having((e) => e.code, 'code', AiErrorCode.networkError)),
      );
    });

    test('6. Zaman aşımı AiErrorCode.timeout ile eşleşir', () async {
      final mockClient = MockClient((request) async {
        throw TimeoutException('Request timed out');
      });

      final repo = GroqAiRepository(
        workerUrl: 'https://proxy.test.workers.dev',
        httpClient: mockClient,
      );

      expect(
        () => repo.sendMessage(
          history: [],
          persona: AiPersona.sage,
          userPrompt: 'Zaman aşımı',
          availableHabits: [sampleHabit],
        ),
        throwsA(isA<AiException>()
            .having((e) => e.code, 'code', AiErrorCode.timeout)),
      );
    });

    test('7. Geçersiz / boş model yanıtı AiErrorCode.invalidResponse verir',
        () async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({'choices': []}), 200);
      });

      final repo = GroqAiRepository(
        workerUrl: 'https://proxy.test.workers.dev',
        httpClient: mockClient,
      );

      expect(
        () => repo.sendMessage(
          history: [],
          persona: AiPersona.companion,
          userPrompt: 'Boş dönen istek',
          availableHabits: [sampleHabit],
        ),
        throwsA(isA<AiException>()
            .having((e) => e.code, 'code', AiErrorCode.invalidResponse)),
      );
    });

    test('8. Kullanıcı açıkça onaylamadıkça ahit oluşturulamaz', () async {
      final controller = RealmController(LocalRealmStore());
      await controller.initialize();
      final initialPactCount = controller.pacts.length;

      // Simulate model returning a structured proposal
      const rawOutput = '```pact_suggestion\n'
          '{\n'
          '  "title": "Onaysız Ahit",\n'
          '  "description": "Deneme",\n'
          '  "target_habits": ["h1"],\n'
          '  "target_days": 7\n'
          '}\n'
          '```';

      final suggestion =
          PactSuggestion.tryExtract(rawOutput, controller.activeHabits);
      expect(suggestion, isNotNull);

      // Verify that mere extraction did NOT add a pact to the controller!
      expect(controller.pacts.length, initialPactCount);

      // Only explicit method invocation from user interaction signs the pact
      controller.addPact(
        suggestion!.title,
        [controller.activeHabits.first.id],
        suggestion.targetDays,
      );

      expect(controller.pacts.length, initialPactCount + 1);
      expect(controller.pacts.last.title, 'Onaysız Ahit');
    });

    test('9. API anahtarı istemci kodunda ve dosyalarında bulunmamaktadır', () {
      final libDir = Directory('lib');
      final dartFiles = libDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'));

      for (final file in dartFiles) {
        final content = file.readAsStringSync();
        expect(
          content.contains('gsk_'),
          isFalse,
          reason: '${file.path} içinde Groq API anahtarı bulundu!',
        );
        expect(
          content.contains('GROQ_API_KEY ='),
          isFalse,
          reason: '${file.path} içinde hardcoded API anahtarı bulundu!',
        );
      }
    });

    test('10. Worker URL yapılandırılmadığında çevrimdışı fallback çalışır',
        () async {
      final repo = GroqAiRepository(workerUrl: null);
      final reply = await repo.sendMessage(
        history: [],
        persona: AiPersona.companion,
        userPrompt: 'Bugün çok yorgunum.',
        availableHabits: [sampleHabit],
      );

      expect(reply.isOfflineFallback, isTrue);
      expect(reply.content.isNotEmpty, isTrue);
      expect(reply.pactSuggestion, isNull);
    });
  });
}
