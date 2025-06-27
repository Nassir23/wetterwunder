import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/day_forecast_card_widget.dart';
import './widgets/expanded_day_detail_widget.dart';
import './widgets/weather_trends_chart_widget.dart';

class SevenDayExtendedForecast extends StatefulWidget {
  const SevenDayExtendedForecast({super.key});

  @override
  State<SevenDayExtendedForecast> createState() =>
      _SevenDayExtendedForecastState();
}

class _SevenDayExtendedForecastState extends State<SevenDayExtendedForecast>
    with TickerProviderStateMixin {
  int? expandedCardIndex;
  bool isRefreshing = false;
  String selectedMetric = 'temperature';
  Set<int> selectedDays = {};
  bool isMultiSelectMode = false;

  final List<Map<String, dynamic>> weeklyForecast = [
    {
      "id": 1,
      "date": "2024-01-15",
      "dayName": "Today",
      "highTemp": 24,
      "lowTemp": 18,
      "condition": "Partly Cloudy",
      "conditionIcon": "partly_cloudy_day",
      "precipitationProbability": 20,
      "sunrise": "06:45",
      "sunset": "18:30",
      "morningTemp": 19,
      "afternoonTemp": 24,
      "eveningTemp": 21,
      "morningCondition": "Clear",
      "afternoonCondition": "Partly Cloudy",
      "eveningCondition": "Cloudy",
      "windSpeed": 12,
      "humidity": 65,
      "precipitationTiming": "Light showers possible after 3 PM",
      "confidence": 85,
      "hasAlert": false,
    },
    {
      "id": 2,
      "date": "2024-01-16",
      "dayName": "Tomorrow",
      "highTemp": 22,
      "lowTemp": 16,
      "condition": "Rainy",
      "conditionIcon": "rainy",
      "precipitationProbability": 80,
      "sunrise": "06:46",
      "sunset": "18:29",
      "morningTemp": 17,
      "afternoonTemp": 22,
      "eveningTemp": 19,
      "morningCondition": "Cloudy",
      "afternoonCondition": "Heavy Rain",
      "eveningCondition": "Light Rain",
      "windSpeed": 18,
      "humidity": 85,
      "precipitationTiming": "Rain expected from 10 AM to 6 PM",
      "confidence": 92,
      "hasAlert": true,
    },
    {
      "id": 3,
      "date": "2024-01-17",
      "dayName": "Wednesday",
      "highTemp": 26,
      "lowTemp": 20,
      "condition": "Sunny",
      "conditionIcon": "sunny",
      "precipitationProbability": 5,
      "sunrise": "06:47",
      "sunset": "18:28",
      "morningTemp": 21,
      "afternoonTemp": 26,
      "eveningTemp": 23,
      "morningCondition": "Clear",
      "afternoonCondition": "Sunny",
      "eveningCondition": "Clear",
      "windSpeed": 8,
      "humidity": 45,
      "precipitationTiming": "No precipitation expected",
      "confidence": 88,
      "hasAlert": false,
    },
    {
      "id": 4,
      "date": "2024-01-18",
      "dayName": "Thursday",
      "highTemp": 28,
      "lowTemp": 22,
      "condition": "Partly Cloudy",
      "conditionIcon": "partly_cloudy_day",
      "precipitationProbability": 15,
      "sunrise": "06:48",
      "sunset": "18:27",
      "morningTemp": 23,
      "afternoonTemp": 28,
      "eveningTemp": 25,
      "morningCondition": "Clear",
      "afternoonCondition": "Partly Cloudy",
      "eveningCondition": "Partly Cloudy",
      "windSpeed": 10,
      "humidity": 55,
      "precipitationTiming": "Isolated showers possible evening",
      "confidence": 78,
      "hasAlert": false,
    },
    {
      "id": 5,
      "date": "2024-01-19",
      "dayName": "Friday",
      "highTemp": 25,
      "lowTemp": 19,
      "condition": "Thunderstorms",
      "conditionIcon": "thunderstorm",
      "precipitationProbability": 90,
      "sunrise": "06:49",
      "sunset": "18:26",
      "morningTemp": 20,
      "afternoonTemp": 25,
      "eveningTemp": 22,
      "morningCondition": "Cloudy",
      "afternoonCondition": "Thunderstorms",
      "eveningCondition": "Light Rain",
      "windSpeed": 22,
      "humidity": 90,
      "precipitationTiming": "Storms likely 2-8 PM",
      "confidence": 95,
      "hasAlert": true,
    },
    {
      "id": 6,
      "date": "2024-01-20",
      "dayName": "Saturday",
      "highTemp": 23,
      "lowTemp": 17,
      "condition": "Cloudy",
      "conditionIcon": "cloudy",
      "precipitationProbability": 40,
      "sunrise": "06:50",
      "sunset": "18:25",
      "morningTemp": 18,
      "afternoonTemp": 23,
      "eveningTemp": 20,
      "morningCondition": "Cloudy",
      "afternoonCondition": "Overcast",
      "eveningCondition": "Partly Cloudy",
      "windSpeed": 14,
      "humidity": 70,
      "precipitationTiming": "Light drizzle possible morning",
      "confidence": 72,
      "hasAlert": false,
    },
    {
      "id": 7,
      "date": "2024-01-21",
      "dayName": "Sunday",
      "highTemp": 27,
      "lowTemp": 21,
      "condition": "Sunny",
      "conditionIcon": "sunny",
      "precipitationProbability": 10,
      "sunrise": "06:51",
      "sunset": "18:24",
      "morningTemp": 22,
      "afternoonTemp": 27,
      "eveningTemp": 24,
      "morningCondition": "Clear",
      "afternoonCondition": "Sunny",
      "eveningCondition": "Clear",
      "windSpeed": 6,
      "humidity": 50,
      "precipitationTiming": "No precipitation expected",
      "confidence": 85,
      "hasAlert": false,
    },
  ];

  final List<Map<String, dynamic>> trendsData = [
    {
      "day": "Mon",
      "temperature": 24,
      "precipitation": 20,
      "wind": 12,
      "humidity": 65
    },
    {
      "day": "Tue",
      "temperature": 22,
      "precipitation": 80,
      "wind": 18,
      "humidity": 85
    },
    {
      "day": "Wed",
      "temperature": 26,
      "precipitation": 5,
      "wind": 8,
      "humidity": 45
    },
    {
      "day": "Thu",
      "temperature": 28,
      "precipitation": 15,
      "wind": 10,
      "humidity": 55
    },
    {
      "day": "Fri",
      "temperature": 25,
      "precipitation": 90,
      "wind": 22,
      "humidity": 90
    },
    {
      "day": "Sat",
      "temperature": 23,
      "precipitation": 40,
      "wind": 14,
      "humidity": 70
    },
    {
      "day": "Sun",
      "temperature": 27,
      "precipitation": 10,
      "wind": 6,
      "humidity": 50
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildLocationHeader(),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final forecast = weeklyForecast[index];
                  return _buildDayForecastCard(forecast, index);
                },
                childCount: weeklyForecast.length,
              ),
            ),
            SliverToBoxAdapter(
              child: _buildWeatherTrendsSection(),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 4.h),
            ),
          ],
        ),
      ),
      floatingActionButton: isMultiSelectMode ? _buildMultiSelectFAB() : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: Theme.of(context).colorScheme.onSurface,
          size: 24,
        ),
      ),
      title: Text(
        '7-Day Forecast',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      actions: [
        IconButton(
          onPressed: _showCalendarIntegration,
          icon: CustomIconWidget(
            iconName: 'calendar_today',
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
        if (isMultiSelectMode)
          IconButton(
            onPressed: _exitMultiSelectMode,
            icon: CustomIconWidget(
              iconName: 'close',
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
          ),
      ],
    );
  }

  Widget _buildLocationHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'location_on',
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Text(
            'New York, NY',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const Spacer(),
          if (isRefreshing)
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDayForecastCard(Map<String, dynamic> forecast, int index) {
    final isExpanded = expandedCardIndex == index;
    final isSelected = selectedDays.contains(index);

    return GestureDetector(
      onTap: () => _toggleCardExpansion(index),
      onLongPress: () => _toggleDaySelection(index),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            DayForecastCardWidget(
              forecast: forecast,
              isExpanded: isExpanded,
              isSelected: isSelected,
              onSwipeRight: () => _showQuickActions(forecast),
            ),
            if (isExpanded)
              ExpandedDayDetailWidget(
                forecast: forecast,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherTrendsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weather Trends',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 2.h),
          _buildMetricSelector(),
          SizedBox(height: 2.h),
          WeatherTrendsChartWidget(
            data: trendsData,
            selectedMetric: selectedMetric,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricSelector() {
    final metrics = [
      {'key': 'temperature', 'label': 'Temperature', 'icon': 'thermostat'},
      {'key': 'precipitation', 'label': 'Precipitation', 'icon': 'water_drop'},
      {'key': 'wind', 'label': 'Wind', 'icon': 'air'},
      {'key': 'humidity', 'label': 'Humidity', 'icon': 'opacity'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: metrics.map((metric) {
          final isSelected = selectedMetric == metric['key'];
          return GestureDetector(
            onTap: () =>
                setState(() => selectedMetric = metric['key'] as String),
            child: Container(
              margin: EdgeInsets.only(right: 3.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: metric['icon'] as String,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    metric['label'] as String,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMultiSelectFAB() {
    return FloatingActionButton.extended(
      onPressed: _showMultiDayComparison,
      icon: CustomIconWidget(
        iconName: 'compare',
        color: Theme.of(context).colorScheme.onPrimary,
        size: 20,
      ),
      label: Text(
        'Compare ${selectedDays.length} days',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  void _toggleCardExpansion(int index) {
    setState(() {
      expandedCardIndex = expandedCardIndex == index ? null : index;
    });
  }

  void _toggleDaySelection(int index) {
    setState(() {
      if (selectedDays.contains(index)) {
        selectedDays.remove(index);
        if (selectedDays.isEmpty) {
          isMultiSelectMode = false;
        }
      } else {
        selectedDays.add(index);
        isMultiSelectMode = true;
      }
    });
  }

  void _exitMultiSelectMode() {
    setState(() {
      selectedDays.clear();
      isMultiSelectMode = false;
    });
  }

  Future<void> _handleRefresh() async {
    setState(() => isRefreshing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => isRefreshing = false);
  }

  void _showCalendarIntegration() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Calendar Integration',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'event',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('Add to Calendar'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'notifications',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('Set Weather Reminders'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickActions(Map<String, dynamic> forecast) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Quick Actions - ${forecast['dayName']}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'event',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('Add to Calendar'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'alarm',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('Set Reminder'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('Share Day'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showMultiDayComparison() {
    Navigator.pop(context);
    // Implementation for multi-day comparison would go here
  }
}
