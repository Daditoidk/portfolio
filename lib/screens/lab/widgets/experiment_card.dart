import 'package:flutter/material.dart';
import '../core/models/experiment.dart';

/// Card widget for displaying an experiment in the grid
class ExperimentCard extends StatelessWidget {
  final Experiment experiment;
  final VoidCallback? onTap;
  final bool showStatus;

  const ExperimentCard({
    super.key,
    required this.experiment,
    this.onTap,
    this.showStatus = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 280, // Fixed height for consistent grid
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Section: Image/Placeholder with Status Tags Overlay
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: experiment.displayColor.withValues(alpha: 0.8),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Stack(
                  children: [
                    // Background Image or Icon
                    experiment.imagePath != null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Stack(
                              children: [
                                Image.asset(
                                  experiment.imagePath!,
                                  fit: BoxFit.cover,
                                ),
                                // Dark gradient overlay
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0.3),
                                        Colors.black.withValues(alpha: 0.6),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: Icon(
                              _getIconForType(experiment.type),
                              size: 48,
                              color: Colors.white,
                            ),
                          ),

                    // Status Tags Overlay at Top
                    Positioned(
                      top: 8,
                      left: 8,
                      right: 8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Type badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: experiment.displayColor.withValues(
                                alpha: 0.9,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              experiment.typeText,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          // Status indicator
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: experiment.statusColor.withValues(
                                alpha: 0.9,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              experiment.statusText,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Middle Section: Title Bar
              Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(color: experiment.displayColor),
                child: Center(
                  child: Text(
                    experiment.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Bottom Section: Description Area
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      Expanded(
                        child: Text(
                          experiment.description,
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 14,
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Tags
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: experiment.tags.take(4).map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: experiment.displayColor.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: experiment.displayColor.withValues(
                                  alpha: 0.3,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                color: experiment.displayColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 8),

                      // Footer info - Removed duplicate badges since they're now at the top
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get appropriate icon for experiment type
  IconData _getIconForType(ExperimentType type) {
    switch (type) {
      case ExperimentType.tool:
        return Icons.build;
      case ExperimentType.editor:
        return Icons.edit;
      case ExperimentType.animation:
        return Icons.animation;
      case ExperimentType.widget:
        return Icons.widgets;
      case ExperimentType.brick:
        return Icons.construction;
      case ExperimentType.exception:
        return Icons.error_outline;
      case ExperimentType.ai:
        return Icons.psychology;
      case ExperimentType.other:
        return Icons.science;
    }
  }
}
