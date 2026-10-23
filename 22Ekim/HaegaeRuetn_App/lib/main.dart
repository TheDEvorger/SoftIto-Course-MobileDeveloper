import 'package:flutter/material.dart';

import 'app/hager_app.dart';
import 'core/data/local_realm_store.dart';
import 'core/state/realm_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = RealmController(LocalRealmStore());
  await controller.initialize();
  runApp(HagerApp(controller: controller));
}
