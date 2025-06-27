import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ExpandedDetailsWidget extends StatefulWidget {
  final Map<String, dynamic> hourData;

  const ExpandedDetailsWidget({
    super.key,
    required this.hourData,
  });

  @override
  State<ExpandedDetailsWidget> createState() => _ExpandedDetailsWidgetState();
}

class _ExpandedDetailsWidgetState extends State<ExpandedDetailsWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _slideAnimation.value)),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  SizedBox(height: 3.h),
                  _buildDetailGrid(context),
                  SizedBox(height: 3.h),
                  _buildWeatherInsights(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: CustomIconWidget(
            iconName: 'info',
            color: Theme.of(context).colorScheme.primary,
            size: 6.w,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detailed Information',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                '${widget.hourData["time"]} - ${widget.hourData["condition"]}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDetailCard(
                context,
                'UV Index',
                '${widget.hourData["uvIndex"]}',
                'wb_sunny',
                _getUVIndexDescription(widget.hourData["uvIndex"] as int),
                _getUVIndexColor(context, widget.hourData["uvIndex"] as int),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildDetailCard(
                context,
                'Visibility',
                '${widget.hourData["visibility"]} km',
                'visibility',
                _getVisibilityDescription(widget.hourData["visibility"] as int),
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        Row(
          children: [
            Expanded(
              child: _buildDetailCard(
                context,
                'Pressure',
                '${widget.hourData["pressure"]} hPa',
                'speed',
                _getPressureDescription(widget.hourData["pressure"] as int),
                Theme.of(context).colorScheme.secondary,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildDetailCard(
                context,
                'Feels Like',
                '${widget.hourData["feelsLike"]}°',
                'thermostat',
                _getFeelsLikeDescription(
                  widget.hourData["temperature"] as int,
                  widget.hourData["feelsLike"] as int,
                ),
                Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailCard(
    BuildContext context,
    String title,
    String value,
    String iconName,
    String description,
    Color accentColor,
  ) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: accentColor,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: accentColor,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherInsights(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'lightbulb',
                color: Theme.of(context).colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Weather Insights',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            _generateWeatherInsight(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }

  String _getUVIndexDescription(int uvIndex) {
    if (uvIndex <= 2) return 'Low - Minimal protection needed';
    if (uvIndex <= 5) return 'Moderate - Seek shade during midday';
    if (uvIndex <= 7) return 'High - Protection essential';
    if (uvIndex <= 10) return 'Very High - Extra protection required';
    return 'Extreme - Avoid sun exposure';
  }

  Color _getUVIndexColor(BuildContext context, int uvIndex) {
    if (uvIndex <= 2) return Colors.green;
    if (uvIndex <= 5) return Colors.yellow.shade700;
    if (uvIndex <= 7) return Colors.orange;
    if (uvIndex <= 10) return Colors.red;
    return Colors.purple;
  }

  String _getVisibilityDescription(int visibility) {
    if (visibility >= 10) return 'Excellent - Clear conditions';
    if (visibility >= 5) return 'Good - Minor haze possible';
    if (visibility >= 2) return 'Moderate - Some fog or haze';
    return 'Poor - Dense fog or precipitation';
  }

  String _getPressureDescription(int pressure) {
    if (pressure > 1020) return 'High - Fair weather expected';
    if (pressure > 1000) return 'Normal - Stable conditions';
    return 'Low - Unsettled weather likely';
  }

  String _getFeelsLikeDescription(int actual, int feelsLike) {
    final difference = feelsLike - actual;
    if (difference > 3) return 'Feels warmer due to humidity';
    if (difference < -3) return 'Feels cooler due to wind chill';
    return 'Temperature matches actual feel';
  }

  String _generateWeatherInsight() {
    final condition = widget.hourData["condition"] as String;
    final precipitation = widget.hourData["precipitationProbability"] as int;
    final windSpeed = widget.hourData["windSpeed"] as int;
    final humidity = widget.hourData["humidity"] as int;

    if (condition.toLowerCase().contains('rain') || precipitation > 60) {
      return 'Rain is likely during this hour. Consider carrying an umbrella and waterproof clothing. Visibility may be reduced.';
    } else if (condition.toLowerCase().contains('sunny') &&
        widget.hourData["uvIndex"] > 7) {
      return 'Strong UV radiation expected. Apply sunscreen, wear protective clothing, and seek shade during peak hours.';
    } else if (windSpeed > 25) {
      return 'Windy conditions expected. Secure loose objects and be cautious when driving or walking outdoors.';
    } else if (humidity > 80) {
      return 'High humidity levels will make it feel warmer than the actual temperature. Stay hydrated and take breaks in cool areas.';
    } else {
      return 'Pleasant weather conditions expected. Perfect time for outdoor activities with appropriate clothing.';
    }
  }
}
