import 'package:flutter/material.dart';

enum StatsCardType { grid, list }

class StatsCard extends StatelessWidget {
  final String title;
  final int? value;
  final IconData? icon;
  final Color color;
  final VoidCallback? onTap;
  final StatsCardType type;
  final bool isLoading;
  final Widget? trailing;

  const StatsCard({
    super.key,
    required this.title,
    this.value,
    this.icon,
    this.color = Colors.blue,
    this.onTap,
    this.type = StatsCardType.grid,
    this.isLoading = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.25),
              color.withOpacity(0.05),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),

        /// 🔥 SWITCH UI BASED ON TYPE
        child: type == StatsCardType.grid
            ? _buildGrid()
            : _buildList(),
      ),
    );
  }

  /// 🔹 GRID STYLE (Dashboard)
  Widget _buildGrid() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null)
          Container(
            padding: const EdgeInsets.all(8), // 🔻 reduced
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.2),
            ),
            child: Icon(icon, color: color, size: 22), // 🔻 reduced
          ),

        const SizedBox(height: 6), // 🔻 reduced

        isLoading
            ? const SizedBox(
          height: 16,
          width: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
            : Text(
          "${value ?? 0}",
          style: TextStyle(
            fontSize: 18, // 🔻 reduced
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),

        const SizedBox(height: 2), // 🔻 reduced

        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12), // 🔻 reduced
        ),
      ],
    );
  }

  /// 🔹 LIST STYLE (Settings / Details)
  Widget _buildList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null)
              Icon(icon, color: color),

            const SizedBox(width: 10),

            Text(title),
          ],
        ),

        isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
            : trailing ??
            Text(
              "${value ?? 0}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
      ],
    );
  }
}