// NOTE: Navigation is now handled by B4SDemoNavigationShell. Use FieldScreen only for the field UI.
import 'package:flutter/material.dart';
import '../b4s_colors.dart';
import 'package:intl/intl.dart';
import 'package:portfolio_web/core/l10n/app_localizations.dart';
import '../widgets/field_flag.dart';
import 'dart:math';
import '../widgets/b4s_popup.dart';
import '../widgets/b4s_custom_appbar.dart';

class FieldScreen extends StatefulWidget {
  const FieldScreen({super.key});

  @override
  State<FieldScreen> createState() => _FieldScreenState();
}

class _FieldScreenState extends State<FieldScreen> {
  int _selectedWeek = 0; // 0-based index for 'Fecha'
  Widget? _popup;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedWeek = ((now.day - 1) ~/ 7).clamp(0, 4);
  }

  void _showPopup(Widget popup) {
    setState(() {
      _popup = popup;
    });
  }

  void _dismissPopup() {
    setState(() {
      _popup = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String monthTitle = DateFormat.MMMM(
      Localizations.localeOf(context).toString(),
    ).format(DateTime.now());
    return Stack(
      children: [
        FieldMainScreen(
          monthTitle: monthTitle,
          l10n: l10n,
          selectedWeek: _selectedWeek,
          onWeekChanged: (week) => setState(() => _selectedWeek = week),
          showPopup: _showPopup,
          dismissPopup: _dismissPopup,
        ),
        if (_popup != null)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.45),
              child: Center(child: _popup),
            ),
          ),
      ],
    );
  }
}

class FieldMainScreen extends StatelessWidget {
  final String monthTitle;
  final AppLocalizations l10n;
  final int selectedWeek;
  final ValueChanged<int> onWeekChanged;
  final void Function(Widget) showPopup;
  final VoidCallback dismissPopup;

