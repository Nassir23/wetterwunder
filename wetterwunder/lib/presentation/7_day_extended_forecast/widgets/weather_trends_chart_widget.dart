import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fl_chart/fl_chart.dart';

class WeatherTrendsChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String selectedMetric;

  const WeatherTrendsChartWidget({
    super.key,
    required this.data,
    required this.selectedMetric,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 30.h,
        child: selectedMetric == 'temperature'
            ? _buildTemperatureChart(context)
            : _buildBarChart(context));
  }

  Widget _buildTemperatureChart(BuildContext context) {
    return LineChart(LineChartData(
        gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 5,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
                  strokeWidth: 1);
            }),
        titlesData: FlTitlesData(
            show: true,
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      if (value.toInt() >= 0 && value.toInt() < data.length) {
                        return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(data[value.toInt()]['day'] as String,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant)));
                      }
                      return const Text('');
                    })),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    interval: 5,
                    reservedSize: 40,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text('${value.toInt()}°',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant)));
                    }))),
        borderData: FlBorderData(
            show: true,
            border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.2))),
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: _getMinValue() - 2,
        maxY: _getMaxValue() + 2,
        lineBarsData: [
          LineChartBarData(
              spots: _getTemperatureSpots(),
              isCurved: true,
              gradient: LinearGradient(colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
              ]),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                        radius: 4,
                        color: Theme.of(context).colorScheme.primary,
                        strokeWidth: 2,
                        strokeColor: Theme.of(context).colorScheme.surface);
                  }),
              belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(colors: [
                    Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.3),
                    Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter))),
        ],
        lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                return LineTooltipItem(
                    '${flSpot.y.toInt()}°C',
                    Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600));
              }).toList();
            }))));
  }

  Widget _buildBarChart(BuildContext context) {
    return BarChart(BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxValue() + (_getMaxValue() * 0.1),
        barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String unit = _getUnit();
              return BarTooltipItem(
                  '${rod.toY.toInt()}$unit',
                  Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600));
            })),
        titlesData: FlTitlesData(
            show: true,
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      if (value.toInt() >= 0 && value.toInt() < data.length) {
                        return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(data[value.toInt()]['day'] as String,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant)));
                      }
                      return const Text('');
                    })),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text('${value.toInt()}${_getUnit()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant)));
                    }))),
        borderData: FlBorderData(
            show: true,
            border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.2))),
        barGroups: _getBarGroups(context),
        gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _getGridInterval(),
            getDrawingHorizontalLine: (value) {
              return FlLine(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
                  strokeWidth: 1);
            })));
  }

  List<FlSpot> _getTemperatureSpots() {
    return data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(),
          (entry.value[selectedMetric] as int).toDouble());
    }).toList();
  }

  List<BarChartGroupData> _getBarGroups(BuildContext context) {
    return data.asMap().entries.map((entry) {
      return BarChartGroupData(x: entry.key, barRods: [
        BarChartRodData(
            toY: (entry.value[selectedMetric] as int).toDouble(),
            color: _getMetricColor(context),
            width: 6.w,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: _getMaxValue().toDouble(),
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.1))),
      ]);
    }).toList();
  }

  Color _getMetricColor(BuildContext context) {
    switch (selectedMetric) {
      case 'precipitation':
        return Colors.blue;
      case 'wind':
        return Colors.green;
      case 'humidity':
        return Colors.purple;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  String _getUnit() {
    switch (selectedMetric) {
      case 'temperature':
        return '°';
      case 'precipitation':
        return '%';
      case 'wind':
        return ' km/h';
      case 'humidity':
        return '%';
      default:
        return '';
    }
  }

  double _getGridInterval() {
    switch (selectedMetric) {
      case 'temperature':
        return 5;
      case 'precipitation':
        return 20;
      case 'wind':
        return 5;
      case 'humidity':
        return 20;
      default:
        return 10;
    }
  }

  double _getMinValue() {
    return data
        .map((item) => (item[selectedMetric] as int).toDouble())
        .reduce((a, b) => a < b ? a : b);
  }

  double _getMaxValue() {
    return data
        .map((item) => (item[selectedMetric] as int).toDouble())
        .reduce((a, b) => a > b ? a : b);
  }
}
