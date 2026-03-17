import 'package:flutter/cupertino.dart';

class DashboardItem{
  final String title;
  final String value;
  final IconData icon;
  final String growthText;
  final double growthPercent;
  DashboardItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.growthText,
    required this.growthPercent
});
}