  const FieldMainScreen({
    super.key,
    required this.monthTitle,
    required this.l10n,
    required this.selectedWeek,
    required this.onWeekChanged,
    required this.showPopup,
    required this.dismissPopup,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: B4SCustomAppBar(
        title: monthTitle,
        showBackButton: true,
        showIcons: true,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: B4SDemoColors.gradientRegisterDetailView,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 15.0,
                    bottom: 8.0,
                  ),
                  child: Text(
                    l10n.fieldScreenPrepareTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _FieldView(
                  selectedWeek: selectedWeek,
                  showPopup: showPopup,
                  dismissPopup: dismissPopup,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildWeekNavigator(context),
    );
  }

  Widget _buildWeekNavigator(BuildContext context) {
    final weekTitles = [
      l10n.week1Label,
      l10n.week2Label,
      l10n.week3Label,
      l10n.week4Label,
      l10n.week5Label,
    ];
    return Container(
      height: 54,
      width: double.infinity,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.zero,
        boxShadow: [],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (selectedWeek != 0)
            IconButton(
              icon: Icon(Icons.arrow_back_ios, color: B4SDemoColors.buttonRed),
              onPressed: () => onWeekChanged(selectedWeek - 1),
            )
          else
            const SizedBox(width: 48),
          Text(
            weekTitles[selectedWeek],
            style: TextStyle(
              color: B4SDemoColors.buttonRed,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          if (selectedWeek != 4)
            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                color: B4SDemoColors.buttonRed,
              ),
              onPressed: () => onWeekChanged(selectedWeek + 1),
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _FieldView extends StatefulWidget {
  final int selectedWeek;
  final void Function(Widget) showPopup;
  final VoidCallback dismissPopup;
  const _FieldView({
    required this.selectedWeek,
    required this.showPopup,
    required this.dismissPopup,
  });

  @override
  State<_FieldView> createState() => _FieldViewState();
}

class _FieldViewState extends State<_FieldView> {
  late Map<int, List<int>> _weekPercentages;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final currentWeek = ((now.day - 1) ~/ 7).clamp(0, 4);
    _weekPercentages = {};
    for (int week = 0; week < 5; week++) {
      final random = Random(week + 42);
      _weekPercentages[week] = List.generate(5, (_) => random.nextInt(101));
    }
    // If current week, set previous days to 100%
    if (widget.selectedWeek == currentWeek) {
      final currentWeekday = now.weekday.clamp(1, 5) - 1;
      for (int i = 0; i < currentWeekday; i++) {
        _weekPercentages[currentWeek]![i] = 100;
      }
    }
  }

  void _showPopup(Widget popup) {
    widget.showPopup(popup);
  }

  void _dismissPopup() {
    widget.dismissPopup();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            _buildFieldBackground(),
            ..._buildFlagWidgets(context, widget.selectedWeek),
          ],
        );
      },
    );
  }

  Widget _buildFieldBackground() {
    return Positioned.fill(
      child: Image.asset('assets/demos/b4s/field.png', fit: BoxFit.cover),
    );
  }

  List<Widget> _buildFlagWidgets(BuildContext context, int selectedWeek) {
    final l10n = AppLocalizations.of(context)!;
    final labels = [
      l10n.preEmotionalLabel, // Monday
      l10n.planLabel, // Tuesday
      l10n.matchLabel, // Friday/weekend (center)
      l10n.postEmotionalLabel, // Wednesday
      l10n.selfEvaluationLabel, // Thursday
    ];
    final now = DateTime.now();
    final currentWeek = ((now.day - 1) ~/ 7).clamp(0, 4);
    final weekday = now.weekday; // 1=Mon, ..., 7=Sun
    // Map flags to days: 0=Mon, 1=Tue, 3=Wed, 4=Thu, 2=Fri/weekend
    int todayIndex;
    if (weekday >= 5) {
      todayIndex = 2; // Center flag for Fri/Sat/Sun
    } else if (weekday == 1) {
      todayIndex = 0;
    } else if (weekday == 2) {
      todayIndex = 1;
    } else if (weekday == 3) {
      todayIndex = 3;
    } else {
      todayIndex = 4;
    }
    final percentages = _weekPercentages[selectedWeek]!;
    return List.generate(5, (i) {
      return _buildFlagPositioned(
        context: context,
        index: i,
        selectedWeek: selectedWeek,
        currentWeek: currentWeek,
        todayIndex: todayIndex,
        percentages: percentages,
        labels: labels,
        weekday: weekday,
      );
    });
  }

  Widget _buildFlagPositioned({
    required BuildContext context,
    required int index,
    required int selectedWeek,
    required int currentWeek,
    required int todayIndex,
    required List<int> percentages,
    required List<String> labels,
    required int weekday,
  }) {
    final isCenter = index == 2;
    final isToday = selectedWeek == currentWeek && index == todayIndex;
    final flagData = _getFlagData(
      context: context,
      index: index,
      selectedWeek: selectedWeek,
      currentWeek: currentWeek,
      todayIndex: todayIndex,
      percentages: percentages,
      weekday: weekday,
    );
    Widget flag = GestureDetector(
      onTap: flagData['onTap'],
      child: FieldFlag(
        label: labels[index],
        flagAsset: flagData['flagAsset'],
        percent: flagData['percent'],
        isToday: isToday,
        isCenter: isCenter,
        isActive: flagData['isActive'],
        height: 64,
        width: 44,
      ),
    );
    if (index == 0) {
      return Positioned(top: 0, left: 0, child: flag);
    } else if (index == 1) {
      return Positioned(top: 0, right: 0, child: flag);
    } else if (index == 2) {
      return Positioned(top: 100, left: 0, right: 0, child: flag);
    } else if (index == 3) {
      return Positioned(bottom: 0, left: 0, child: flag);
    } else {
      return Positioned(bottom: 0, right: 0, child: flag);
    }
  }

  Map<String, dynamic> _getFlagData({
    required BuildContext context,
    required int index,
    required int selectedWeek,
    required int currentWeek,
    required int todayIndex,
    required List<int> percentages,
    required int weekday,
  }) {
    int percent = percentages[index];
    bool isActive = false;
    String flagAsset = 'assets/demos/b4s/gray_flag.png';
    VoidCallback? onTap;
    if (selectedWeek < currentWeek) {
      // Past weeks: all flags active as before
      isActive = true;
      flagAsset =
          percent == 100
              ? 'assets/demos/b4s/green_flag.png'
              : percent >= 50
              ? 'assets/demos/b4s/yellow_flag.png'
              : percent > 0
              ? 'assets/demos/b4s/red_flag.png'
              : 'assets/demos/b4s/gray_flag.png';
      onTap = () => _handlePastWeekFlagTap(flagAsset, index);
    } else if (selectedWeek == currentWeek) {
      // Center flag (index 2) only active on Fri/Sat/Sun
      if (index == 2) {
        if (weekday >= 5) {
          // Friday or weekend
          if (todayIndex == 2) {
            isActive = true;
            flagAsset =
                percent == 100
                    ? 'assets/demos/b4s/green_flag.png'
                    : percent >= 50
                    ? 'assets/demos/b4s/yellow_flag.png'
                    : percent > 0
                    ? 'assets/demos/b4s/red_flag.png'
                    : 'assets/demos/b4s/gray_flag.png';
            onTap = () => _handleCurrentDayFlagTap(flagAsset, index);
          } else if (todayIndex > 2) {
            // After center flag day, mark as completed
            percent = 100;
            isActive = true;
            flagAsset = 'assets/demos/b4s/green_flag.png';
            onTap = () => _showTaskCompletedDialog();
          } else {
            // Not yet active
            percent = 0;
            isActive = false;
            flagAsset = 'assets/demos/b4s/gray_flag.png';
            onTap = () => _showCenterFlagInactiveDialog();
          }
        } else {
          // Not Friday or weekend
          percent = 0;
          isActive = false;
          flagAsset = 'assets/demos/b4s/gray_flag.png';
          onTap = () => _showCenterFlagInactiveDialog();
        }
      } else if (index < todayIndex && index != 2) {
        // Previous flags (not center)
        percent = 100;
        isActive = true;
        flagAsset = 'assets/demos/b4s/green_flag.png';
        onTap = () => _showTaskCompletedDialog();
      } else if (index == todayIndex && index != 2) {
        isActive = true;
        flagAsset =
            percent == 100
                ? 'assets/demos/b4s/green_flag.png'
                : percent >= 50
                ? 'assets/demos/b4s/yellow_flag.png'
                : percent > 0
                ? 'assets/demos/b4s/red_flag.png'
                : 'assets/demos/b4s/gray_flag.png';
        onTap = () => _handleCurrentDayFlagTap(flagAsset, index);
      } else {
        percent = 0;
        isActive = false;
        flagAsset = 'assets/demos/b4s/gray_flag.png';
        onTap = () => _showCurrentWeekInactiveDialog(index, todayIndex);
      }
    } else {
      percent = 0;
      isActive = false;
      flagAsset = 'assets/demos/b4s/gray_flag.png';
      onTap = () => _showFutureWeekInactiveDialog(selectedWeek, currentWeek);
    }
    return {
      'percent': percent,
      'isActive': isActive,
      'flagAsset': flagAsset,
      'onTap': onTap,
    };
  }

  void _handlePastWeekFlagTap(String flagAsset, [int? flagIndex]) {
    if (flagAsset.contains('green_flag')) {
      _showTaskCompletedDialog();
    } else if (flagAsset.contains('red_flag')) {
      _showRedFlagDialog(flagIndex);
    } else if (flagAsset.contains('yellow_flag')) {
      _showYellowFlagDialog(flagIndex);
    } else {
      _showPastWeekDialog();
    }
  }

  void _handleCurrentDayFlagTap(String flagAsset, [int? flagIndex]) {
    if (flagAsset.contains('green_flag')) {
      _showTaskCompletedDialog();
    } else if (flagAsset.contains('red_flag')) {
      _showRedFlagDialog(flagIndex);
    } else if (flagAsset.contains('yellow_flag')) {
      _showYellowFlagDialog(flagIndex);
    } else {
      _showPastWeekDialog();
    }
  }

  void _showTaskCompletedDialog() {
    _showPopup(
      B4SPopup(
        title: 'Huray!',
        content: Text(AppLocalizations.of(context)!.popupTaskCompleted),
        actions: [TextButton(onPressed: _dismissPopup, child: Text('OK'))],
      ),
    );
  }

  void _showRedFlagDialog([int? flagIndex]) {
    int sliderValue = 1;
    _showPopup(
      InteractiveB4SPopup(
        title: AppLocalizations.of(context)!.popupNewTaskAssigned,
        content: Text(AppLocalizations.of(context)!.popupDribblingQuestion),
        actions: [TextButton(onPressed: _dismissPopup, child: Text('OK'))],
        builder: (context, onComplete) {
          return StatefulBuilder(
            builder:
                (context, setState) => Column(
                  children: [
                    Slider(
                      value: sliderValue.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: sliderValue.toString(),
                      onChanged: (value) {
                        setState(() => sliderValue = value.round());
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (!mounted) return;
                          _dismissPopup();
                          if (flagIndex != null) {
                            setState(() {
                              _weekPercentages[widget
                                      .selectedWeek]![flagIndex] =
                                  100;
                            });
                          }
                          _showTaskCompletedDialog();
                        });
                      },
                    ),
                  ],
                ),
          );
        },
      ),
    );
  }

  void _showYellowFlagDialog([int? flagIndex]) {
    int sliderValue1 = 1;
    int sliderValue2 = 1;
    _showPopup(
      InteractiveB4SPopup(
        title: AppLocalizations.of(context)!.popupNewTaskAssigned,
        content: SizedBox.shrink(),
        actions: [TextButton(onPressed: _dismissPopup, child: Text('OK'))],
        builder: (context, onComplete) {
          return StatefulBuilder(
            builder:
                (context, setState) => Column(
                  children: [
                    Text(AppLocalizations.of(context)!.popupDribblingQuestion),
                    Slider(
                      value: sliderValue1.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: sliderValue1.toString(),
                      onChanged: (value) {
                        setState(() => sliderValue1 = value.round());
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (!mounted) return;
                          _dismissPopup();
                          if (flagIndex != null) {
                            setState(() {
                              _weekPercentages[widget
                                      .selectedWeek]![flagIndex] =
                                  100;
                            });
                          }
                          _showTaskCompletedDialog();
                        });
                      },
                    ),
                    Text(AppLocalizations.of(context)!.popupPassingQuestion),
                    Slider(
                      value: sliderValue2.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: sliderValue2.toString(),
                      onChanged: (value) {
                        setState(() => sliderValue2 = value.round());
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (!mounted) return;
                          _dismissPopup();
                          if (flagIndex != null) {
                            setState(() {
                              _weekPercentages[widget
                                      .selectedWeek]![flagIndex] =
                                  100;
                            });
                          }
                          _showTaskCompletedDialog();
                        });
                      },
                    ),
                  ],
                ),
          );
        },
      ),
    );
  }

  void _showPastWeekDialog() {
    _showPopup(
      B4SPopup(
        title: AppLocalizations.of(context)!.popupPastWeekTitle,
        content: Text(AppLocalizations.of(context)!.popupPastWeekContent),
        actions: [TextButton(onPressed: _dismissPopup, child: Text('OK'))],
      ),
    );
  }

  void _showCurrentWeekInactiveDialog(int index, int todayIndex) {
    final diff = index - todayIndex;
    final when = formatDaysMessage(context, diff);
    final contentText = AppLocalizations.of(
      context,
    )!.popupCurrentWeekContent(when);
    _showPopup(
      B4SPopup(
        title: AppLocalizations.of(context)!.popupCurrentWeekTitle,
        content: Text(contentText),
        actions: [TextButton(onPressed: _dismissPopup, child: Text('OK'))],
      ),
    );
  }

  void _showFutureWeekInactiveDialog(int selectedWeek, int currentWeek) {
    final diff = selectedWeek - currentWeek;
    final when = formatWeeksMessage(context, diff);
    final isSpecial =
        when == AppLocalizations.of(context)!.popupNextWeek ||
        when == AppLocalizations.of(context)!.popupLastWeek;
    final contentText =
        isSpecial
            ? AppLocalizations.of(context)!.popupFutureWeekContentSpecial(when)
            : AppLocalizations.of(context)!.popupFutureWeekContent(when);
    _showPopup(
      B4SPopup(
        title: AppLocalizations.of(context)!.popupFutureWeekTitle,
        content: Text(contentText),
        actions: [TextButton(onPressed: _dismissPopup, child: Text('OK'))],
      ),
    );
  }

  void _showCenterFlagInactiveDialog() {
    _showPopup(
      B4SPopup(
        title: AppLocalizations.of(context)!.popupFutureWeekTitle,
        content: Text('This flag will be active on Friday and the weekend.'),
        actions: [TextButton(onPressed: _dismissPopup, child: Text('OK'))],
      ),
    );
  }

  String formatWeeksMessage(BuildContext context, int diff) {
    if (diff == 1) return AppLocalizations.of(context)!.popupNextWeek;
    if (diff == -1) return AppLocalizations.of(context)!.popupLastWeek;
    if (diff.abs() > 1)
      return AppLocalizations.of(context)!.popupInXWeeks(diff.abs());
    return '';
  }

  String formatDaysMessage(BuildContext context, int diff) {
    if (diff == 1) return AppLocalizations.of(context)!.popupTomorrow;
    if (diff == -1) return AppLocalizations.of(context)!.popupYesterday;
    if (diff.abs() > 1)
      return AppLocalizations.of(context)!.popupInXDays(diff.abs());
    return '';
  }
}
