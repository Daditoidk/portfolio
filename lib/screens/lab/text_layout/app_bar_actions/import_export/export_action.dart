import 'package:flutter/material.dart';

/// Widget for the export layout action in the AppBar
class ExportAction extends StatelessWidget {
  final bool canExport;
  final VoidCallback onPressed;
  final String tooltip;

  const ExportAction({
    super.key,
    required this.canExport,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: canExport ? onPressed : null,
      tooltip: tooltip,
      icon: const Icon(Icons.download),
    );
  }
}
