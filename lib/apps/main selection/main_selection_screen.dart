import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/navigation/app_router.dart';
import '../../core/l10n/app_localizations.dart';

class MainSelectionScreen extends StatelessWidget {
  const MainSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Welcome section at top
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Welcome Title
                    Text(
                      l10n.mainSelectionWelcome,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.mainSelectionSubtitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 60),

                    // Portfolio and Lab labels in a row - only labels centered
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Portfolio Label - fixed width
                        SizedBox(
                          width: 200, // Fixed width for both labels
                          child: GestureDetector(
                            onTap: () =>
                                context.goNamed(RouteNames.portfolio),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red[300]!),
                              ),
                              child: Text(
                                l10n.mainSelectionPortfolioTitle,
                                textAlign: TextAlign.center,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red[700],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 40),

                        // Lab Label - fixed width
                        SizedBox(
                          width: 200, // Same fixed width as Portfolio
                          child: GestureDetector(
                            onTap: () => context.goNamed(RouteNames.lab),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue[300]!),
                              ),
                              child: Text(
                                l10n.mainSelectionLabTitle,
                                textAlign: TextAlign.center,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Creator text in bottom right corner
          Positioned(
            bottom: 16,
            right: 16,
            child: Text(
              l10n.createdBy,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
