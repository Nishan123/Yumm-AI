import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/container_property.dart';

class NutritionsInfoCard extends StatelessWidget {
  final double fat;
  final double carbs;
  final double calories;
  final double fiber;
  const NutritionsInfoCard({
    super.key,
    required this.fat,
    required this.carbs,
    required this.calories,
    required this.fiber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16),

      decoration: BoxDecoration(
        border: ContainerProperty.mainBorder,
        color: AppColors.extraLightBlackColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [ContainerProperty.mainShadow],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoBox(
            color: const Color(0xFFFF6B6B),
            backgroundColor: const Color(0xFFFFE8E8),
            data: calories,
            label: "Calories",
            unit: "kcal",
            icon: LucideIcons.flame,
          ),
          _buildInfoBox(
            color: const Color(0xFFFFB347),
            backgroundColor: const Color(0xFFFFF4E6),
            data: fat,
            label: "Fat",
            unit: "g",
            icon: LucideIcons.droplet,
          ),
          _buildInfoBox(
            color: const Color(0xFF4ECDC4),
            backgroundColor: const Color(0xFFE8F8F7),
            data: carbs,
            label: "Carbs",
            unit: "g",
            icon: LucideIcons.wheat,
          ),
          _buildInfoBox(
            color: const Color(0xFF7BC950),
            backgroundColor: const Color(0xFFEDF7E8),
            data: fiber,
            label: "Fiber",
            unit: "g",
            icon: LucideIcons.leaf,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox({
    required Color color,
    required Color backgroundColor,
    required double data,
    required String label,
    required String unit,
    required IconData icon,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          '${data.toStringAsFixed(data.truncateToDouble() == data ? 0 : 1)}$unit',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
      ],
    );
  }
}
