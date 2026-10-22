import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../models/destination.dart';
import '../models/weather_forecast.dart';
import '../services/weather_service.dart';

const _forest = Color(0xFF24483C);
const _moss = Color(0xFF71816B);
const _surface = Color(0xFFFFFDF8);
const _clay = Color(0xFFC86F52);

class WeatherCard extends StatefulWidget {
  const WeatherCard({
    required this.destination,
    required this.weatherService,
    this.title,
    super.key,
  });

  final Destination destination;
  final WeatherService weatherService;
  final String? title;

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  late Future<WeatherForecast> _weather = _fetchWeather();

  Future<WeatherForecast> _fetchWeather() {
    return widget.weatherService.fetchCurrentWeather(
      latitude: widget.destination.latitude,
      longitude: widget.destination.longitude,
    );
  }

  void _retry() {
    setState(() {
      _weather = _fetchWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: FutureBuilder<WeatherForecast>(
        future: _weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _WeatherLoading(
              title: widget.title,
              region: widget.destination.region,
            );
          }
          if (snapshot.hasError) {
            return _WeatherError(
              title: widget.title,
              region: widget.destination.region,
              message: snapshot.error is WeatherServiceException
                  ? (snapshot.error! as WeatherServiceException).message
                  : 'Terjadi kesalahan saat memuat data cuaca.',
              onRetry: _retry,
            );
          }

          final forecast = snapshot.data;
          if (forecast == null) {
            return _WeatherError(
              title: widget.title,
              region: widget.destination.region,
              message: 'Layanan cuaca tidak mengirimkan data.',
              onRetry: _retry,
            );
          }

          return _WeatherContent(
            title: widget.title,
            region: widget.destination.region,
            forecast: forecast,
            onRefresh: _retry,
          );
        },
      ),
    );
  }
}

class _WeatherLoading extends StatelessWidget {
  const _WeatherLoading({required this.title, required this.region});

  final String? title;
  final String region;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2, color: _forest),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? 'Cuaca terkini di ${region.split(',').first}',
                style: const TextStyle(
                  color: _forest,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'Mengambil data dari Open-Meteo...',
                style: TextStyle(color: _moss, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeatherError extends StatelessWidget {
  const _WeatherError({
    required this.title,
    required this.region,
    required this.message,
    required this.onRetry,
  });

  final String? title;
  final String region;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.cloud_off_outlined, color: _moss, size: 25),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? 'Cuaca terkini di ${region.split(',').first}',
                style: const TextStyle(
                  color: _forest,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(message, style: const TextStyle(color: _moss, fontSize: 11)),
            ],
          ),
        ),
        IconButton(
          onPressed: onRetry,
          tooltip: 'Coba lagi',
          icon: const Icon(Icons.refresh_rounded, color: _forest),
        ),
      ],
    );
  }
}

class _WeatherContent extends StatelessWidget {
  const _WeatherContent({
    required this.title,
    required this.region,
    required this.forecast,
    required this.onRefresh,
  });

  final String? title;
  final String region;
  final WeatherForecast forecast;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.wb_cloudy_outlined, color: _clay, size: 18),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                title ?? 'Cuaca terkini di ${region.split(',').first}',
                style: const TextStyle(
                  color: _forest,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              onPressed: onRefresh,
              tooltip: 'Perbarui cuaca',
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.refresh_rounded, color: _moss, size: 19),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              _weatherIcon(forecast.weatherCode, forecast.isDay),
              color: _clay,
              size: 34,
            ),
            const SizedBox(width: 10),
            Text(
              '${forecast.temperatureC.round()}°',
              style: const TextStyle(
                color: _forest,
                fontSize: 32,
                fontWeight: FontWeight.w500,
                letterSpacing: -1.4,
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    forecast.condition,
                    style: const TextStyle(
                      color: _forest,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Terasa ${forecast.apparentTemperatureC.round()}°',
                    style: const TextStyle(color: _moss, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 11),
        Wrap(
          spacing: 14,
          runSpacing: 5,
          children: [
            _WeatherMetric(
              icon: Icons.water_drop_outlined,
              label: 'Kelembapan ${forecast.humidityPercent}%',
            ),
            _WeatherMetric(
              icon: Icons.air_rounded,
              label: 'Angin ${forecast.windSpeedKmh.round()} km/j',
            ),
          ],
        ),
        const SizedBox(height: 9),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 3,
          children: [
            const Text('Data:', style: TextStyle(color: _moss, fontSize: 9)),
            Link(
              uri: Uri.parse('https://open-meteo.com/'),
              target: LinkTarget.blank,
              builder: (context, followLink) => InkWell(
                onTap: followLink,
                child: const Text(
                  'Weather data by Open-Meteo.com',
                  style: TextStyle(
                    color: _forest,
                    fontSize: 9,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            Text(
              '· ${forecast.observedAt}',
              style: const TextStyle(color: _moss, fontSize: 9),
            ),
          ],
        ),
      ],
    );
  }
}

class _WeatherMetric extends StatelessWidget {
  const _WeatherMetric({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: _moss),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: _moss, fontSize: 10)),
      ],
    );
  }
}

IconData _weatherIcon(int code, bool isDay) {
  if (code == 0) {
    return isDay ? Icons.wb_sunny_outlined : Icons.nightlight_outlined;
  }
  if (code <= 3) return Icons.cloud_outlined;
  if (code <= 48) return Icons.foggy;
  if (code <= 67 || code >= 80 && code <= 82) return Icons.umbrella_outlined;
  if (code >= 95) return Icons.thunderstorm_outlined;
  return Icons.cloudy_snowing;
}
