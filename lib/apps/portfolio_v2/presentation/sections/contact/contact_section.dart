import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/portfolio_theme.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Ready to ',
                  style: PortfolioTheme.monotonRegular100,
                  children: [
                    WidgetSpan(
                      child: ShaderMask(
                        shaderCallback: (bounds) =>
                            PortfolioTheme.createGradient.createShader(bounds),
                        child: Text(
                          'create',
                          style: PortfolioTheme.monotonRegular100.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    TextSpan(
                      text: '?',
                      style: PortfolioTheme.monotonRegular100,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 65),
              Text('Drop me an email', style: PortfolioTheme.manropeRegular24),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(
                    const ClipboardData(text: 'kamiomg99@gmail.com'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Email copied to clipboard!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Text(
                  'kamiomg99@gmail.com',
                  style: PortfolioTheme.manropeBold24,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('@2025', style: PortfolioTheme.manropeRegular20),
              Text('GITHUB', style: PortfolioTheme.manropeRegular20),
              Text('LINKEDIN', style: PortfolioTheme.manropeRegular20),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
    );
  }
}
