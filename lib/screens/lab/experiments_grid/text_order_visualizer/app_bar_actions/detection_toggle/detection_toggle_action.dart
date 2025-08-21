import 'package:flutter/material.dart';

/// Widget for the detection toggle in the AppBar
class DetectionToggleAction extends StatelessWidget {
  final bool isDetectionEnabled;
  final bool hasDetectedTexts;
  final int linesWithTextsCount;
  final String debugTooltip;
  final ValueChanged<bool> onChanged;

  const DetectionToggleAction({
    super.key,
    required this.isDetectionEnabled,
    required this.hasDetectedTexts,
    required this.linesWithTextsCount,
    required this.debugTooltip,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Detection', style: TextStyle(fontSize: 12)),
          const SizedBox(width: 8),
          Switch(
            value: isDetectionEnabled,
            onChanged: onChanged,
            activeColor: Colors.green,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          const SizedBox(width: 8),
          // Detection status indicator
          if (isDetectionEnabled)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: hasDetectedTexts
                    ? Colors.green.withValues(alpha: 0.2)
                    : Colors.orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: hasDetectedTexts ? Colors.green : Colors.orange,
                  width: 1,
                ),
              ),
              child: Tooltip(
                message: debugTooltip,
                child: Text(
                  hasDetectedTexts
                      ? '$linesWithTextsCount lines'
                      : 'Scanning...',
                  style: TextStyle(
                    color: hasDetectedTexts ? Colors.green : Colors.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
