import 'package:flutter/material.dart';

import '../presentation/hourly_forecast_detail/hourly_forecast_detail.dart';
import '../presentation/location_management/location_management_screen.dart';
import '../presentation/location_permission_onboarding/location_permission_onboarding.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/weather_alerts_and_notifications/weather_alerts_and_notifications.dart';
import '../presentation/weather_dashboard/weather_dashboard.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String locationPermissionOnboarding =
      '/location-permission-onboarding';
  static const String locationManagement = '/location-management';
  static const String weatherDashboard = '/weather-dashboard';
  static const String sevenDayExtendedForecast = '/7-day-extended-forecast';
  static const String hourlyForecastDetail = '/hourly-forecast-detail';
  static const String weatherAlertsAndNotifications =
      '/weather-alerts-and-notifications';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    locationPermissionOnboarding: (context) =>
        const LocationPermissionOnboarding(),
    locationManagement: (context) => const LocationManagementScreen(),
    weatherDashboard: (context) => const WeatherDashboard(),
    hourlyForecastDetail: (context) => const HourlyForecastDetail(),
    weatherAlertsAndNotifications: (context) =>
        const WeatherAlertsAndNotifications(),
    // TODO: Add your other routes here
  };
}
