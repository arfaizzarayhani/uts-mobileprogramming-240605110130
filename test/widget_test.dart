import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:utsprak/main.dart';
import 'package:utsprak/models/weather_forecast.dart';
import 'package:utsprak/services/weather_service.dart';

void main() {
  testWidgets('keeps home content visible with a compact bottom navigation', (
    tester,
  ) async {
    await tester.pumpWidget(SelaApp(weatherService: _FakeWeatherService()));
    await tester.pump();

    final navigationBounds = tester.getRect(find.byType(NavigationBar));
    expect(navigationBounds.height, 68);
    expect(
      find.text('Pergi sebentar,\npulang membawa cerita.'),
      findsOneWidget,
    );
  });

  testWidgets('explores a place and saves it to the collection', (
    tester,
  ) async {
    await tester.pumpWidget(SelaApp(weatherService: _FakeWeatherService()));
    await tester.pump();

    expect(
      find.text('Pergi sebentar,\npulang membawa cerita.'),
      findsOneWidget,
    );
    expect(find.text('Satu tempat untuk disinggahi'), findsOneWidget);

    await tester.tap(find.text('Lihat semua').first);
    await tester.pumpAndSettle();
    expect(find.text('Jelajahi'), findsOneWidget);
    expect(find.text('6 TEMPAT'), findsOneWidget);

    await tester.tap(find.text('Bahari').first);
    await tester.pumpAndSettle();
    expect(find.text('1 TEMPAT'), findsOneWidget);
    expect(find.text('Kepulauan Karimunjawa'), findsOneWidget);
    expect(find.text('Desa Penglipuran'), findsNothing);

    await tester.tap(find.text('Kepulauan Karimunjawa'));
    await tester.pumpAndSettle();
    expect(find.text('Tentang tempat ini'), findsOneWidget);
    expect(find.text('Jepara, Jawa Tengah'), findsOneWidget);

    await tester.ensureVisible(find.text('Simpan untuk nanti'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan untuk nanti'));
    await tester.pumpAndSettle();
    expect(find.text('Hapus dari simpanan'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Disimpan'));
    await tester.pumpAndSettle();
    expect(find.text('Tempat tersimpan'), findsOneWidget);
    expect(find.text('Kepulauan Karimunjawa'), findsOneWidget);
  });

  testWidgets('searches destinations by region', (tester) async {
    await tester.pumpWidget(SelaApp(weatherService: _FakeWeatherService()));
    await tester.pump();

    await tester.enterText(find.byType(TextField).first, 'Semarang');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Jelajah'));
    await tester.pumpAndSettle();
    expect(find.text('Kota Lama Semarang'), findsOneWidget);
    expect(find.text('Kawah Ijen'), findsNothing);
  });

  testWidgets('shows live weather data and retries after an API error', (
    tester,
  ) async {
    final weatherService = _FakeWeatherService(failuresRemaining: 1);
    await tester.pumpWidget(SelaApp(weatherService: weatherService));
    await tester.pump();

    await tester.drag(
      find.byType(CustomScrollView).first,
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Cuaca terkini di Bangli'));
    await tester.pumpAndSettle();
    expect(find.text('Layanan cuaca tidak tersedia.'), findsOneWidget);

    await tester.tap(find.byTooltip('Coba lagi'));
    await tester.pumpAndSettle();

    expect(find.text('27°'), findsOneWidget);
    expect(find.text('Cerah'), findsOneWidget);
    expect(find.text('Kelembapan 64%'), findsOneWidget);
    expect(weatherService.calls, 2);
    expect(weatherService.lastLatitude, -8.4333);
    expect(weatherService.lastLongitude, 115.35);
  });

  test('parses the Open-Meteo current weather response', () {
    final weather = WeatherForecast.fromJson({
      'current': {
        'time': '2026-10-22T09:45',
        'temperature_2m': 26.6,
        'relative_humidity_2m': 67,
        'apparent_temperature': 30.5,
        'is_day': 1,
        'weather_code': 0,
        'wind_speed_10m': 10.7,
      },
    });

    expect(weather.temperatureC, 26.6);
    expect(weather.humidityPercent, 67);
    expect(weather.condition, 'Cerah');
    expect(weather.observedAt, '2026-10-22T09:45');
  });
}

class _FakeWeatherService implements WeatherService {
  _FakeWeatherService({this.failuresRemaining = 0});

  int failuresRemaining;
  int calls = 0;
  double? lastLatitude;
  double? lastLongitude;

  @override
  Future<WeatherForecast> fetchCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    calls++;
    lastLatitude = latitude;
    lastLongitude = longitude;
    if (failuresRemaining > 0) {
      failuresRemaining--;
      throw const WeatherServiceException('Layanan cuaca tidak tersedia.');
    }

    return const WeatherForecast(
      temperatureC: 27,
      apparentTemperatureC: 29,
      humidityPercent: 64,
      windSpeedKmh: 8,
      weatherCode: 0,
      isDay: true,
      observedAt: '2026-10-22T09:45',
    );
  }
}
