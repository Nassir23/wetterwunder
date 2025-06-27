import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AlertCardWidget extends StatelessWidget {
  final Map<String, dynamic> alert;
  final VoidCallback onTap;
  final VoidCallback onShare;
  final VoidCallback onAddToCalendar;
  final VoidCallback onDismiss;

  const AlertCardWidget({
    super.key,
    required this.alert,
    required this.onTap,
    required this.onShare,
    required this.onAddToCalendar,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(alert['id'].toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomIconWidget(
          iconName: 'delete',
          color: Colors.white,
          size: 24,
        ),
      ),
      confirmDismiss: (direction) async {
        return await _showDismissDialog(context);
      },
      onDismissed: (direction) => onDismiss(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  _getSeverityColor(alert['severity']).withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow,
                blurRadius: 8,
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: _getSeverityColor(alert['severity'])
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      alert['severity'].toString().toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: _getSeverityColor(alert['severity']),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Spacer(),
                  if (alert['isActive'] == true) _buildCountdownTimer(),
                  PopupMenuButton<String>(
                    icon: CustomIconWidget(
                      iconName: 'more_vert',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'share':
                          onShare();
                          break;
                        case 'calendar':
                          onAddToCalendar();
                          break;
                        case 'dismiss':
                          onDismiss();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'share',
                              color: Theme.of(context).colorScheme.onSurface,
                              size: 18,
                            ),
                            SizedBox(width: 2.w),
                            Text('Share Alert'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'calendar',
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'calendar_today',
                              color: Theme.of(context).colorScheme.onSurface,
                              size: 18,
                            ),
                            SizedBox(width: 2.w),
                            Text('Add to Calendar'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'dismiss',
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'close',
                              color: Colors.red,
                              size: 18,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Dismiss',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                alert['type'],
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'location_on',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Expanded(
                    child: Text(
                      alert['area'],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                alert['description'],
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'schedule',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    '${_formatTime(alert['startTime'])} - ${_formatTime(alert['endTime'])}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Spacer(),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: _getSeverityColor(alert['severity'])
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'warning',
                          color: _getSeverityColor(alert['severity']),
                          size: 14,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Priority ${alert['priority']}',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: _getSeverityColor(alert['severity']),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountdownTimer() {
    final now = DateTime.now();
    final endTime = alert['endTime'] as DateTime;
    final difference = endTime.difference(now);

    if (difference.isNegative) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'EXPIRED',
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      );
    }

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: _getSeverityColor(alert['severity']).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${hours}h ${minutes}m left',
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
          color: _getSeverityColor(alert['severity']),
        ),
      ),
    );
  }

  Future<bool?> _showDismissDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Dismiss Alert'),
        content: Text('Are you sure you want to dismiss this weather alert?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Dismiss'),
          ),
        ],
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
        return Colors.blue;
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
