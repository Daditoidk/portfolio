import 'package:flutter/material.dart';
import '../b4s_colors.dart';
import 'static_top_appbar_lines.dart';
import 'b4s_popup.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio_web/core/l10n/app_localizations.dart';

const b4SCustomAppBarTitleStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 18,
);

typedef ShowPopupCallback = void Function(Widget popup);

class B4SCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showIcons;
  final PreferredSizeWidget? bottom;
  final TextStyle? titleStyle;
  final Widget? actionIcon;
  final ShowPopupCallback? showPopup;

  const B4SCustomAppBar({
    super.key,
    this.title = '',
    this.showBackButton = true,
    this.showIcons = true,
    this.bottom,
    this.titleStyle,
    this.actionIcon,
    this.showPopup,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    void showUnavailablePopup({VoidCallback? onOk}) {
      final popup = B4SPopup(
        title: l10n.profilePopupTitle,
        content: Text(l10n.profilePopupContent),
        actions: [
          TextButton(onPressed: onOk, child: Text(l10n.profilePopupOk)),
        ],
      );
      if (showPopup != null) {
        showPopup!(popup);
      }
    }
    Widget child = Container(
      decoration: BoxDecoration(
        color: const Color(0xff676767),
        border: const Border(
          bottom: BorderSide(color: Colors.white54, width: 0.5),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: [
          Positioned(top: -180, right: -320, child: StaticAppBarInnerLineTop()),
          Positioned(top: -320, right: -440, child: StaticAppBarOuterLineTop()),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(top: kToolbarHeight, bottom: 0.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (showBackButton)
                      BackButton(color: B4SDemoColors.buttonWhite),
                    if (!showBackButton) SizedBox(width: 16),

                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        title,
                        style: titleStyle ?? b4SCustomAppBarTitleStyle,
                      ),
                    ),
                    Spacer(),
                    // Shield icon with value
                    if (showIcons)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: showUnavailablePopup,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/demos/b4s/shieldStar.svg',
                                height: 22,
                                width: 22,
                                colorFilter: ColorFilter.mode(
                                  Color(0xFF00CD9C),
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: 2),
                              Text(
                                '2',
                                style: TextStyle(
                                  color: Color(0xFF00CD9C),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (showIcons)
                      // Fire icon with value
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: showUnavailablePopup,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/demos/b4s/fire.svg',
                                height: 22,
                                width: 22,
                              ),
                              SizedBox(width: 2),
                              Text(
                                '2',
                                style: TextStyle(
                                  color: Color(0xFFFFA726),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (showIcons)
                      // Bell icon with badge
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0, left: 8.0),
                        child: GestureDetector(
                          onTap: showUnavailablePopup,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              SvgPicture.asset(
                                'assets/demos/b4s/bell.svg',
                                height: 22,
                                width: 22,
                              ),
                              Positioned(
                                right: -6,
                                top: -6,
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 20,
                                    minHeight: 20,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '2',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (actionIcon != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                        child: GestureDetector(
                          onTap: showUnavailablePopup,
                          child: actionIcon,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [child, if (bottom != null) bottom!],
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 100);
}
