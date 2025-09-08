import 'package:flutter/material.dart';
import '../../theme/portfolio_theme.dart';

import '../../pages/portfolio_screen.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final browserHeight = MediaQuery.of(context).size.height;
    final browserWidth = MediaQuery.of(context).size.width;

    Widget blackLeftContainer() {
      return Container(
        height: browserHeight,
        width: browserWidth / 2,
        color: PortfolioTheme.bgColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PortfolioV2Screen.horizontalPadding,
            vertical: 22,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 10),
              Text("-Hello", style: PortfolioTheme.manropeRegular24),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "I'm ",
                      style: PortfolioTheme.monotonRegular48.copyWith(
                        height: 0.89,
                      ),
                    ),
                    TextSpan(
                      text: "Camilo",
                      style: PortfolioTheme.monotonRegular48.copyWith(
                        color: PortfolioTheme.orangeColor,
                        decoration: TextDecoration.underline,
                        decorationColor: PortfolioTheme.orangeColor,
                        decorationThickness: 0.7,
                      ),
                    ),
                    TextSpan(
                      text: ",\nmobile developer",
                      style: PortfolioTheme.monotonRegular48.copyWith(
                        height: 0.89,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget whiteRightContainer() {
      return Container(
        height: browserHeight,
        width: browserWidth / 2,
        color: PortfolioTheme.grayColor,
      );
    }

    return Row(children: [blackLeftContainer(), whiteRightContainer()]);
  }
}
