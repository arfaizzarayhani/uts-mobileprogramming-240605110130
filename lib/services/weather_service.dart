import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather_forecast.dart';

abstract interface class WeatherService {
  Future<WeatherForecast> fetchCurrentWeather({
    required double latitude,
    required double longitude,
  });
}

class OpenMeteoWeatherService implements WeatherService {
  const OpenMeteoWeatherService();

  static final _endpoint = Uri.https('api.open-meteo.com', '/v1/forecast', {
    'current': 'temperature_2m,relative_humidity_2m,apparent_temperature,is_day,weather_code,wind_speed_10m',
    'timezone': 'auto',
  });

  @override
  Future<WeatherForecast> fetchCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    final uri = _endpoint.replace(
      queryParameters: {
        ..._endpoint.queryParameters,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      },
    );
    late final http.Response response;
    try {
      response = await http.get(uri).timeout(const Duration(seconds: 12));
    } on TimeoutException {
      throw const WeatherServiceException(
        'Permintaan cuaca melewati batas waktu. Periksa koneksi lalu coba lagi.',
      );
    }

    if (response.statusCode != 200) {
      throw WeatherServiceException(
        'Layanan cuaca tidak tersedia (HTTP ${response.statusCode}).',
      );
    }

    final Object? decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw const WeatherServiceException(
        'Layanan cuaca mengirim data yang tidak dapat dibaca.',
      );
    }
    if (decoded is! Map<String, dynamic>) {
      throw const WeatherServiceException('Format respons cuaca tidak sesuai.');
    }

    try {
      return WeatherForecast.fromJson(decoded);
    } on FormatException catch (error) {
      throw WeatherServiceException(error.message);
    }
  }
}

class WeatherServiceException implements Exception {
  const WeatherServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}
