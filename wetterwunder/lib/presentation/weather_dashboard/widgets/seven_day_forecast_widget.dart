import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SevenDayForecastWidget extends StatelessWidget {
  final List<Map<String, dynamic>> weeklyData;
  final bool isCelsius;
  final Function(int) onDayTap;

  const SevenDayForecastWidget({
    super.key,
    required this.weeklyData,
    required this.isCelsius,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '7-Day Forecast',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () => onDayTap(0),
                child: Text(
                  'View All',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Card(
            child: Column(
              children: weeklyData.asMap().entries.map((entry) {
                final index = entry.key;
                final day = entry.value;
                final isLast = index == weeklyData.length - 1;

                return Column(
                  children: [
                    GestureDetector(
                      onTap: () => onDayTap(index),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 2.h,
                        ),
                        child: Row(
                          children: [
                            // Day and Date
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    day["day"] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    day["date"] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Weather Icon and Condition
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: day["icon"] as String,
                                    color: AppTheme.lightTheme.primaryColor,
                                    size: 5.w,
                                  ),
                                  SizedBox(width: 2.w),
                                  Flexible(
                                    child: Text(
                                      day["condition"] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Precipitation
                            Expanded(
                              child: Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'water_drop',
                                    color: AppTheme.lightTheme.primaryColor,
                                    size: 3.w,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    '${day["precipitation"]}%',
                                    style:
                                        AppTheme.lightTheme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),

                            // Temperature Range
                            SizedBox(
                              width: 15.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${day["low"]}°',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    '${day["high"]}°',
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!isLast)
                      Divider(
                        height: 1,
                        color: AppTheme.lightTheme.dividerColor,
                        indent: 4.w,
                        endIndent: 4.w,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
