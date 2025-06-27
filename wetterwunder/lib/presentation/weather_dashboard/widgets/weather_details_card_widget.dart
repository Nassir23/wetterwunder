import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WeatherDetailsCardWidget extends StatelessWidget {
  final Map<String, dynamic> weather;

  const WeatherDetailsCardWidget({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Details',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 2.h),
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  _buildDetailRow(
                    'Sunrise',
                    weather["sunrise"] as String,
                    'wb_sunny',
                    'Sunset',
                    weather["sunset"] as String,
                    'wb_twilight_1',
                  ),
                  SizedBox(height: 3.h),
                  _buildDetailRow(
                    'Humidity',
                    '${weather["humidity"]}%',
                    'water_drop',
                    'UV Index',
                    '${weather["uvIndex"]}',
                    'wb_sunny',
                  ),
                  SizedBox(height: 3.h),
                  _buildDetailRow(
                    'Wind',
                    '${weather["windSpeed"]} km/h ${weather["windDirection"]}',
                    'air',
                    'Visibility',
                    '${weather["visibility"]} km',
                    'visibility',
                  ),
                  SizedBox(height: 3.h),
                  _buildDetailRow(
                    'Pressure',
                    '${weather["pressure"]} hPa',
                    'speed',
                    '',
                    '',
                    '',
                    isSingle: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label1,
    String value1,
    String icon1,
    String label2,
    String value2,
    String icon2, {
    bool isSingle = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildDetailItem(label1, value1, icon1),
        ),
        if (!isSingle) ...[
          SizedBox(width: 4.w),
          Expanded(
            child: _buildDetailItem(label2, value2, icon2),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailItem(String label, String value, String iconName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
