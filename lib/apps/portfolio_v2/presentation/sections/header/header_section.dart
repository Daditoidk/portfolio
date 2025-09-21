import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_web/apps/portfolio_v2/presentation/providers/scroll_providers.dart';
import '../../shared/components/custom_nav_bar_portfolio_v2.dart';
import '../../shared/widgets/reveal_from_animation.dart';
import '../../theme/portfolio_theme.dart';

import '../../pages/portfolio_screen.dart';

class HeaderSection extends ConsumerWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final browserSize = MediaQuery.of(context).size;
    final browserHeight = browserSize.height;

    return LayoutBuilder(
      builder: (context, constraints) {
        final browserWidth = constraints.maxWidth;
        final isSmall = browserWidth < 600;
        final isMedium = browserWidth < 1024;
        final useColumnLayout = isMedium || isSmall;

        double panelHeightBlack;
        double panelHeightWhite;

        if (useColumnLayout) {
          panelHeightBlack = browserHeight * 0.6;
          panelHeightWhite = browserHeight * 0.4;
        } else {
          panelHeightBlack = browserHeight;
          panelHeightWhite = browserHeight;
        }

        Widget blackLeftContainer(double width) {
          return Container(
            height: panelHeightBlack,
            width: width,
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
                  RevealOnScroll(
                    scrollController: ref.watch(scrollControllerProvider),
                    from: RevealFrom.left,
                    fadeDuration: Duration(milliseconds: 400),
                    staggerDelay: Duration(milliseconds: 400),
                    child:
                        Text(
                      "-Hello",
                      style: PortfolioTheme.manropeRegular24,
                    ),
                  ),
                  RevealOnScroll(
                    scrollController: ref.watch(scrollControllerProvider),
                    from: RevealFrom.left,
                    fadeDuration: Duration(milliseconds: 600),
                    staggerDelay: Duration(milliseconds: 600),
                    curve: Curves.easeInOutCirc,
                    child: RichText(
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
                  ),
                ],
              ),
            ),
          );
        }

        Widget whiteRightContainer(double width) {
          return Container(
            height: panelHeightWhite,
            width: width,
            color: PortfolioTheme.grayColor,
          );
        }

        final background = useColumnLayout
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: browserWidth,
                    child: whiteRightContainer(browserWidth),
                  ),
                  SizedBox(
                    width: browserWidth,
                    child: blackLeftContainer(browserWidth),
                  ),
                ],
              )
            : Row(
                children: [
                  blackLeftContainer(browserWidth / 2),
                  whiteRightContainer(browserWidth / 2),
                ],
              );

        final showNavBar = !isSmall && !isMedium;

        return Stack(
          children: [
            background,
            if (showNavBar)
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Row(
                  children: [
                    const Spacer(),
                    RevealOnScroll(
                      scrollController: ref.watch(scrollControllerProvider),
                      from: RevealFrom.center,
                      fadeDuration: Duration(milliseconds: 300),
                      staggerDelay: Duration(milliseconds: 300),
                      child: const CustomNavBarPortfolioV2(),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
