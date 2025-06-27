import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/hero_weather_section_widget.dart';
import './widgets/hourly_forecast_widget.dart';
import './widgets/seven_day_forecast_widget.dart';
import './widgets/weather_alert_banner_widget.dart';
import './widgets/weather_details_card_widget.dart';

class WeatherDashboard extends StatefulWidget {
  const WeatherDashboard({super.key});

  @override
  State<WeatherDashboard> createState() => _WeatherDashboardState();
}

class _WeatherDashboardState extends State<WeatherDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;
  bool _isCelsius = true;
  int _selectedTabIndex = 0;
  final LocationService _locationService = LocationService();

  // Mock weather data
  final Map<String, dynamic> currentWeather = {
    "temperature": 24,
    "feelsLike": 27,
    "condition": "Partly Cloudy",
    "location": "New York, NY",
    "icon": "partly_cloudy_day",
    "humidity": 65,
    "uvIndex": 6,
    "windSpeed": 12,
    "windDirection": "NE",
    "visibility": 10,
    "pressure": 1013,
    "sunrise": "06:42",
    "sunset": "19:28",
    "lastUpdated": "2024-01-15 14:30"
  };

  final List<Map<String, dynamic>> hourlyForecast = [
    {
      "time": "15:00",
      "temperature": 25,
      "condition": "sunny",
      "icon": "wb_sunny"
    },
    {
      "time": "16:00",
      "temperature": 26,
      "condition": "sunny",
      "icon": "wb_sunny"
    },
    {
      "time": "17:00",
      "temperature": 24,
      "condition": "partly_cloudy",
      "icon": "wb_cloudy"
    },
    {
      "time": "18:00",
      "temperature": 22,
      "condition": "cloudy",
      "icon": "cloud"
    },
    {
      "time": "19:00",
      "temperature": 20,
      "condition": "cloudy",
      "icon": "cloud"
    },
    {
      "time": "20:00",
      "temperature": 18,
      "condition": "partly_cloudy",
      "icon": "wb_cloudy"
    }
  ];

  final List<Map<String, dynamic>> weeklyForecast = [
    {
      "day": "Today",
      "date": "Jan 15",
      "high": 26,
      "low": 18,
      "condition": "Partly Cloudy",
      "icon": "wb_cloudy",
      "precipitation": 20
    },
    {
      "day": "Tomorrow",
      "date": "Jan 16",
      "high": 28,
      "low": 20,
      "condition": "Sunny",
      "icon": "wb_sunny",
      "precipitation": 5
    },
    {
      "day": "Wednesday",
      "date": "Jan 17",
      "high": 23,
      "low": 16,
      "condition": "Rainy",
      "icon": "grain",
      "precipitation": 80
    },
    {
      "day": "Thursday",
      "date": "Jan 18",
      "high": 25,
      "low": 17,
      "condition": "Cloudy",
      "icon": "cloud",
      "precipitation": 30
    },
    {
      "day": "Friday",
      "date": "Jan 19",
      "high": 27,
      "low": 19,
      "condition": "Sunny",
      "icon": "wb_sunny",
      "precipitation": 10
    },
    {
      "day": "Saturday",
      "date": "Jan 20",
      "high": 29,
      "low": 21,
      "condition": "Partly Cloudy",
      "icon": "wb_cloudy",
      "precipitation": 15
    },
    {
      "day": "Sunday",
      "date": "Jan 21",
      "high": 24,
      "low": 18,
      "condition": "Thunderstorm",
      "icon": "flash_on",
      "precipitation": 90
    }
  ];

  final List<Map<String, dynamic>> weatherAlerts = [
    {
      "title": "Heat Advisory",
      "description": "Excessive heat warning in effect until 8 PM today",
      "severity": "moderate",
      "isActive": true
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    _initializeLocationService();
  }

  Future<void> _initializeLocationService() async {
    await _locationService.initialize();
    // Update weather data based on selected location if available
    final weatherLocation = _locationService.getWeatherLocation();
    if (weatherLocation != null) {
      _updateWeatherForLocation(weatherLocation);
    }
  }

  void _updateWeatherForLocation(LocationModel location) {
    // Update currentWeather with location info
    setState(() {
      currentWeather['location'] = location.displayName;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Try to refresh location data if current location is being used
    final weatherLocation = _locationService.getWeatherLocation();
    if (weatherLocation?.isCurrentLocation == true) {
      await _locationService.getCurrentLocationWithAddress();
      final updatedLocation = _locationService.currentLocation;
      if (updatedLocation != null) {
        _updateWeatherForLocation(updatedLocation);
      }
    }

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _toggleTemperatureUnit() {
    setState(() {
      _isCelsius = !_isCelsius;
    });
  }

  void _navigateToLocationSelector() {
    Navigator.pushNamed(context, '/location-management').then((_) {
      // Refresh when returning from location management
      final weatherLocation = _locationService.getWeatherLocation();
      if (weatherLocation != null) {
        _updateWeatherForLocation(weatherLocation);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _locationService,
      builder: (context, child) {
        // Update weather location display when location changes
        final weatherLocation = _locationService.getWeatherLocation();
        if (weatherLocation != null) {
          currentWeather['location'] = weatherLocation.displayName;
        }

        return Scaffold(
          backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                _buildTabBar(),
                Expanded(
                  child: _selectedTabIndex == 0
                      ? _buildDashboardContent()
                      : _buildOtherTabContent(),
                ),
              ],
            ),
          ),
          floatingActionButton: _selectedTabIndex == 0
              ? FloatingActionButton(
                  onPressed: _navigateToLocationSelector,
                  backgroundColor: AppTheme.lightTheme.primaryColor,
                  child: CustomIconWidget(
                    iconName: 'location_on',
                    color: Colors.white,
                    size: 24,
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Dashboard'),
          Tab(text: 'Locations'),
          Tab(text: 'Maps'),
          Tab(text: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.lightTheme.primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weather Alert Banner
            if ((weatherAlerts.first["isActive"] as bool))
              WeatherAlertBannerWidget(
                alert: weatherAlerts.first,
                onTap: () {
                  Navigator.pushNamed(
                      context, '/weather-alerts-and-notifications');
                },
              ),

            // Hero Weather Section
            GestureDetector(
              onLongPress: _toggleTemperatureUnit,
              child: HeroWeatherSectionWidget(
                weather: currentWeather,
                isCelsius: _isCelsius,
                isRefreshing: _isRefreshing,
              ),
            ),

            SizedBox(height: 3.h),

            // Hourly Forecast
            HourlyForecastWidget(
              hourlyData: hourlyForecast,
              isCelsius: _isCelsius,
              onHourTap: (index) {
                Navigator.pushNamed(context, '/hourly-forecast-detail');
              },
            ),

            SizedBox(height: 3.h),

            // Weather Details Card
            WeatherDetailsCardWidget(
              weather: currentWeather,
            ),

            SizedBox(height: 3.h),

            // Seven Day Forecast
            SevenDayForecastWidget(
              weeklyData: weeklyForecast,
              isCelsius: _isCelsius,
              onDayTap: (index) {
                Navigator.pushNamed(context, '/7-day-extended-forecast');
              },
            ),

            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherTabContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'construction',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'Coming Soon',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'This feature is under development',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
