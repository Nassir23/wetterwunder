import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class TimelineScrubberWidget extends StatefulWidget {
  final List<Map<String, dynamic>> hourlyData;
  final int selectedIndex;
  final Function(int) onIndexChanged;

  const TimelineScrubberWidget({
    super.key,
    required this.hourlyData,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  State<TimelineScrubberWidget> createState() => _TimelineScrubberWidgetState();
}

class _TimelineScrubberWidgetState extends State<TimelineScrubberWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 12.h,
      child: Column(
        children: [
          _buildTimelineHeader(),
          SizedBox(height: 2.h),
          _buildTimelineSlider(),
          SizedBox(height: 1.h),
          _buildTimeLabels(),
        ],
      ),
    );
  }

  Widget _buildTimelineHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Timeline',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        Text(
          '${widget.hourlyData.length} hours',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildTimelineSlider() {
    return SizedBox(
      height: 6.h,
      child: Stack(
        children: [
          // Background track
          Positioned(
            left: 0,
            right: 0,
            top: 2.5.h,
            child: Container(
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Active track
          Positioned(
            left: 0,
            right: (100 -
                    (widget.selectedIndex /
                        (widget.hourlyData.length - 1) *
                        100))
                .w,
            top: 2.5.h,
            child: Container(
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Hour markers
          ...List.generate(widget.hourlyData.length, (index) {
            final position = index / (widget.hourlyData.length - 1);
            final isSelected = index == widget.selectedIndex;
            final isCurrentHour =
                widget.hourlyData[index]["isCurrentHour"] as bool? ?? false;

            return Positioned(
              left: position * 88.w,
              top: 1.h,
              child: GestureDetector(
                onTap: () {
                  widget.onIndexChanged(index);
                  HapticFeedback.selectionClick();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isSelected ? 4.w : 2.w,
                  height: isSelected ? 4.h : 3.h,
                  decoration: BoxDecoration(
                    color: isCurrentHour
                        ? Theme.of(context).colorScheme.primary
                        : isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .outline
                                .withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: isCurrentHour && !isSelected
                      ? Center(
                          child: Container(
                            width: 1.w,
                            height: 1.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            );
          }),

          // Draggable thumb
          Positioned(
            left:
                (widget.selectedIndex / (widget.hourlyData.length - 1)) * 88.w -
                    2.w,
            top: 0,
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  _isDragging = true;
                });
                _animationController.forward();
                HapticFeedback.mediumImpact();
              },
              onPanUpdate: (details) {
                final RenderBox renderBox =
                    context.findRenderObject() as RenderBox;
                final localPosition =
                    renderBox.globalToLocal(details.globalPosition);
                final progress = (localPosition.dx / 88.w).clamp(0.0, 1.0);
                final newIndex =
                    (progress * (widget.hourlyData.length - 1)).round();

                if (newIndex != widget.selectedIndex) {
                  widget.onIndexChanged(newIndex);
                  HapticFeedback.selectionClick();
                }
              },
              onPanEnd: (details) {
                setState(() {
                  _isDragging = false;
                });
                _animationController.reverse();
                HapticFeedback.lightImpact();
              },
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _isDragging ? _scaleAnimation.value : 1.0,
                    child: Container(
                      width: 8.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.3),
                            blurRadius: _isDragging ? 12 : 8,
                            spreadRadius: _isDragging ? 4 : 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 3.w,
                          height: 3.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeLabels() {
    final startIndex =
        (widget.selectedIndex - 2).clamp(0, widget.hourlyData.length - 5);
    final endIndex = (startIndex + 4).clamp(4, widget.hourlyData.length - 1);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        final dataIndex = startIndex + index;
        if (dataIndex >= widget.hourlyData.length) {
          return const SizedBox.shrink();
        }

        final hourData = widget.hourlyData[dataIndex];
        final isSelected = dataIndex == widget.selectedIndex;
        final isCurrentHour = hourData["isCurrentHour"] as bool? ?? false;

        return Expanded(
          child: Column(
            children: [
              Text(
                hourData["time"] as String,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected || isCurrentHour
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.7),
                      fontWeight: isSelected || isCurrentHour
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 0.5.h),
              Text(
                '${hourData["temperature"]}°',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected || isCurrentHour
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.5),
                      fontWeight: isSelected || isCurrentHour
                          ? FontWeight.w500
                          : FontWeight.w400,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }),
    );
  }
}
