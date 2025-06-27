import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/expanded_details_widget.dart';
import './widgets/hourly_card_widget.dart';
import './widgets/timeline_scrubber_widget.dart';

class HourlyForecastDetail extends StatefulWidget {
  const HourlyForecastDetail({super.key});

  @override
  State<HourlyForecastDetail> createState() => _HourlyForecastDetailState();
}

class _HourlyForecastDetailState extends State<HourlyForecastDetail>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final PageController _timelineController = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  int selectedHourIndex = 0;
  int? expandedCardIndex;
  bool isRefreshing = false;
  bool showPrecipitationRadar = false;
  Set<int> selectedCards = {};
  bool isMultiSelectMode = false;

  // Mock data for 48-hour forecast
  final List<Map<String, dynamic>> hourlyForecast = [
    {
      "time": "Now",
      "hour": "12 PM",
      "temperature": 24,
      "condition": "Sunny",
      "conditionIcon": "wb_sunny",
      "precipitationProbability": 0,
      "windSpeed": 12,
      "windDirection": "NE",
      "humidity": 45,
      "uvIndex": 8,
      "visibility": 10,
      "pressure": 1013,
      "feelsLike": 26,
      "isCurrentHour": true,
    },
    {
      "time": "1 PM",
      "hour": "1 PM",
      "temperature": 26,
      "condition": "Partly Cloudy",
      "conditionIcon": "partly_cloudy_day",
      "precipitationProbability": 10,
      "windSpeed": 15,
      "windDirection": "E",
      "humidity": 42,
      "uvIndex": 9,
      "visibility": 12,
      "pressure": 1012,
      "feelsLike": 28,
      "isCurrentHour": false,
    },
    {
      "time": "2 PM",
      "hour": "2 PM",
      "temperature": 28,
      "condition": "Partly Cloudy",
      "conditionIcon": "partly_cloudy_day",
      "precipitationProbability": 15,
      "windSpeed": 18,
      "windDirection": "SE",
      "humidity": 38,
      "uvIndex": 10,
      "visibility": 15,
      "pressure": 1011,
      "feelsLike": 31,
      "isCurrentHour": false,
    },
    {
      "time": "3 PM",
      "hour": "3 PM",
      "temperature": 29,
      "condition": "Cloudy",
      "conditionIcon": "cloud",
      "precipitationProbability": 25,
      "windSpeed": 20,
      "windDirection": "S",
      "humidity": 35,
      "uvIndex": 8,
      "visibility": 12,
      "pressure": 1010,
      "feelsLike": 32,
      "isCurrentHour": false,
    },
    {
      "time": "4 PM",
      "hour": "4 PM",
      "temperature": 27,
      "condition": "Light Rain",
      "conditionIcon": "grain",
      "precipitationProbability": 60,
      "windSpeed": 22,
      "windDirection": "SW",
      "humidity": 65,
      "uvIndex": 5,
      "visibility": 8,
      "pressure": 1008,
      "feelsLike": 30,
      "isCurrentHour": false,
    },
    {
      "time": "5 PM",
      "hour": "5 PM",
      "temperature": 25,
      "condition": "Rain",
      "conditionIcon": "grain",
      "precipitationProbability": 80,
      "windSpeed": 25,
      "windDirection": "W",
      "humidity": 75,
      "uvIndex": 3,
      "visibility": 6,
      "pressure": 1007,
      "feelsLike": 28,
      "isCurrentHour": false,
    },
    {
      "time": "6 PM",
      "hour": "6 PM",
      "temperature": 23,
      "condition": "Heavy Rain",
      "conditionIcon": "grain",
      "precipitationProbability": 95,
      "windSpeed": 28,
      "windDirection": "NW",
      "humidity": 85,
      "uvIndex": 1,
      "visibility": 4,
      "pressure": 1006,
      "feelsLike": 26,
      "isCurrentHour": false,
    },
    {
      "time": "7 PM",
      "hour": "7 PM",
      "temperature": 22,
      "condition": "Thunderstorm",
      "conditionIcon": "flash_on",
      "precipitationProbability": 90,
      "windSpeed": 32,
      "windDirection": "N",
      "humidity": 88,
      "uvIndex": 0,
      "visibility": 3,
      "pressure": 1005,
      "feelsLike": 25,
      "isCurrentHour": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timelineController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isRefreshing = false;
    });

    HapticFeedback.lightImpact();
  }

  void _toggleMultiSelect() {
    setState(() {
      isMultiSelectMode = !isMultiSelectMode;
      if (!isMultiSelectMode) {
        selectedCards.clear();
      }
    });
  }

  void _selectCard(int index) {
    if (isMultiSelectMode) {
      setState(() {
        if (selectedCards.contains(index)) {
          selectedCards.remove(index);
        } else {
          selectedCards.add(index);
        }
      });
      HapticFeedback.selectionClick();
    }
  }

  void _expandCard(int index) {
    setState(() {
      expandedCardIndex = expandedCardIndex == index ? null : index;
    });
  }

  void _onTimelineChanged(int index) {
    setState(() {
      selectedHourIndex = index;
    });

    // Scroll to the selected hour
    if (_scrollController.hasClients) {
      final double offset = index * 120.0; // Approximate card height
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildStickyHeader(),
            Expanded(
              child: _buildMainContent(),
            ),
            _buildTimelineScrubber(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: 'arrow_back',
                color: Theme.of(context).colorScheme.onSurface,
                size: 6.w,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New York, NY',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  '48-Hour Forecast',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                showPrecipitationRadar = !showPrecipitationRadar;
              });
            },
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: showPrecipitationRadar
                    ? Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1)
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: 'radar',
                color: showPrecipitationRadar
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
                size: 6.w,
              ),
            ),
          ),
          SizedBox(width: 2.w),
          GestureDetector(
            onTap: () {
              // Share functionality
              HapticFeedback.lightImpact();
            },
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: 'share',
                color: Theme.of(context).colorScheme.onSurface,
                size: 6.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyHeader() {
    final selectedHour = hourlyForecast[selectedHourIndex];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedHour["time"] as String,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: (selectedHour["isCurrentHour"] as bool)
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    '${selectedHour["temperature"]}°',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                  Text(
                    selectedHour["condition"] as String,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: CustomIconWidget(
                iconName: selectedHour["conditionIcon"] as String,
                color: Theme.of(context).colorScheme.primary,
                size: 16.w,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          if (showPrecipitationRadar) _buildPrecipitationRadarOverlay(),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Column(
                  children: [
                    HourlyCardWidget(
                      hourData: hourlyForecast[index],
                      isSelected: selectedCards.contains(index),
                      isExpanded: expandedCardIndex == index,
                      isMultiSelectMode: isMultiSelectMode,
                      onTap: () => _selectCard(index),
                      onLongPress: () {
                        if (!isMultiSelectMode) {
                          _toggleMultiSelect();
                          _selectCard(index);
                        }
                      },
                      onExpandTap: () => _expandCard(index),
                    ),
                    if (expandedCardIndex == index)
                      ExpandedDetailsWidget(
                        hourData: hourlyForecast[index],
                      ),
                  ],
                );
              },
              childCount: hourlyForecast.length,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 20.h),
          ),
        ],
      ),
    );
  }

  Widget _buildPrecipitationRadarOverlay() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.all(4.w),
        height: 30.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                    Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'radar',
                    color: Theme.of(context).colorScheme.primary,
                    size: 12.w,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Precipitation Radar',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'Live radar data overlay',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineScrubber() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (isMultiSelectMode) _buildMultiSelectActions(),
          TimelineScrubberWidget(
            hourlyData: hourlyForecast,
            selectedIndex: selectedHourIndex,
            onIndexChanged: _onTimelineChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildMultiSelectActions() {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Text(
            '${selectedCards.length} selected',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
          TextButton(
            onPressed: _toggleMultiSelect,
            child: Text('Cancel'),
          ),
          SizedBox(width: 2.w),
          ElevatedButton(
            onPressed: selectedCards.isNotEmpty
                ? () {
                    // Compare selected hours
                    _showComparisonView();
                  }
                : null,
            child: Text('Compare'),
          ),
        ],
      ),
    );
  }

  void _showComparisonView() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 2.h),
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'Compare Selected Hours',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: selectedCards.length,
                itemBuilder: (context, index) {
                  final hourIndex = selectedCards.elementAt(index);
                  final hourData = hourlyForecast[hourIndex];
                  return HourlyCardWidget(
                    hourData: hourData,
                    isSelected: false,
                    isExpanded: false,
                    isMultiSelectMode: false,
                    onTap: () {},
                    onLongPress: () {},
                    onExpandTap: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
