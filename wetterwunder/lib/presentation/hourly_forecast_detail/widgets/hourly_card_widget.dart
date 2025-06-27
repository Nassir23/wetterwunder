import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class HourlyCardWidget extends StatelessWidget {
  final Map<String, dynamic> hourData;
  final bool isSelected;
  final bool isExpanded;
  final bool isMultiSelectMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onExpandTap;

  const HourlyCardWidget({
    super.key,
    required this.hourData,
    required this.isSelected,
    required this.isExpanded,
    required this.isMultiSelectMode,
    required this.onTap,
    required this.onLongPress,
    required this.onExpandTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrentHour = hourData["isCurrentHour"] as bool? ?? false;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        if (isMultiSelectMode) {
          onTap();
        } else {
          onExpandTap();
        }
      },
      onLongPress: () {
        HapticFeedback.mediumImpact();
        onLongPress();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCurrentHour
                ? Theme.of(context).colorScheme.primary
                : isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.2),
            width: isCurrentHour || isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              _buildMainContent(context, isCurrentHour),
              if (isExpanded) _buildExpandedContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, bool isCurrentHour) {
    return Row(
      children: [
        // Time and temperature section
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    hourData["time"] as String,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isCurrentHour
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight:
                              isCurrentHour ? FontWeight.w600 : FontWeight.w500,
                        ),
                  ),
                  if (isCurrentHour) ...[
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'NOW',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                  if (isMultiSelectMode) ...[
                    const Spacer(),
                    CustomIconWidget(
                      iconName: isSelected
                          ? 'check_circle'
                          : 'radio_button_unchecked',
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                      size: 6.w,
                    ),
                  ],
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                '${hourData["temperature"]}°',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
              ),
            ],
          ),
        ),

        // Weather condition icon
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: CustomIconWidget(
            iconName: hourData["conditionIcon"] as String,
            color: Theme.of(context).colorScheme.primary,
            size: 10.w,
          ),
        ),

        SizedBox(width: 4.w),

        // Weather details section
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                hourData["condition"] as String,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                textAlign: TextAlign.end,
              ),
              SizedBox(height: 1.h),
              _buildPrecipitationBar(context),
              SizedBox(height: 1.h),
              _buildWindInfo(context),
              SizedBox(height: 0.5.h),
              _buildHumidityInfo(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrecipitationBar(BuildContext context) {
    final precipitationProbability =
        hourData["precipitationProbability"] as int;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$precipitationProbability% rain',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(height: 0.5.h),
        Container(
          width: 20.w,
          height: 0.8.h,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: precipitationProbability / 100,
            child: Container(
              decoration: BoxDecoration(
                color:
                    _getPrecipitationColor(context, precipitationProbability),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWindInfo(BuildContext context) {
    final windSpeed = hourData["windSpeed"] as int;
    final windDirection = hourData["windDirection"] as String;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomIconWidget(
          iconName: 'air',
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          size: 4.w,
        ),
        SizedBox(width: 1.w),
        Text(
          '$windSpeed km/h $windDirection',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(width: 2.w),
        Transform.rotate(
          angle: _getWindDirectionAngle(windDirection),
          child: CustomIconWidget(
            iconName: 'navigation',
            color: Theme.of(context).colorScheme.primary,
            size: 4.w,
          ),
        ),
      ],
    );
  }

  Widget _buildHumidityInfo(BuildContext context) {
    final humidity = hourData["humidity"] as int;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomIconWidget(
          iconName: 'water_drop',
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          size: 4.w,
        ),
        SizedBox(width: 1.w),
        Text(
          '$humidity%',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildExpandedContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailItem(
                context,
                'UV Index',
                '${hourData["uvIndex"]}',
                'wb_sunny',
              ),
              _buildDetailItem(
                context,
                'Visibility',
                '${hourData["visibility"]} km',
                'visibility',
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailItem(
                context,
                'Pressure',
                '${hourData["pressure"]} hPa',
                'speed',
              ),
              _buildDetailItem(
                context,
                'Feels like',
                '${hourData["feelsLike"]}°',
                'thermostat',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
      BuildContext context, String label, String value, String iconName) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: Theme.of(context).colorScheme.primary,
          size: 6.w,
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  Color _getPrecipitationColor(BuildContext context, int probability) {
    if (probability < 20) {
      return Theme.of(context).colorScheme.primary.withValues(alpha: 0.3);
    } else if (probability < 50) {
      return Theme.of(context).colorScheme.primary.withValues(alpha: 0.6);
    } else if (probability < 80) {
      return Theme.of(context).colorScheme.primary;
    } else {
      return Theme.of(context).colorScheme.error;
    }
  }

  double _getWindDirectionAngle(String direction) {
    switch (direction.toUpperCase()) {
      case 'N':
        return 0;
      case 'NE':
        return 0.785398; // 45 degrees
      case 'E':
        return 1.570796; // 90 degrees
      case 'SE':
        return 2.356194; // 135 degrees
      case 'S':
        return 3.141593; // 180 degrees
      case 'SW':
        return 3.926991; // 225 degrees
      case 'W':
        return 4.712389; // 270 degrees
      case 'NW':
        return 5.497787; // 315 degrees
      default:
        return 0;
    }
  }
}
