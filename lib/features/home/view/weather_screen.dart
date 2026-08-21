import 'dart:async';
import 'package:adcc/features/home/models/weather_models.dart';
import 'package:adcc/features/home/repositories/weather_repository.dart';
import 'package:adcc/features/home/view/weather_card.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class WeatherScreen extends StatefulWidget {
  final Future<WeatherSnapshot?>? weatherFuture;

  const WeatherScreen({super.key, this.weatherFuture});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  final WeatherRepository _weatherRepository = WeatherRepository();
  int _currentPage = 0;
  Timer? _timer;
  late final Future<WeatherSnapshot?> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture =
        widget.weatherFuture ?? _weatherRepository.fetchWeatherSnapshot();

    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (!mounted || !_pageController.hasClients) {
        return;
      }

      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);
    return FutureBuilder<WeatherSnapshot?>(
      future: _weatherFuture,
      builder: (context, snapshot) {
        final weather = snapshot.data;
        if (weather == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
          child: SizedBox(
            height: 135 * textScale.clamp(1.0, 1.5),
            child: PageView.builder(
            controller: _pageController,
            padEnds: false,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
                child: switch (index) {
                0 => WeatherCard(
                    city: weather.city,
                    time: weather.timeLabel,
                    temperature: weather.roundedTemperature,
                    highTemp: weather.roundedHighTemperature,
                    lowTemp: weather.roundedLowTemperature,
                    weatherIcon: weather.weatherIconAsset,
                  ),
                1 => Padding(
                    padding: const EdgeInsetsDirectional.only(start: 1, end: 1),
                    child: WeatherAlertCard(
                      city: weather.city,
                      time: weather.timeLabel,
                      alertTitle: weather.uvTitle(l10n),
                      alertMessage: weather.uvMessage(l10n),
                      alertType: WeatherAlertType.uv,
                    ),
                  ),
                _ => WeatherAlertCard(
                    city: weather.city,
                    time: weather.timeLabel,
                    alertTitle: weather.windTitle(l10n),
                    alertMessage: weather.windMessage(l10n),
                    alertType: WeatherAlertType.wind,
                  ),
              },
            );
          },
        ),
          ),
        );
      },
    );
  }
}
