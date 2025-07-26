import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../last_update.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/accessibility/accessibility_floating_button.dart';

class VersionInfo extends ConsumerWidget {
  final bool isMobile;
  final EdgeInsets? padding;

  const VersionInfo({super.key, this.isMobile = false, this.padding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final version = snapshot.data!.version;

        return Center(
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(vertical: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AccessibleText(
                  'Last update: $lastUpdate',
                  baseFontSize:
                      Theme.of(context).textTheme.bodySmall?.fontSize ?? 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
                AccessibleText(
                  'v$version',
                  baseFontSize:
                      Theme.of(context).textTheme.bodySmall?.fontSize ?? 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
