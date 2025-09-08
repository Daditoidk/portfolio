import 'package:flutter/material.dart';

/// A widget that caches its child to prevent re-rendering
/// Uses AutomaticKeepAliveClientMixin to keep the widget alive
class CachedDemoWidget extends StatefulWidget {
  final Widget child;
  final int index;

  const CachedDemoWidget({super.key, required this.child, required this.index});

  @override
  State<CachedDemoWidget> createState() => _CachedDemoWidgetState();
}

class _CachedDemoWidgetState extends State<CachedDemoWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return widget.child;
  }
}
