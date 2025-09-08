import 'package:flutter/material.dart';

/// Widget for the import layout action in the AppBar
class ImportAction extends StatelessWidget {
  final VoidCallback onPressed;

  const ImportAction({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: 'Import Layout from JSON',
      icon: const Icon(Icons.upload),
    );
  }
}
