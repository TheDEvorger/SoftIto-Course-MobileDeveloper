import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precision_mobility/features/fleet/domain/demo_fleet_workspace.dart';
import 'package:precision_mobility/features/fleet/presentation/fleet_workspace_screen.dart';

void main() {
  test('roles, tenant and branch contexts gate mutations', () {
    final w = DemoFleetWorkspace();
    expect(w.visibleVehicles.length, 2);
    expect(() => w.toggleMaintenance('fleet-1'), throwsStateError);
    w.selectDemoRole(FleetDemoRole.operator);
    w.toggleMaintenance('fleet-1');
    expect(w.visibleVehicles.first.status, FleetVehicleStatus.maintenance);
    expect(() => w.toggleMaintenance('fleet-3'), throwsStateError);
    w.selectBranch('north-west');
    expect(w.visibleVehicles.single.id, 'fleet-2');
    expect(() => w.toggleMaintenance('fleet-1'), throwsStateError);
    expect(() => w.selectBranch('south-center'), throwsArgumentError);
    w.selectOrganization('south');
    expect(w.branchId, isNull);
    expect(w.role, FleetDemoRole.viewer);
    expect(w.visibleVehicles.single.id, 'fleet-3');
    expect(() => w.toggleMaintenance('fleet-3'), throwsStateError);
    expect(() => w.selectOrganization('unknown'), throwsArgumentError);
  });
  for (final width in [320.0, 1200.0]) {
    testWidgets('fleet $width adapts and roles control actions',
        (tester) async {
      tester.view.physicalSize = Size(width, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: FleetWorkspaceScreen())));
      expect(
          find.byType(DataTable), width >= 700 ? findsOneWidget : findsNothing);
      final action = find.byKey(const ValueKey('fleet-action-fleet-1'));
      expect(tester.widget<OutlinedButton>(action).onPressed, isNull);
      await tester.tap(find.byKey(const ValueKey('fleet-role-north')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Demo operatör').last);
      await tester.pumpAndSettle();
      await tester.ensureVisible(action);
      await tester.pumpAndSettle();
      expect(tester.widget<OutlinedButton>(action).onPressed, isNotNull);
      await tester.tap(action);
      await tester.pumpAndSettle();
      expect(find.text('Örnek bakımda'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('desktop Tab traversal and Enter activate fleet action',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final w = DemoFleetWorkspace()..selectDemoRole(FleetDemoRole.operator);
    await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: FleetWorkspaceScreen(workspace: w))));
    for (var i = 0; i < 4; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
    }
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(w.visibleVehicles.first.status, FleetVehicleStatus.maintenance);
    expect(find.text('Örnek bakımda'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
