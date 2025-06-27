import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class DayForecastCardWidget extends StatelessWidget {
  final Map<String, dynamic> forecast;
  final bool isExpanded;
  final bool isSelected;
  final VoidCallback? onSwipeRight;

  const DayForecastCardWidget({
    super.key,
    required this.forecast,
    this.isExpanded = false,
    this.isSelected = false,
    this.onSwipeRight,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('forecast_${forecast['id']}'),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onSwipeRight?.call();
          return false;
        }
        return false;
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 4.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomIconWidget(
          iconName: 'more_horiz',
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            _buildDateSection(context),
            SizedBox(width: 4.w),
            _buildWeatherIcon(context),
            SizedBox(width: 4.w),
            Expanded(
              child: _buildWeatherInfo(context),
            ),
            _buildTemperatureSection(context),
            SizedBox(width: 2.w),
            _buildExpandIcon(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSection(BuildContext context) {
    return SizedBox(
      width: 20.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            forecast['dayName'] as String,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: forecast['dayName'] == 'Today'
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 0.5.h),
          Text(
            _formatDate(forecast['date'] as String),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherIcon(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName:
                  _getWeatherIconName(forecast['conditionIcon'] as String),
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
        ),
        if (forecast['hasAlert'] == true)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.surface,
                  width: 2,
                ),
              ),
              child: CustomIconWidget(
                iconName: 'warning',
                color: Theme.of(context).colorScheme.onError,
                size: 10,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWeatherInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          forecast['condition'] as String,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 0.5.h),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'water_drop',
              color: Theme.of(context).colorScheme.primary,
              size: 14,
            ),
            SizedBox(width: 1.w),
            Text(
              '${forecast['precipitationProbability']}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            SizedBox(width: 3.w),
            if (forecast['confidence'] != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getConfidenceColor(
                      context, forecast['confidence'] as int),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${forecast['confidence']}%',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildTemperatureSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${forecast['highTemp']}°',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            SizedBox(width: 1.w),
            Text(
              '${forecast['lowTemp']}°',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpandIcon(BuildContext context) {
    return AnimatedRotation(
      turns: isExpanded ? 0.5 : 0,
      duration: const Duration(milliseconds: 200),
      child: CustomIconWidget(
        iconName: 'keyboard_arrow_down',
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        size: 20,
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _getWeatherIconName(String conditionIcon) {
    switch (conditionIcon) {
      case 'sunny':
        return 'wb_sunny';
      case 'partly_cloudy_day':
        return 'partly_cloudy_day';
      case 'cloudy':
        return 'cloud';
      case 'rainy':
        return 'rainy';
      case 'thunderstorm':
        return 'thunderstorm';
      default:
        return 'wb_sunny';
    }
  }

  Color _getConfidenceColor(BuildContext context, int confidence) {
    if (confidence >= 85) {
      return Theme.of(context).colorScheme.primary;
    } else if (confidence >= 70) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
