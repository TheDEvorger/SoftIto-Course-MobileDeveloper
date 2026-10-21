import 'package:flutter/material.dart';
import '../shared/design/workspace_notice.dart';

class MobilityShell extends StatelessWidget {
  const MobilityShell(
      {super.key,
      required this.pages,
      required this.index,
      required this.onSelected,
      this.examples = false,
      this.switching = false,
      this.connectionError,
      this.onRetry,
      required this.connected});
  final List<Widget> pages;
  final int index;
  final ValueChanged<int> onSelected;
  final bool connected;
  final bool examples, switching;
  final String? connectionError;
  final VoidCallback? onRetry;
  static const _items = [
    (Icons.explore_outlined, 'Keşfet'),
    (Icons.directions_car_outlined, 'Araçlar'),
    (Icons.event_note_outlined, 'Sürüşlerim'),
    (Icons.tune_outlined, 'Hesabım'),
  ];

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        final wide = constraints.maxWidth >= 1000 &&
            MediaQuery.textScalerOf(context).scale(1) < 1.4;
        final colors = Theme.of(context).colorScheme;
        return Scaffold(
          body: SafeArea(
              child: Column(children: [
            Container(
                decoration: BoxDecoration(
                    color: colors.surface,
                    border: Border(
                        bottom: BorderSide(color: colors.outlineVariant))),
                child: Center(
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1360),
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: wide ? 36 : 20, vertical: 18),
                            child: Row(children: [
                              Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                      color: colors.onSurface,
                                      borderRadius: BorderRadius.circular(11)),
                                  child: Icon(Icons.route_rounded,
                                      color: colors.surface, size: 21)),
                              const SizedBox(width: 12),
                              Expanded(
                                  flex: wide ? 0 : 1,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('PRECISION',
                                            style: TextStyle(
                                                fontSize: 14,
                                                letterSpacing: 2.4,
                                                fontWeight: FontWeight.w800,
                                                color: colors.onSurface)),
                                        Text('MOBILITY, REFINED.',
                                            style: TextStyle(
                                                fontSize: 8,
                                                letterSpacing: 1.8,
                                                color:
                                                    colors.onSurfaceVariant)),
                                      ])),
                              if (wide) ...[
                                const Spacer(),
                                for (var i = 0; i < _items.length; i++)
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      child: TextButton.icon(
                                          onPressed: () => onSelected(i),
                                          style: TextButton.styleFrom(
                                              backgroundColor: index == i
                                                  ? colors.primaryContainer
                                                  : Colors.transparent,
                                              foregroundColor: index == i
                                                  ? colors.onPrimaryContainer
                                                  : colors.onSurfaceVariant,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 18,
                                                      vertical: 16)),
                                          icon: Icon(_items[i].$1, size: 18),
                                          label: Text(_items[i].$2))),
                                const Spacer(),
                              ],
                              IconButton.filledTonal(
                                  onPressed: () => onSelected(3),
                                  tooltip: connected
                                      ? 'Çalışma alanı bağlı'
                                      : 'Çalışma alanına bağlan',
                                  icon: Icon(
                                      connected
                                          ? Icons.verified_user_outlined
                                          : Icons.key_outlined,
                                      size: 20)),
                            ]))))),
            WorkspaceNotice(
                examples: examples,
                loading: switching,
                error: connectionError,
                onAction:
                    connectionError != null ? onRetry! : () => onSelected(3)),
            Expanded(child: IndexedStack(index: index, children: pages)),
          ])),
          bottomNavigationBar: wide
              ? null
              : SafeArea(
                  top: false,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                      child: Container(
                          decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(color: colors.outlineVariant)),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(26),
                              child: NavigationBar(
                                selectedIndex: index,
                                onDestinationSelected: onSelected,
                                destinations: [
                                  for (final item in _items)
                                    NavigationDestination(
                                        icon: Icon(item.$1), label: item.$2)
                                ],
                              ))))),
        );
      });
}
