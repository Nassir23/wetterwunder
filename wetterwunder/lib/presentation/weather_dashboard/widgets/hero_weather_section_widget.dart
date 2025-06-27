import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HeroWeatherSectionWidget extends StatelessWidget {
  final Map<String, dynamic> weather;
  final bool isCelsius;
  final bool isRefreshing;

  const HeroWeatherSectionWidget({
    super.key,
    required this.weather,
    required this.isCelsius,
    required this.isRefreshing,
  });

  @override
  Widget build(BuildContext context) {
    final temperature = weather["temperature"] as int;
    final feelsLike = weather["feelsLike"] as int;
    final condition = weather["condition"] as String;
    final location = weather["location"] as String;
    final lastUpdated = weather["lastUpdated"] as String;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            AppTheme.lightTheme.scaffoldBackgroundColor,
          ],
        ),
      ),
      child: Column(
        children: [
          // Location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Flexible(
                child: Text(
                  location,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Weather Icon
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.w),
            ),
            child: CustomIconWidget(
              iconName: 'wb_cloudy',
              color: AppTheme.lightTheme.primaryColor,
              size: 10.w,
            ),
          ),

          SizedBox(height: 2.h),

          // Temperature
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                temperature.toString(),
                style: AppTheme.lightTheme.textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w300,
                  height: 1.0,
                ),
              ),
              Text(
                isCelsius ? '°C' : '°F',
                style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),

          SizedBox(height: 1.h),

          // Condition
          Text(
            condition,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),

          SizedBox(height: 1.h),

          // Feels Like
          Text(
            'Feels like $feelsLike°${isCelsius ? 'C' : 'F'}',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),

          SizedBox(height: 3.h),

          // Last Updated
          if (isRefreshing)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 4.w,
                  height: 4.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  'Updating...',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            )
          else
            Text(
              'Last updated: $lastUpdated',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
        ],
      ),
    );
  }
}
