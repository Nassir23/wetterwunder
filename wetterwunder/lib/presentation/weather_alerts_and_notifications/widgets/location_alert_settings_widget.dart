import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class LocationAlertSettingsWidget extends StatefulWidget {
  const LocationAlertSettingsWidget({super.key});

  @override
  State<LocationAlertSettingsWidget> createState() =>
      _LocationAlertSettingsWidgetState();
}

class _LocationAlertSettingsWidgetState
    extends State<LocationAlertSettingsWidget> {
  // Mock saved locations with alert settings
  List<Map<String, dynamic>> savedLocations = [
    {
      'id': 1,
      'name': 'Current Location',
      'address': 'Downtown Metro Area',
      'isCurrentLocation': true,
      'alertsEnabled': true,
      'severityLevel': 'all', // all, moderate, severe
      'alertTypes': {
        'severe_weather': true,
        'precipitation': true,
        'temperature': false,
        'wind': true,
      },
    },
    {
      'id': 2,
      'name': 'Home',
      'address': '123 Oak Street, Riverside',
      'isCurrentLocation': false,
      'alertsEnabled': true,
      'severityLevel': 'moderate',
      'alertTypes': {
        'severe_weather': true,
        'precipitation': false,
        'temperature': true,
        'wind': false,
      },
    },
    {
      'id': 3,
      'name': 'Work',
      'address': '456 Business Plaza, Downtown',
      'isCurrentLocation': false,
      'alertsEnabled': false,
      'severityLevel': 'severe',
      'alertTypes': {
        'severe_weather': true,
        'precipitation': false,
        'temperature': false,
        'wind': false,
      },
    },
  ];

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
                iconName: 'location_on',
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Location Alert Settings',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Spacer(),
              TextButton(
                onPressed: () => _showAddLocationDialog(),
                child: Text('Add Location'),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Manage weather alerts for your saved locations',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: 3.h),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: savedLocations.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final location = savedLocations[index];
              return _buildLocationCard(location);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(Map<String, dynamic> location) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: location['alertsEnabled']
            ? Theme.of(context)
                .colorScheme
                .primaryContainer
                .withValues(alpha: 0.05)
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: location['alertsEnabled']
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: location['isCurrentLocation']
                      ? Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1)
                      : Theme.of(context)
                          .colorScheme
                          .secondary
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: location['isCurrentLocation']
                      ? 'my_location'
                      : 'location_on',
                  color: location['isCurrentLocation']
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                  size: 18,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          location['name'],
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        if (location['isCurrentLocation']) ...[
                          SizedBox(width: 2.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'GPS',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      location['address'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: location['alertsEnabled'],
                onChanged: (value) {
                  setState(() {
                    location['alertsEnabled'] = value;
                  });
                },
              ),
            ],
          ),
          if (location['alertsEnabled']) ...[
            SizedBox(height: 3.h),
            _buildSeveritySelector(location),
            SizedBox(height: 2.h),
            _buildAlertTypeToggles(location),
          ],
        ],
      ),
    );
  }

  Widget _buildSeveritySelector(Map<String, dynamic> location) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alert Severity Level',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            _buildSeverityChip('all', 'All Alerts', Colors.blue, location),
            SizedBox(width: 2.w),
            _buildSeverityChip(
                'moderate', 'Moderate+', Colors.orange, location),
            SizedBox(width: 2.w),
            _buildSeverityChip('severe', 'Severe Only', Colors.red, location),
          ],
        ),
      ],
    );
  }

  Widget _buildSeverityChip(
      String value, String label, Color color, Map<String, dynamic> location) {
    final isSelected = location['severityLevel'] == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          location['severityLevel'] = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? color
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? color
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ),
    );
  }

  Widget _buildAlertTypeToggles(Map<String, dynamic> location) {
    final alertTypes = location['alertTypes'] as Map<String, dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alert Types',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: alertTypes.entries.map((entry) {
            return _buildAlertTypeChip(entry.key, entry.value, location);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAlertTypeChip(
      String type, bool isEnabled, Map<String, dynamic> location) {
    final labels = {
      'severe_weather': 'Severe Weather',
      'precipitation': 'Precipitation',
      'temperature': 'Temperature',
      'wind': 'Wind',
    };

    final icons = {
      'severe_weather': 'warning',
      'precipitation': 'water_drop',
      'temperature': 'thermostat',
      'wind': 'air',
    };

    return GestureDetector(
      onTap: () {
        setState(() {
          (location['alertTypes'] as Map<String, dynamic>)[type] = !isEnabled;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isEnabled
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isEnabled
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icons[type] ?? 'notifications',
              color: isEnabled
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              size: 14,
            ),
            SizedBox(width: 1.w),
            Text(
              labels[type] ?? type,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isEnabled
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: isEnabled ? FontWeight.w500 : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddLocationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Location'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter city name or address',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'You can add up to 5 locations for weather alerts.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Add location logic here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Location added successfully')),
              );
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
