import 'package:flutter/material.dart';
import 'app/mobility_app.dart';

/// Optional historical operator workspace. The normal app is serverless.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MobilityApp());
}
