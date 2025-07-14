import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet, desktop }

DeviceType getDeviceType(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width >= 1024) return DeviceType.desktop;
  if (width >= 600) return DeviceType.tablet;
  return DeviceType.mobile;
}

class Responsive extends StatelessWidget {
  final Widget Function(BuildContext context) mobile;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context)? desktop;

  const Responsive({
    required this.mobile,
    this.tablet,
    this.desktop,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = getDeviceType(context);
    if (deviceType == DeviceType.desktop && desktop != null) {
      return desktop!(context);
    } else if (deviceType == DeviceType.tablet && tablet != null) {
      return tablet!(context);
    } else {
      return mobile(context);
    }
  }
}
