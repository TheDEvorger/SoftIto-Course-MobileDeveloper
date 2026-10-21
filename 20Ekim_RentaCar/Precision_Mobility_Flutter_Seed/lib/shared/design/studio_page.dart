import 'package:flutter/material.dart';

class StudioPage extends StatelessWidget {
  const StudioPage({super.key, required this.children, this.width = 1280});
  final List<Widget> children;
  final double width;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) => Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width),
              child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.all(constraints.maxWidth < 600 ? 20 : 36),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: children)))));
}

class StudioPanel extends StatelessWidget {
  const StudioPanel(
      {super.key, required this.child, this.padding = 24, this.color});
  final Widget child;
  final double padding;
  final Color? color;
  @override
  Widget build(BuildContext context) => Card(
      color: color,
      child: Padding(padding: EdgeInsets.all(padding), child: child));
}
