import 'package:flutter/material.dart';

/// Widget for the save layout action in the AppBar
class SaveLayoutAction extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveLayoutAction({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: 'Save Layout',
      icon: const Icon(Icons.save),
    );
  }
}
