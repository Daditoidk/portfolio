import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../last_update.dart';

class VersionInfo extends StatelessWidget {
  final bool isMobile;
  final EdgeInsets? padding;

  const VersionInfo({super.key, this.isMobile = false, this.padding});

  @override
  Widget build(BuildContext context) {
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
                Text(
                  'Last update: $lastUpdate',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'v$version',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
