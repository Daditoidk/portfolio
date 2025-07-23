import 'package:flutter/material.dart';

const Color b4sButtonColor = Color(0xffD51118);
const Color b4sModalsBackgroundColor = Color(0xffFFFFFF);

class B4SPopup extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;
  final Widget? customChild;

  const B4SPopup({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
    this.customChild,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          title.isNotEmpty
              ? Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              )
              : null,
      content: customChild ?? content,
      insetPadding: const EdgeInsets.all(4),
      actions:
          actions
              .map(
                (action) => Theme(
                  data: Theme.of(context).copyWith(
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: b4sButtonColor,
                      ),
                    ),
                  ),
                  child: action,
                ),
              )
              .toList(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: b4sModalsBackgroundColor,
      elevation: 8,
    );
  }
}

class InteractiveB4SPopup extends StatefulWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;
  final Widget Function(BuildContext, void Function()) builder;

  const InteractiveB4SPopup({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
    required this.builder,
  });

  @override
  State<InteractiveB4SPopup> createState() => _InteractiveB4SPopupState();
}

class _InteractiveB4SPopupState extends State<InteractiveB4SPopup> {
  void _onComplete() {
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          widget.title.isNotEmpty
              ? Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
              : null,
      insetPadding: const EdgeInsets.all(2),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.content,
          const SizedBox(height: 16),
          widget.builder(context, _onComplete),
        ],
      ),
      actions:
          widget.actions
              .map(
                (action) => Theme(
                  data: Theme.of(context).copyWith(
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: b4sButtonColor,
                      ),
                    ),
                  ),
                  child: action,
                ),
              )
              .toList(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: b4sModalsBackgroundColor,
      elevation: 8,
    );
  }
}
