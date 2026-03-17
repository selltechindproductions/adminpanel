import 'package:flutter/cupertino.dart';

class ContentModel {
  final String name;
  final String healthStatus;
  final IconData icon;
  final void Function() onTap;

  ContentModel({
    required this.name,
    required this.healthStatus,
    required this.icon,
    required this.onTap,
  });
}
