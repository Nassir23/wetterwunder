import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class NotificationPreferencesWidget extends StatefulWidget {
  const NotificationPreferencesWidget({super.key});

  @override
  State<NotificationPreferencesWidget> createState() =>
      _NotificationPreferencesWidgetState();
}

class _NotificationPreferencesWidgetState
    extends State<NotificationPreferencesWidget> {
  // Mock notification preferences
  Map<String, bool> preferences = {
    'severe_weather': true,
    'daily_forecasts': true,
    'precipitation': false,
    'temperature_extremes': true,
    'wind_alerts': false,
    'air_quality': true,
    'uv_index': false,
    'frost_warnings': true,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'notifications',
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Notification Preferences',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Choose which types of weather alerts you want to receive',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: 3.h),
          _buildPreferenceSection('Critical Alerts', [
            _buildPreferenceItem(
              'severe_weather',
              'Severe Weather',
              'Thunderstorms, tornadoes, hurricanes',
              Icons.warning,
              Colors.red,
            ),
            _buildPreferenceItem(
              'temperature_extremes',
              'Temperature Extremes',
              'Heat waves, cold snaps, frost warnings',
              Icons.thermostat,
              Colors.orange,
            ),
          ]),
          SizedBox(height: 3.h),
          _buildPreferenceSection('Daily Updates', [
            _buildPreferenceItem(
              'daily_forecasts',
              'Daily Forecasts',
              'Morning weather summary',
              Icons.today,
              Colors.blue,
            ),
            _buildPreferenceItem(
              'precipitation',
              'Precipitation Alerts',
              'Rain, snow, and storm notifications',
              Icons.water_drop,
              Colors.lightBlue,
            ),
          ]),
          SizedBox(height: 3.h),
          _buildPreferenceSection('Environmental', [
            _buildPreferenceItem(
              'air_quality',
              'Air Quality Index',
              'Poor air quality warnings',
              Icons.air,
              Colors.green,
            ),
            _buildPreferenceItem(
              'uv_index',
              'UV Index Alerts',
              'High UV radiation warnings',
              Icons.wb_sunny,
              Colors.amber,
            ),
            _buildPreferenceItem(
              'wind_alerts',
              'Wind Alerts',
              'High wind speed warnings',
              Icons.air,
              Colors.teal,
            ),
          ]),
          SizedBox(height: 3.h),
          _buildNotificationPreview(),
        ],
      ),
    );
  }

  Widget _buildPreferenceSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        SizedBox(height: 1.h),
        ...items,
      ],
    );
  }

  Widget _buildPreferenceItem(
    String key,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: preferences[key] == true
            ? color.withValues(alpha: 0.05)
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: preferences[key] == true
              ? color.withValues(alpha: 0.3)
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: _getIconName(icon),
              color: color,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Switch(
            value: preferences[key] ?? false,
            onChanged: (value) {
              setState(() {
                preferences[key] = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationPreview() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primaryContainer
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'phone_android',
                color: Theme.of(context).colorScheme.primary,
                size: 18,
              ),
              SizedBox(width: 2.w),
              Text(
                'Notification Preview',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: CustomIconWidget(
                        iconName: 'cloud',
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WetterWunder',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          'now',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  'Severe Thunderstorm Warning',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Damaging winds and large hail expected in your area until 8:00 PM.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getIconName(IconData icon) {
    switch (icon) {
      case Icons.warning:
        return 'warning';
      case Icons.thermostat:
        return 'thermostat';
      case Icons.today:
        return 'today';
      case Icons.water_drop:
        return 'water_drop';
      case Icons.air:
        return 'air';
      case Icons.wb_sunny:
        return 'wb_sunny';
      default:
        return 'notifications';
    }
  }
}
