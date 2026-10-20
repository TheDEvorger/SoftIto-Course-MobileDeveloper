import 'package:flutter/material.dart';
import '../../app/theme/meheng_theme.dart';

class ResponsiveContentShell extends StatelessWidget {
  const ResponsiveContentShell({
    required this.child,
    this.maxWidth = MehengSpacing.maxContentWidth,
    super.key,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width < 600 ? MehengSpacing.md : MehengSpacing.lg;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: MehengSpacing.md,
          ),
          child: FocusTraversalGroup(
            policy: OrderedTraversalPolicy(),
            child: child,
          ),
        ),
      ),
    );
  }
}
