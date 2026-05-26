import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/overview_viewmodel.dart';
import 'overview_card.dart';
import 'overview_card_shimmer.dart';
import 'overview_empty_state.dart';

/// Main Monthly Overview Dashboard Section
/// Production-grade component with full state management, animations, and responsive design
class MonthlyOverviewSection extends StatefulWidget {
  /// Optional callback when a metric card is tapped
  final Function(String metricType)? onMetricTap;

  /// Custom header title
  final String headerTitle;

  /// Show/hide individual metric types
  final bool showExpense;
  final bool showIncome;
  final bool showWater;
  final bool showElectricity;

  /// Responsive mode
  final bool isFullscreen;

  const MonthlyOverviewSection({
    super.key,
    this.onMetricTap,
    this.headerTitle = 'Overview This Month',
    this.showExpense = true,
    this.showIncome = true,
    this.showWater = true,
    this.showElectricity = true,
    this.isFullscreen = false,
  });

  @override
  State<MonthlyOverviewSection> createState() => _MonthlyOverviewSectionState();
}

class _MonthlyOverviewSectionState extends State<MonthlyOverviewSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _pullToRefreshController;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _pullToRefreshController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pullToRefreshController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    _pullToRefreshController.forward();

    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final vm = context.read<OverviewViewModel>();
      await vm.refresh();
    } finally {
      _pullToRefreshController.reverse();
      setState(() => _isRefreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 400;
    final isMedium = size.width < 600;
    final isTablet = size.width >= 900;
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<OverviewViewModel>(
      builder: (context, viewModel, _) {
        /// ===== LOADING STATE =====
        if (viewModel.isInitialLoading) {
          return OverviewCardShimmer(
            isLandscape: isTablet,
          );
        }

        /// ===== ERROR STATE WITH RETRY =====
        if (viewModel.error != null && viewModel.currentOverview == null) {
          return OverviewEmptyState(
            title: 'Something went wrong',
            message: viewModel.error ?? 'Unable to load overview data',
            onRetry: _handleRefresh,
            showRetryButton: true,
          );
        }

        /// ===== EMPTY STATE =====
        if (viewModel.currentOverview == null) {
          return OverviewEmptyState(
            onRetry: _handleRefresh,
          );
        }

        final overview = viewModel.currentOverview!;
        final metrics = viewModel.getFormattedMetrics();

        return RefreshIndicator(
          onRefresh: _handleRefresh,
          strokeWidth: 2,
          color: colorScheme.primary,
          backgroundColor: colorScheme.surface,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmall ? 12 : isMedium ? 16 : 20,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ===== HEADER SECTION =====
                  _buildHeader(context, viewModel, isSmall),

                  const SizedBox(height: 20),

                  /// ===== METRICS GRID =====
                  _buildMetricsGrid(
                    context,
                    viewModel,
                    metrics,
                    isSmall,
                    isMedium,
                    isTablet,
                  ),

                  const SizedBox(height: 20),

                  /// ===== ADDITIONAL INFO SECTION =====
                  _buildAdditionalInfo(context, overview, isSmall),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build header with title and refresh button
  Widget _buildHeader(
    BuildContext context,
    OverviewViewModel viewModel,
    bool isSmall,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.headerTitle,
                style: TextStyle(
                  fontSize: isSmall ? 18 : 20,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getCurrentMonthYear(),
                style: TextStyle(
                  fontSize: isSmall ? 12 : 13,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        /// Refresh button
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: colorScheme.outlineVariant,
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isRefreshing ? null : _handleRefresh,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: _isRefreshing || viewModel.isRefreshing
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            colorScheme.primary,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.refresh_rounded,
                        size: 18,
                        color: colorScheme.onSurfaceVariant,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build responsive metrics grid
  Widget _buildMetricsGrid(
    BuildContext context,
    OverviewViewModel viewModel,
    Map<String, String> metrics,
    bool isSmall,
    bool isMedium,
    bool isTablet,
  ) {
    final overview = viewModel.currentOverview!;

    /// Determine grid layout based on screen size
    int crossAxisCount;
    double childAspectRatio;

    if (isTablet) {
      crossAxisCount = 4;
      childAspectRatio = 1.0;
    } else if (isMedium) {
      crossAxisCount = 2;
      childAspectRatio = 0.95;
    } else {
      crossAxisCount = 2;
      childAspectRatio = 0.85;
    }

    final spacing = isSmall ? 10 : 12;

    /// Build list of cards to display based on settings
    final cards = <({
      IconData icon,
      Color color,
      String title,
      String value,
      double trend,
      String type
    })>[];

    if (widget.showExpense) {
      cards.add((
        icon: Icons.shopping_cart_rounded,
        color: const Color(0xFFFF6B6B),
        title: 'Total Expense',
        value: metrics['expense'] ?? '₹0',
        trend: overview.expenseTrend,
        type: 'expense',
      ));
    }

    if (widget.showIncome) {
      cards.add((
        icon: Icons.attach_money_rounded,
        color: const Color(0xFF51CF66),
        title: 'Total Income',
        value: metrics['income'] ?? '₹0',
        trend: overview.incomeTrend,
        type: 'income',
      ));
    }

    if (widget.showWater) {
      cards.add((
        icon: Icons.water_drop_rounded,
        color: const Color(0xFF74C0FC),
        title: 'Water Intake',
        value: metrics['water'] ?? '0L',
        trend: overview.waterTrend,
        type: 'water',
      ));
    }

    if (widget.showElectricity) {
      cards.add((
        icon: Icons.flash_on_rounded,
        color: const Color(0xFFFFD43B),
        title: 'Electricity',
        value: metrics['electricity'] ?? '0 kWh',
        trend: overview.electricityTrend,
        type: 'electricity',
      ));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing.toDouble(),
        mainAxisSpacing: spacing.toDouble(),
        childAspectRatio: childAspectRatio,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        final trendStatus =
            viewModel.getTrendStatus(card.type, card.trend);
        final isTrendPositive =
            viewModel.isTrendPositive(card.type, card.trend);

        return OverviewCard(
          icon: card.icon,
          iconColor: card.color,
          title: card.title,
          value: card.value,
          trendPercentage: viewModel.formatTrendPercentage(card.trend),
          isTrendPositive: isTrendPositive,
          onTap: widget.onMetricTap != null
              ? () => widget.onMetricTap!(card.type)
              : null,
        );
      },
    );
  }

  /// Build additional information section
  Widget _buildAdditionalInfo(
    BuildContext context,
    dynamic overview,
    bool isSmall,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final balance = overview.totalIncome - overview.totalExpense;

    return Container(
      padding: EdgeInsets.all(isSmall ? 12 : 14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Balance Summary',
            style: TextStyle(
              fontSize: isSmall ? 13 : 14,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _InfoRow(
                  label: 'Income',
                  value: '₹${overview.totalIncome.toStringAsFixed(2)}',
                  isSmall: isSmall,
                ),
              ),
              Container(
                width: 1,
                height: 30,
                color: colorScheme.outlineVariant,
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),
              Expanded(
                child: _InfoRow(
                  label: 'Expenses',
                  value: '₹${overview.totalExpense.toStringAsFixed(2)}',
                  isSmall: isSmall,
                ),
              ),
              Container(
                width: 1,
                height: 30,
                color: colorScheme.outlineVariant,
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),
              Expanded(
                child: _InfoRow(
                  label: 'Balance',
                  value: '₹${balance.toStringAsFixed(2)}',
                  valueColor:
                      balance >= 0 ? Colors.green.shade600 : Colors.red.shade600,
                  isSmall: isSmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getCurrentMonthYear() {
    final now = DateTime.now();
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
    return '${months[now.month - 1]} ${now.year}';
  }
}

/// Helper widget for additional info display
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isSmall;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
    required this.isSmall,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isSmall ? 11 : 12,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isSmall ? 13 : 14,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
