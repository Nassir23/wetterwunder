import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/alert_card_widget.dart';
import './widgets/alert_history_widget.dart';
import './widgets/location_alert_settings_widget.dart';
import './widgets/notification_preferences_widget.dart';

class WeatherAlertsAndNotifications extends StatefulWidget {
  const WeatherAlertsAndNotifications({super.key});

  @override
  State<WeatherAlertsAndNotifications> createState() =>
      _WeatherAlertsAndNotificationsState();
}

class _WeatherAlertsAndNotificationsState
    extends State<WeatherAlertsAndNotifications> with TickerProviderStateMixin {
  late TabController _tabController;

  // Mock data for active alerts
  final List<Map<String, dynamic>> activeAlerts = [
    {
      "id": 1,
      "type": "Severe Thunderstorm Warning",
      "severity": "severe",
      "area": "Downtown Metro Area",
      "startTime": DateTime.now().subtract(Duration(hours: 1)),
      "endTime": DateTime.now().add(Duration(hours: 3)),
      "description":
          "Severe thunderstorms with damaging winds up to 70 mph and large hail expected.",
      "fullDetails":
          "The National Weather Service has issued a Severe Thunderstorm Warning for the Downtown Metro Area until 8:00 PM. Damaging winds up to 70 mph and hail up to quarter size are possible. Seek shelter immediately in a sturdy building away from windows.",
      "safetyRecommendations": [
        "Move to an interior room on the lowest floor",
        "Stay away from windows and doors",
        "Avoid using electrical appliances",
        "Do not go outside until the storm passes"
      ],
      "isActive": true,
      "priority": 1
    },
    {
      "id": 2,
      "type": "Flash Flood Watch",
      "severity": "moderate",
      "area": "River Valley Region",
      "startTime": DateTime.now().add(Duration(hours: 2)),
      "endTime": DateTime.now().add(Duration(hours: 8)),
      "description":
          "Heavy rainfall may cause flash flooding in low-lying areas.",
      "fullDetails":
          "A Flash Flood Watch has been issued for the River Valley Region from 6:00 PM to 12:00 AM. Heavy rainfall of 2-4 inches is expected, which may cause rapid rises in creeks and streams.",
      "safetyRecommendations": [
        "Avoid driving through flooded roads",
        "Stay informed about weather conditions",
        "Have an evacuation plan ready",
        "Keep emergency supplies accessible"
      ],
      "isActive": true,
      "priority": 2
    },
    {
      "id": 3,
      "type": "Heat Advisory",
      "severity": "advisory",
      "area": "Metropolitan Area",
      "startTime": DateTime.now().add(Duration(hours: 12)),
      "endTime": DateTime.now().add(Duration(hours: 24)),
      "description":
          "Dangerous heat index values up to 105°F expected tomorrow.",
      "fullDetails":
          "A Heat Advisory is in effect for the Metropolitan Area from 10:00 AM to 8:00 PM tomorrow. Heat index values up to 105°F are expected. Take precautions to avoid heat-related illness.",
      "safetyRecommendations": [
        "Stay hydrated by drinking plenty of water",
        "Limit outdoor activities during peak hours",
        "Wear light-colored, loose-fitting clothing",
        "Check on elderly neighbors and relatives"
      ],
      "isActive": true,
      "priority": 3
    }
  ];

  // Mock data for alert history
  final List<Map<String, dynamic>> alertHistory = [
    {
      "id": 4,
      "type": "Winter Storm Warning",
      "severity": "severe",
      "area": "Northern Counties",
      "startTime": DateTime.now().subtract(Duration(days: 3)),
      "endTime": DateTime.now().subtract(Duration(days: 2)),
      "description":
          "Heavy snow and ice accumulation caused hazardous travel conditions.",
      "isActive": false
    },
    {
      "id": 5,
      "type": "High Wind Warning",
      "severity": "moderate",
      "area": "Coastal Areas",
      "startTime": DateTime.now().subtract(Duration(days: 7)),
      "endTime": DateTime.now().subtract(Duration(days: 6)),
      "description": "Sustained winds of 40-50 mph with gusts up to 70 mph.",
      "isActive": false
    },
    {
      "id": 6,
      "type": "Frost Advisory",
      "severity": "advisory",
      "area": "Rural Districts",
      "startTime": DateTime.now().subtract(Duration(days: 10)),
      "endTime": DateTime.now().subtract(Duration(days: 9)),
      "description":
          "Temperatures as low as 32°F may damage sensitive vegetation.",
      "isActive": false
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Weather Alerts',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Theme.of(context).colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'settings',
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () => _showNotificationSettings(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'warning',
                    color: Theme.of(context).tabBarTheme.labelColor,
                    size: 18,
                  ),
                  SizedBox(width: 2.w),
                  Text('Active Alerts'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'history',
                    color: Theme.of(context).tabBarTheme.unselectedLabelColor,
                    size: 18,
                  ),
                  SizedBox(width: 2.w),
                  Text('History'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveAlertsTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildActiveAlertsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (activeAlerts.isNotEmpty) ...[
            _buildAlertsSummary(),
            SizedBox(height: 3.h),
            _buildActiveAlertsList(),
            SizedBox(height: 3.h),
          ],
          NotificationPreferencesWidget(),
          SizedBox(height: 3.h),
          LocationAlertSettingsWidget(),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          SizedBox(height: 2.h),
          AlertHistoryWidget(alertHistory: alertHistory),
        ],
      ),
    );
  }

  Widget _buildAlertsSummary() {
    final severeCount =
        activeAlerts.where((alert) => alert['severity'] == 'severe').length;
    final moderateCount =
        activeAlerts.where((alert) => alert['severity'] == 'moderate').length;
    final advisoryCount =
        activeAlerts.where((alert) => alert['severity'] == 'advisory').length;

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
                iconName: 'info',
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Alert Summary',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem('Severe', severeCount, Colors.red),
              _buildSummaryItem('Moderate', moderateCount, Colors.orange),
              _buildSummaryItem('Advisory', advisoryCount, Colors.amber),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildActiveAlertsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active Alerts',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 2.h),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: activeAlerts.length,
          separatorBuilder: (context, index) => SizedBox(height: 2.h),
          itemBuilder: (context, index) {
            final alert = activeAlerts[index];
            return AlertCardWidget(
              alert: alert,
              onTap: () => _showAlertDetails(context, alert),
              onShare: () => _shareAlert(alert),
              onAddToCalendar: () => _addToCalendar(alert),
              onDismiss: () => _dismissAlert(alert['id']),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search alert history...',
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        ),
        onChanged: (value) {
          // Implement search functionality
        },
      ),
    );
  }

  void _showAlertDetails(BuildContext context, Map<String, dynamic> alert) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: _getSeverityColor(alert['severity'])
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            alert['severity'].toString().toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: _getSeverityColor(alert['severity']),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: CustomIconWidget(
                            iconName: 'close',
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 24,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      alert['type'],
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      alert['area'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    SizedBox(height: 3.h),
                    _buildDetailSection('Full Details', alert['fullDetails']),
                    SizedBox(height: 3.h),
                    _buildSafetyRecommendations(alert['safetyRecommendations']),
                    SizedBox(height: 3.h),
                    _buildTimeInfo(alert),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 1.h),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildSafetyRecommendations(List<dynamic> recommendations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Safety Recommendations',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 1.h),
        ...recommendations.map((rec) => Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: Theme.of(context).colorScheme.primary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      rec.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildTimeInfo(Map<String, dynamic> alert) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Start Time',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    _formatDateTime(alert['startTime']),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'End Time',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    _formatDateTime(alert['endTime']),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  Text(
                    'Notification Settings',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Spacer(),
                  IconButton(
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 24,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: NotificationPreferencesWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareAlert(Map<String, dynamic> alert) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alert shared successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _addToCalendar(Map<String, dynamic> alert) {
    // Implement add to calendar functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alert added to calendar'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _dismissAlert(int alertId) {
    setState(() {
      activeAlerts.removeWhere((alert) => alert['id'] == alertId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alert dismissed'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'severe':
        return Colors.red;
      case 'moderate':
        return Colors.orange;
      case 'advisory':
        return Colors.amber;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
