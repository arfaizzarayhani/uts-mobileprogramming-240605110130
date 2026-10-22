class WeatherForecast {
  const WeatherForecast({
    required this.temperatureC,
    required this.apparentTemperatureC,
    required this.humidityPercent,
    required this.windSpeedKmh,
    required this.weatherCode,
    required this.isDay,
    required this.observedAt,
  });

  final double temperatureC;
  final double apparentTemperatureC;
  final int humidityPercent;
  final double windSpeedKmh;
  final int weatherCode;
  final bool isDay;
  final String observedAt;

  String get condition {
    if (weatherCode == 0) return isDay ? 'Cerah' : 'Cerah berawan';
    if (weatherCode <= 3) return 'Berawan';
    if (weatherCode == 45 || weatherCode == 48) return 'Berkabut';
    if (weatherCode <= 57) return 'Gerimis';
    if (weatherCode <= 67 || weatherCode == 80 || weatherCode == 81) {
      return 'Hujan';
    }
    if (weatherCode <= 77) return 'Hujan salju';
    if (weatherCode <= 82) return 'Hujan lokal';
    if (weatherCode <= 86) return 'Hujan salju lokal';
    if (weatherCode >= 95) return 'Badai petir';
    return 'Kondisi tidak diketahui';
  }

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    final current = json['current'];
    if (current is! Map<String, dynamic>) {
      throw const FormatException('Respons cuaca tidak memiliki data current.');
    }

    num number(String key) {
      final value = current[key];
      if (value is! num) {
        throw FormatException('Nilai cuaca "$key" tidak valid.');
      }
      return value;
    }

    final observedAt = current['time'];
    if (observedAt is! String) {
      throw const FormatException('Waktu pengamatan cuaca tidak valid.');
    }

    return WeatherForecast(
      temperatureC: number('temperature_2m').toDouble(),
      apparentTemperatureC: number('apparent_temperature').toDouble(),
      humidityPercent: number('relative_humidity_2m').round(),
      windSpeedKmh: number('wind_speed_10m').toDouble(),
      weatherCode: number('weather_code').toInt(),
      isDay: number('is_day') == 1,
      observedAt: observedAt,
    );
  }
}
