import 'package:flutter/material.dart';
import '../b4s_colors.dart';
import 'package:intl/intl.dart';
import 'package:portfolio_web/core/l10n/app_localizations.dart';
import 'field_flag.dart';
import 'dart:math';
import 'b4s_popup.dart';
import 'package:portfolio_web/screens/portfolio/sections/projects section/demos/b4s_demo/widgets/b4s_custom_appbar.dart';

class FieldScreen extends StatefulWidget {
  const FieldScreen({super.key});

  @override
  State<FieldScreen> createState() => _FieldScreenState();
}

class _FieldScreenState extends State<FieldScreen> {
  int _currentIndex = 0;
  int _selectedWeek = 0; // 0-based index for 'Fecha'
  static const int _maxWeeks = 5;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedWeek = ((now.day - 1) ~/ 7).clamp(0, 4);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String monthTitle = DateFormat.MMMM(
      Localizations.localeOf(context).toString(),
    ).format(DateTime.now());
    return Scaffold(
      appBar: B4SCustomAppBar(
        title: monthTitle,
        showBackButton: true,
        showIcons: false,
        showPremium: false,
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
                child:
                    _currentIndex == 0
                        ? _FieldView(selectedWeek: _selectedWeek)
                        : Container(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildWeekNavigator(context),
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: B4SDemoColors.modalsBackground,
            selectedItemColor: B4SDemoColors.buttonRed,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.sports_soccer),
                label: l10n.seasonTab,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.people),
                label: l10n.communityTab,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person),
                label: l10n.profileTab,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekNavigator(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
          if (_selectedWeek != 0)
            IconButton(
              icon: Icon(Icons.arrow_back_ios, color: B4SDemoColors.buttonRed),
              onPressed: () => setState(() => _selectedWeek--),
            )
          else
            const SizedBox(width: 48),
          Text(
            weekTitles[_selectedWeek],
            style: TextStyle(
              color: B4SDemoColors.buttonRed,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          if (_selectedWeek != _maxWeeks - 1)
            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                color: B4SDemoColors.buttonRed,
              ),
              onPressed: () => setState(() => _selectedWeek++),
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
  const _FieldView({required this.selectedWeek});

  @override
  State<_FieldView> createState() => _FieldViewState();
}

class _FieldViewState extends State<_FieldView> {
  Widget? _popup;
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
    return Center(
      child: SizedBox(
        width: 320,
        height: 340,
        child: Stack(
          children: [
            _buildFieldBackground(),
            ..._buildFlagWidgets(context, widget.selectedWeek),
            if (_popup != null)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.45),
                  child: Center(child: _popup),
                ),
              ),
          ],
        ),
      ),
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
    final l10n = AppLocalizations.of(context)!;
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
    final l10n = AppLocalizations.of(context)!;
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
    final l10n = AppLocalizations.of(context)!;
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
    final l10n = AppLocalizations.of(context)!;
    _showPopup(
      B4SPopup(
        title: 'Huray!',
        content: Text(l10n.popupTaskCompleted),
        actions: [TextButton(onPressed: _dismissPopup, child: Text('OK'))],
      ),
    );
  }

  void _showRedFlagDialog([int? flagIndex]) {
    final l10n = AppLocalizations.of(context)!;
    int sliderValue = 1;
    _showPopup(
      InteractiveB4SPopup(
        title: l10n.popupNewTaskAssigned,
        content: Text(l10n.popupDribblingQuestion),
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
    final l10n = AppLocalizations.of(context)!;
    int sliderValue1 = 1;
    int sliderValue2 = 1;
    _showPopup(
      InteractiveB4SPopup(
        title: l10n.popupNewTaskAssigned,
        content: SizedBox.shrink(),
        actions: [TextButton(onPressed: _dismissPopup, child: Text('OK'))],
        builder: (context, onComplete) {
          return StatefulBuilder(
            builder:
                (context, setState) => Column(
                  children: [
                    Text(l10n.popupDribblingQuestion),
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
                    Text(l10n.popupPassingQuestion),
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
    final l10n = AppLocalizations.of(context)!;
    _showPopup(
      B4SPopup(
        title: l10n.popupPastWeekTitle,
        content: Text(l10n.popupPastWeekContent),
        actions: [TextButton(onPressed: _dismissPopup, child: Text('OK'))],
      ),
    );
  }

  void _showCurrentWeekInactiveDialog(int index, int todayIndex) {
    final diff = index - todayIndex;
    final when = formatDaysMessage(context, diff);
    final l10n = AppLocalizations.of(context)!;
    final contentText = l10n.popupCurrentWeekContent(when);
    _showPopup(
      B4SPopup(
        title: l10n.popupCurrentWeekTitle,
        content: Text(contentText),
        actions: [TextButton(onPressed: _dismissPopup, child: Text('OK'))],
      ),
    );
  }

  void _showFutureWeekInactiveDialog(int selectedWeek, int currentWeek) {
    final diff = selectedWeek - currentWeek;
    final when = formatWeeksMessage(context, diff);
    final l10n = AppLocalizations.of(context)!;
    final isSpecial = when == l10n.popupNextWeek || when == l10n.popupLastWeek;
    final contentText =
        isSpecial
            ? l10n.popupFutureWeekContentSpecial(when)
            : l10n.popupFutureWeekContent(when);
    _showPopup(
      B4SPopup(
        title: l10n.popupFutureWeekTitle,
        content: Text(contentText),
        actions: [TextButton(onPressed: _dismissPopup, child: Text('OK'))],
      ),
    );
  }

  void _showCenterFlagInactiveDialog() {
    final l10n = AppLocalizations.of(context)!;
    _showPopup(
      B4SPopup(
        title: l10n.popupFutureWeekTitle,
        content: Text('This flag will be active on Friday and the weekend.'),
        actions: [TextButton(onPressed: _dismissPopup, child: Text('OK'))],
      ),
    );
  }

  String formatWeeksMessage(BuildContext context, int diff) {
    final l10n = AppLocalizations.of(context)!;
    if (diff == 1) return l10n.popupNextWeek;
    if (diff == -1) return l10n.popupLastWeek;
    if (diff.abs() > 1) return l10n.popupInXWeeks(diff.abs());
    return '';
  }

  String formatDaysMessage(BuildContext context, int diff) {
    final l10n = AppLocalizations.of(context)!;
    if (diff == 1) return l10n.popupTomorrow;
    if (diff == -1) return l10n.popupYesterday;
    if (diff.abs() > 1) return l10n.popupInXDays(diff.abs());
    return '';
  }
}
