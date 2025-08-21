import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class DIYInboxCleanerScreen extends StatelessWidget {
  const DIYInboxCleanerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('DIY Inbox Cleaner (2025 Edition)'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go('/lab'),
          tooltip: 'Back to Lab',
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () => _copyFullPlan(context),
            tooltip: 'Copy Full Plan',
            icon: const Icon(Icons.copy),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Overview Card
            _buildProjectOverviewCard(),
            const SizedBox(height: 24),

            // Path to Follow Card
            _buildPathToFollowCard(),
            const SizedBox(height: 24),

            // Technologies Card
            _buildTechnologiesCard(),
            const SizedBox(height: 24),

            // Features Card
            _buildFeaturesCard(),
            const SizedBox(height: 24),

            // Copy Plan Button
            _buildCopyPlanButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectOverviewCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF4CAF50).withValues(alpha: 0.1),
              const Color(0xFF4CAF50).withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.email,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DIY Inbox Cleaner (2025 Edition)',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Project Status: Planned for 2025',
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color(0xFF4CAF50),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'A modern Flutter mobile application that empowers users to take full control of their Gmail inbox. It provides a secure, on-device solution for unsubscribing from unwanted mail and performing bulk deletions, all while prioritizing user privacy by using an offline-first approach and the latest in local data security. The project will leverage Flutter\'s new performance enhancements and explore AI-powered categorization to provide a superior user experience.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPathToFollowCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.route, color: const Color(0xFF4CAF50), size: 28),
                const SizedBox(width: 12),
                Text(
                  'Path to Follow',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildPathStep(1, 'Project Setup & Modern Authentication', [
              'Create a new Flutter project using the latest stable channel (e.g., Flutter 3.35+).',
              'Configure your Google Cloud Project with the Gmail API and OAuth 2.0 credentials, making sure to define clear, minimal access scopes.',
              'Implement the OAuth 2.0 flow using the google_sign_in package, ensuring a smooth, secure user login experience.',
              'Crucial Security Step: Use flutter_secure_storage immediately to store the user\'s refresh_token securely on the device\'s keychain (iOS) or keystore (Android). This is a non-negotiable best practice for protecting user data.',
            ]),
            _buildPathStep(2, 'Efficient API Integration & Data Sync', [
              'Use an efficient HTTP client like dio for API calls, as it offers better error handling and request interception.',
              'Innovative Approach: Instead of constantly polling the API for new emails (which is inefficient and hits rate limits), implement a push notification system.',
              'Use the Gmail API\'s users.watch endpoint to subscribe to real-time mailbox updates via Google Cloud Pub/Sub.',
              'When a new email arrives that meets your criteria, Google Cloud will send a notification to a webhook endpoint that your application can listen to. This allows your app to stay up-to-date without wasting resources.',
              'Fetch and parse email headers (sender, List-Unsubscribe header) and message IDs.',
              'Use a local database (e.g., isar or drift) to store the list of senders and message IDs. This provides a fast, offline-first experience and avoids redundant API calls.',
            ]),
            _buildPathStep(3, 'Core Functionality & AI-Powered Features', [
              'Unsubscribe: Programmatically trigger the unsubscribe action by either sending an email to the List-Unsubscribe email address or making an HTTP request to the List-Unsubscribe URL found in the email headers.',
              'Bulk Delete: Use the users.messages.batchDelete endpoint to efficiently remove a large number of emails from a single sender, permanently and at once.',
              'AI Integration (Optional but Highly Recommended):',
              '  • Leverage an AI model (possibly a lightweight, on-device one like TensorFlow Lite) to analyze email subjects and content to automatically categorize senders (e.g., "Newsletters," "Promotions," "Social Updates").',
              '  • This provides a much smarter and more user-friendly experience than simple rule-based grouping. The AI can learn from user behavior to improve its suggestions over time.',
            ]),
            _buildPathStep(4, 'Modern UI/UX Development', [
              'Build a responsive and performant UI using Flutter 3.35\'s Impeller rendering engine, which is now the default and provides smoother animations and less "jank."',
              'Create a clean dashboard that shows a summary of email categories and senders.',
              'Implement smooth, intuitive animations and transitions.',
              'Provide a secure, private, and delightful user experience that highlights the app\'s key value proposition: control and security.',
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildPathStep(int step, String title, List<String> details) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    step.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: details.map((detail) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 8, right: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          detail,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechnologiesCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.construction,
                  color: const Color(0xFF4CAF50),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Required Tools & Technologies',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTechnologySection('Core Framework', [
              'Flutter SDK (3.35+)',
            ], Icons.flutter_dash),
            _buildTechnologySection('Cloud Platform', [
              'Google Cloud Platform',
              'Gmail API',
              'Google Cloud Pub/Sub',
            ], Icons.cloud),
            _buildTechnologySection('Flutter Packages', [
              'google_sign_in: For authentication',
              'flutter_secure_storage: Essential for secure token storage',
              'dio: Robust HTTP client',
              'isar or drift: For efficient local data storage',
              'Optional: firebase_messaging (for Pub/Sub notifications)',
              'Optional: tflite_flutter (for on-device AI models)',
            ], Icons.inventory),
            _buildTechnologySection('Development Tools', [
              'Visual Studio Code or Android Studio',
            ], Icons.developer_mode),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnologySection(
    String title,
    List<String> items,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF4CAF50), size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.only(top: 8, right: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: const Color(0xFF4CAF50), size: 28),
                const SizedBox(width: 12),
                Text(
                  'Key Features',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children:
                  [
                        'Gmail API Integration',
                        'OAuth 2.0 Authentication',
                        'AI-Powered Categorization',
                        'Bulk Operations',
                        'Offline-First Approach',
                        'Secure Storage',
                        'Push Notifications',
                        'Real-time Updates',
                        'Privacy-Focused',
                        'Cross-Platform',
                      ]
                      .map(
                        (feature) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF4CAF50,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(
                                0xFF4CAF50,
                              ).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            feature,
                            style: TextStyle(
                              color: const Color(0xFF4CAF50),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCopyPlanButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => _copyFullPlan(context),
        icon: const Icon(Icons.copy),
        label: const Text('Copy Full Project Plan'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
    );
  }

  void _copyFullPlan(BuildContext context) {
    final fullPlan = _getFullProjectPlan();
    Clipboard.setData(ClipboardData(text: fullPlan));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Full project plan copied to clipboard!'),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  String _getFullProjectPlan() {
    return '''Project: DIY Inbox Cleaner (2025 Edition)

Description:
A modern Flutter mobile application that empowers users to take full control of their Gmail inbox. It provides a secure, on-device solution for unsubscribing from unwanted mail and performing bulk deletions, all while prioritizing user privacy by using an offline-first approach and the latest in local data security. The project will leverage Flutter's new performance enhancements and explore AI-powered categorization to provide a superior user experience.

Path to Follow:

Project Setup & Modern Authentication:

Create a new Flutter project using the latest stable channel (e.g., Flutter 3.35+).

Configure your Google Cloud Project with the Gmail API and OAuth 2.0 credentials, making sure to define clear, minimal access scopes.

Implement the OAuth 2.0 flow using the google_sign_in package, ensuring a smooth, secure user login experience.

Crucial Security Step: Use flutter_secure_storage immediately to store the user's refresh_token securely on the device's keychain (iOS) or keystore (Android). This is a non-negotiable best practice for protecting user data.

Efficient API Integration & Data Sync:

Use an efficient HTTP client like dio for API calls, as it offers better error handling and request interception.

Innovative Approach: Instead of constantly polling the API for new emails (which is inefficient and hits rate limits), implement a push notification system.

Use the Gmail API's users.watch endpoint to subscribe to real-time mailbox updates via Google Cloud Pub/Sub.

When a new email arrives that meets your criteria, Google Cloud will send a notification to a webhook endpoint that your application can listen to. This allows your app to stay up-to-date without wasting resources.

Fetch and parse email headers (sender, List-Unsubscribe header) and message IDs.

Use a local database (e.g., isar or drift) to store the list of senders and message IDs. This provides a fast, offline-first experience and avoids redundant API calls.

Core Functionality & AI-Powered Features:

Unsubscribe: Programmatically trigger the unsubscribe action by either sending an email to the List-Unsubscribe email address or making an HTTP request to the List-Unsubscribe URL found in the email headers.

Bulk Delete: Use the users.messages.batchDelete endpoint to efficiently remove a large number of emails from a single sender, permanently and at once.

AI Integration (Optional but Highly Recommended):

Leverage an AI model (possibly a lightweight, on-device one like TensorFlow Lite) to analyze email subjects and content to automatically categorize senders (e.g., "Newsletters," "Promotions," "Social Updates").

This provides a much smarter and more user-friendly experience than simple rule-based grouping. The AI can learn from user behavior to improve its suggestions over time.

Modern UI/UX Development:

Build a responsive and performant UI using Flutter 3.35's Impeller rendering engine, which is now the default and provides smoother animations and less "jank."

Create a clean dashboard that shows a summary of email categories and senders.

Implement smooth, intuitive animations and transitions.

Provide a secure, private, and delightful user experience that highlights the app's key value proposition: control and security.

Required Tools & Technologies:

Flutter SDK (3.35+): The framework.

Google Cloud Platform: For project setup, Gmail API, and Google Cloud Pub/Sub.

Flutter Packages:

google_sign_in: For authentication.

flutter_secure_storage: Essential for secure token storage.

dio: Robust HTTP client.

isar or drift: For efficient local data storage.

Optional: firebase_messaging (if you want to use Firebase to handle the Pub/Sub notifications), tflite_flutter (for on-device AI models).

IDE: Visual Studio Code or Android Studio.''';
  }
}
