// No imports needed for this file

/// Represents a line in the text layout editor
class Line {
  final String id;
  final int order;
  final List<String> l10nKeys;
  final double height;
  final double yPosition;
  final double xPosition;
  final bool isResizing;
  final ResizeDirection? resizeDirection;

  const Line({
    required this.id,
    required this.order,
    required this.l10nKeys,
    required this.height,
    required this.yPosition,
    this.xPosition = 100.0,
    this.isResizing = false,
    this.resizeDirection,
  });

  /// Create a copy of this Line with updated values
  Line copyWith({
    String? id,
    int? order,
    List<String>? l10nKeys,
    double? height,
    double? yPosition,
    double? xPosition,
    bool? isResizing,
    ResizeDirection? resizeDirection,
  }) {
    return Line(
      id: id ?? this.id,
      order: order ?? this.order,
      l10nKeys: l10nKeys ?? this.l10nKeys,
      height: height ?? this.height,
      yPosition: yPosition ?? this.yPosition,
      xPosition: xPosition ?? this.xPosition,
      isResizing: isResizing ?? this.isResizing,
      resizeDirection: resizeDirection ?? this.resizeDirection,
    );
  }

  /// Check if this line overlaps with another line
  bool overlapsWith(Line other) {
    final thisTop = yPosition;
    final thisBottom = yPosition + height;
    final otherTop = other.yPosition;
    final otherBottom = other.yPosition + other.height;

    return !(thisBottom <= otherTop || thisTop >= otherBottom);
  }

  /// Get the distance to another line
  double distanceTo(Line other) {
    final thisCenter = yPosition + (height / 2);
    final otherCenter = other.yPosition + (other.height / 2);
    return (thisCenter - otherCenter).abs();
  }

  /// Check if this line is close enough to snap to another line
  bool canSnapTo(Line other, {double snapThreshold = 20.0}) {
    return distanceTo(other) <= snapThreshold;
  }

  /// Get the snap position when moving towards another line
  double getSnapPosition(Line other, double dragDirection) {
    if (dragDirection > 0) {
      // Dragging down - snap above the other line
      return other.yPosition - height - 5.0;
    } else {
      // Dragging up - snap below the other line
      return other.yPosition + other.height + 5.0;
    }
  }

  /// Convert to JSON for serialization
  Map<String, dynamic> toJson() => {
    'id': id,
    'order': order,
    'l10nKeys': l10nKeys,
    'height': height,
    'yPosition': yPosition,
    'xPosition': xPosition,
  };

  /// Create from JSON
  factory Line.fromJson(Map<String, dynamic> json) => Line(
    id: json['id'],
    order: json['order'],
    l10nKeys: List<String>.from(json['l10nKeys']),
    height: json['height'].toDouble(),
    yPosition: json['yPosition'].toDouble(),
    xPosition: json['xPosition']?.toDouble() ?? 100.0,
  );
}

/// Direction for resizing
enum ResizeDirection { top, bottom }
