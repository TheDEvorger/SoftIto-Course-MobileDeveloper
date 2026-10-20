import 'package:flutter/material.dart';

/// App wiring injects the owner/fleet workspace without cross-feature imports.
class GarageScreen extends StatelessWidget {
  const GarageScreen({super.key, required this.workspace});
  final Widget workspace;
  @override
  Widget build(BuildContext context) => workspace;
}
