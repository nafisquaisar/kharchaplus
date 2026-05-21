import 'package:expense_tracker/features/Track/ElectricityTracking/presentation/screens/ElectricityTrackingScreen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/AppColors.dart';
import '../../providers/electricity_tracking/electricity_tracking_home_providers.dart';
import '../../../services/electricity_tracking_analytics_service.dart';

class ElectricityTrackingCard extends ConsumerWidget {
  const ElectricityTrackingCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final state = ref.watch(electricityTrackingHomeNotifierProvider);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: 6,
      ),
      padding: EdgeInsets.all(
        width * 0.03,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: state.when(
        loading: () => _EmptyContent(
          width: width,
        ),
        error: (e, _) => _ErrorContent(width: width, message: e.toString()),
        data: (analytics) {
          if (!analytics.hasData) {
            return _EmptyContent(width: width);
          }
          return _CardContent(
            width: width,
            analytics: analytics,
          );
        },
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  final double width;
  final ElectricityTrackingHomeAnalytics analytics;

  const _CardContent({
    required this.width,
    required this.analytics,
  });

  @override
  Widget build(BuildContext context) {
    final current = analytics.current;
    final currentUnits = current?.consumedUnits ?? 0;
    final billAmount = current?.billAmount ?? 0;
    final percent = analytics.percentChange.abs();
    final trend = analytics.trend;
    final trendIcon = _trendIcon(trend);
    final trendColor = _trendColor(trend);
    final badgeLabel = (current?.isActive ?? true) ? 'Pending' : 'Paid';
    final previousLabel = analytics.previousLabel.isEmpty
        ? 'vs --'
        : 'vs ${analytics.previousLabel}';

    debugPrint('[ElectricityHomeCard] currentUnits=$currentUnits');
    debugPrint('[ElectricityHomeCard] percent=${percent.toStringAsFixed(2)}');
    debugPrint('[ElectricityHomeCard] chartPoints=${analytics.points.length}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ElectricityTrackingScreen(),
              ),
            );
          },
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.bolt_rounded,
                        size: 16,
                        color: const Color(0xFF2D8C82),
                      ),
                    ),
                    SizedBox(width: width * 0.03),
                    Expanded(
                      child: Text(
                        "Electricity Tracking",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
                size: width * 0.065,
              ),
            ],
          ),
        ),
        SizedBox(height: width * 0.02),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "This Month",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: width * 0.033,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: width * 0.003),
                  Text(
                    _formatUnits(currentUnits),
                    style: TextStyle(
                      fontSize: width * 0.06,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: width * 0.012),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.025,
                      vertical: width * 0.008,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      badgeLabel,
                      style: TextStyle(
                        color: const Color(0xFF475467),
                        fontWeight: FontWeight.w600,
                        fontSize: width * 0.03,
                      ),
                    ),
                  ),
                  SizedBox(height: width * 0.02),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: _formatAmount(billAmount),
                          style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: width * 0.055,
                          ),
                        ),
                        TextSpan(
                          text: " Bill",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: width * 0.04,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      trendIcon,
                      color: trendColor,
                      size: width * 0.043,
                    ),
                    Text(
                      _formatPercent(percent),
                      style: TextStyle(
                        color: trendColor,
                        fontWeight: FontWeight.w700,
                        fontSize: width * 0.04,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: width * 0.002),
                Text(
                  previousLabel,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: width * 0.03,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: width * 0.03),
        SizedBox(
          height: width * 0.18,
          child: _ElectricityTrendChart(
            points: analytics.points,
          ),
        ),
      ],
    );
  }

  String _formatUnits(int units) {
    return '$units Units';
  }

  String _formatAmount(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  String _formatPercent(double percent) {
    return '${percent.abs().toStringAsFixed(0)}%';
  }

  IconData _trendIcon(ElectricityTrendDirection trend) {
    switch (trend) {
      case ElectricityTrendDirection.up:
        return Icons.arrow_upward_rounded;
      case ElectricityTrendDirection.down:
        return Icons.arrow_downward_rounded;
      case ElectricityTrendDirection.flat:
        return Icons.arrow_forward_rounded;
    }
  }

  Color _trendColor(ElectricityTrendDirection trend) {
    switch (trend) {
      case ElectricityTrendDirection.up:
        return const Color(0xFF2D8C82);
      case ElectricityTrendDirection.down:
        return const Color(0xFFE54848);
      case ElectricityTrendDirection.flat:
        return AppColors.textSecondary;
    }
  }
}

class _ElectricityTrendChart extends StatelessWidget {
  final List<ElectricityMonthlyPoint> points;

  const _ElectricityTrendChart({
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return Center(
        child: Text(
          'No data',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    final spots = _buildSpots(points);
    final maxX = (spots.length - 1).toDouble();
    final maxY = _maxY(points);

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: maxX > 0 ? maxX : 1,
        minY: 0,
        maxY: maxY,
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: const Color(0xFF2D8C82),
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF2D8C82).withOpacity(0.18),
                  const Color(0xFF2D8C82).withOpacity(0.01),
                ],
              ),
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                final isLatest = index == spots.length - 1;
                return FlDotCirclePainter(
                  radius: isLatest ? 5 : 3,
                  color: const Color(0xFF2D8C82),
                  strokeWidth: 0,
                );
              },
            ),
            spots: spots,
          ),
        ],
      ),
    );
  }

  List<FlSpot> _buildSpots(List<ElectricityMonthlyPoint> points) {
    return List.generate(
      points.length,
      (index) => FlSpot(index.toDouble(), points[index].units),
    );
  }

  double _maxY(List<ElectricityMonthlyPoint> points) {
    final maxValue = points.map((point) => point.units).fold<double>(0, (prev, next) {
      return next > prev ? next : prev;
    });
    return maxValue <= 0 ? 10 : maxValue * 1.2;
  }
}


class _ErrorContent extends StatelessWidget {
  final double width;
  final String message;

  const _ErrorContent({
    required this.width,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: width * 0.32,
      child: Center(
        child: Text(
          'Failed to load',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: width * 0.032,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _EmptyContent extends StatelessWidget {
  final double width;

  const _EmptyContent({
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: width * 0.32,
      child: Center(
        child: Text(
          'No electricity data',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: width * 0.032,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}