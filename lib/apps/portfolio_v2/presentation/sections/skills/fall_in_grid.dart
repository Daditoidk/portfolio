import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/skill.dart';
import '../../../data/repositories/skill_repository.dart';
import '../../providers/scroll_providers.dart';
import '../../shared/widgets/reveal_from_animation.dart';
import '../../theme/portfolio_theme.dart';
import 'widgets/skill_grid_tile.dart';

class SkillsGrid extends ConsumerStatefulWidget {
  const SkillsGrid({super.key});

  @override
  ConsumerState<SkillsGrid> createState() => _SkillsGridState();
}

class _SkillsGridState extends ConsumerState<SkillsGrid>
    with TickerProviderStateMixin {
  static const int _cols = 6;
  static const int _count = 30;

  // Layout calc
  double itemWidth = 0;

  // Animation knobs
  final Duration tileDuration = const Duration(milliseconds: 650);
  final Curve translateCurve = Curves.easeOutBack; // nice pop for the drop
  final Curve fadeCurve =
      Curves.easeOutCubic; // non-overshoot to avoid opacity > 1
  final double fallDistance = 72.0;
  final Duration interGroupDelay = const Duration(milliseconds: 200);
  final Duration batchGap = const Duration(milliseconds: 160);
  final int minBatchSize = 1;
  final int maxBatchSize = 3;
  final bool once = true; // set false if you want replay on re-enter
  final double triggerFraction = 0.15; // start when ~15% visible
  final int? seed = 42; // set null to randomize every build

  // Controllers per cell index (null for empty)
  late List<AnimationController?> _controllers;
  late List<Animation<double>?> _opacities;
  late List<Animation<double>?> _offsetYs;

  // Visibility
  final GlobalKey _hostKey = GlobalKey();
  bool _sequenceStarted = false;
  bool _visible = false;
  ScrollController? _attachedScrollController;

  // Data
  final SkillRepository _skillRepository = SkillRepository();

  @override
  void initState() {
    super.initState();
    _initControllers();
    // Start listening to page scroll for visibility
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final sc = ref.read(scrollControllerProvider);
      _attachedScrollController = sc;
      sc.addListener(_checkVisibility);
      _checkVisibility();
    });
  }

  @override
  void dispose() {
    _attachedScrollController?.removeListener(_checkVisibility);
    _disposeControllers();
    super.dispose();
  }

  void _initControllers() {
    _controllers = List.filled(_count, null);
    _opacities = List.filled(_count, null);
    _offsetYs = List.filled(_count, null);

    for (int i = 0; i < _count; i++) {
      final row = i ~/ _cols;
      final col = i % _cols;
      if (_shouldBeEmpty(row, col)) continue; // leave nulls

      final c = AnimationController(vsync: this, duration: tileDuration);
      _controllers[i] = c;

      _opacities[i] = Tween<double>(
        begin: 0,
        end: 1,
      ).chain(CurveTween(curve: fadeCurve)).animate(c);

      _offsetYs[i] = Tween<double>(
        begin: -fallDistance,
        end: 0,
      ).chain(CurveTween(curve: translateCurve)).animate(c);
    }
  }

  void _disposeControllers() {
    for (final c in _controllers) {
      c?.dispose();
    }
  }

  // ---------- VISIBILITY ----------
  void _checkVisibility() {
    final ctx = _hostKey.currentContext;
    final box = ctx?.findRenderObject() as RenderBox?;
    if (ctx == null || box == null || !box.attached) return;

    final size = box.size;
    final top = box.localToGlobal(Offset.zero).dy;
    final bottom = top + size.height;
    final screenH = MediaQuery.of(ctx).size.height;

    final needed = size.height * triggerFraction;
    final intersects = (bottom > needed) && (top < screenH - needed);

    if (intersects && !_visible) {
      _visible = true;
      if (!_sequenceStarted) _startSequence();
    } else if (!intersects && _visible) {
      _visible = false;
      if (!once) {
        for (final c in _controllers) {
          c?.reverse();
        }
        _sequenceStarted = false;
      }
    }
  }

  // ---------- COLOR WAVE ORCHESTRATION ----------
  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _sequenceStarted = true;

    // Build color groups by grid index
    final Map<String, List<int>> byColorKey = {
      'green': [],
      'blue': [],
      'yellow': [],
      'gray': [],
      'purple': [],
      'other': [],
    };

    for (int i = 0; i < _count; i++) {
      final row = i ~/ _cols, col = i % _cols;
      if (_shouldBeEmpty(row, col)) continue;

      final key = _colorKeyForCell(row, col);
      byColorKey[key]!.add(i);
    }

    // Order: greens → blues → yellows → grays → purples → others
    final order = ['green', 'blue', 'yellow', 'gray', 'purple', 'other'];

    final rng = Random(seed);

    for (final key in order) {
      final list = byColorKey[key]!;
      if (list.isEmpty) continue;

      // randomize within the color wave
      list.shuffle(rng);

      int cursor = 0;
      while (cursor < list.length) {
        final remaining = list.length - cursor;
        final minB = minBatchSize.clamp(1, remaining);
        final maxB = maxBatchSize.clamp(minB, remaining);
        final batchSize = rng.nextInt(maxB - minB + 1) + minB;

        final batch = list.sublist(cursor, cursor + batchSize);
        cursor += batchSize;

        for (final idx in batch) {
          _controllers[idx]?.forward(from: 0);
        }
        if (cursor < list.length) {
          await Future.delayed(batchGap);
        }
      }

      await Future.delayed(interGroupDelay);
    }
  }

  String _colorKeyForCell(int row, int col) {
    if (_shouldBeGreen(row, col)) return 'green';
    if (_shouldBeBlue(row, col)) return 'blue';
    if (_shouldBeYellow(row, col)) return 'yellow';
    if (_shouldBeGray(row, col)) return 'gray';
    if (_shouldBePurple(row, col)) return 'purple';
    return 'other';
  }

  @override
  Widget build(BuildContext context) {
    // Ensure skills repo has data
    if (_skillRepository.skillCount == 0) {
      _skillRepository.initializeWithSampleData();
    }

    final scrollController = ref.watch(scrollControllerProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final aspectRatio = _calculateOptimalAspectRatio(constraints);

        return RepaintBoundary(
          key: _hostKey,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _cols,
              mainAxisSpacing: 13.0,
              crossAxisSpacing: 13.0,
              childAspectRatio: aspectRatio,
            ),
            itemCount: _count,
            itemBuilder: (context, index) {
              final row = index ~/ _cols;
              final col = index % _cols;

              // Your “skills” center word unchanged
              if (row == 3 && col == 2) {
                return RevealOnScroll(
                  scrollController: scrollController,
                  from: RevealFrom.center,
                  fadeDuration: const Duration(milliseconds: 600),
                  staggerDelay: const Duration(milliseconds: 600),
                  child: Transform.translate(
                    offset: Offset(-(itemWidth / 3) - 13.0 * 2, 0),
                    child: Center(
                      child: Text(
                        'skills',
                        style: PortfolioTheme.monotonRegular80,
                        overflow: TextOverflow.visible,
                        softWrap: false,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }

              if (_shouldBeEmpty(row, col)) {
                // Keep empty cells as empty widgets — GridView preserves position by index
                return const SizedBox.shrink();
              }

              // Build the actual skill tile for this position (your original logic)
              final tile = _buildSkillTile(row, col, index);

              // Wrap it with our per-cell animation if this index has a controller
              final c = _controllers[index];
              if (c == null) return tile;

              final opacity = _opacities[index]!;
              final offsetY = _offsetYs[index]!;

              return AnimatedBuilder(
                animation: c,
                builder: (_, child) {
                  final op = opacity.value.clamp(0.0, 1.0);
                  return Opacity(
                    opacity: op,
                    child: Transform.translate(
                      offset: Offset(0, offsetY.value),
                      child: child,
                    ),
                  );
                },
                child: tile,
              );
            },
          ),
        );
      },
    );
  }

  double _calculateOptimalAspectRatio(BoxConstraints constraints) {
    final double totalHorizontalSpacing = 13.0 * (_cols - 1);
    final double totalVerticalSpacing = 13.0 * (5 - 1);

    final double availableWidth = constraints.maxWidth - totalHorizontalSpacing;
    final double availableHeight = constraints.maxHeight - totalVerticalSpacing;

    itemWidth = availableWidth / _cols;
    final double itemHeight = availableHeight / 5;

    double aspectRatio = itemWidth / itemHeight;

    if (aspectRatio > 1.5) {
      aspectRatio = 1.5;
    } else if (aspectRatio < 0.7) {
      aspectRatio = 0.7;
    }
    return aspectRatio;
  }

  // === your original helpers, unchanged ===
  bool _shouldBeEmpty(int row, int col) {
    const emptyCells = {
      '0-0',
      '0-1',
      '0-2',
      '0-3',
      '1-0',
      '1-3',
      '1-4',
      '2-0',
      '2-3',
      '2-5',
      '3-1',
      '3-3',
      '4-2',
      '4-5',
    };
    return emptyCells.contains('$row-$col');
  }

  bool _shouldBeBlue(int row, int col) =>
      {'3-4', '3-5', '2-4'}.contains('$row-$col');
  bool _shouldBeGreen(int row, int col) =>
      {'3-0', '4-0', '4-1'}.contains('$row-$col');
  bool _shouldBeYellow(int row, int col) =>
      {'0-4', '0-5', '1-5'}.contains('$row-$col');
  bool _shouldBeGray(int row, int col) =>
      {'1-1', '1-2', '2-1', '2-2'}.contains('$row-$col');
  bool _shouldBePurple(int row, int col) =>
      {'4-3', '4-4'}.contains('$row-$col');

  Widget _buildSkillTile(int row, int col, int index) {
    final skills = _getSkillsByPosition(row, col);
    final skillIndex = (row * _cols + col);

    int actualIndex = 0;
    for (int i = 0; i <= skillIndex; i++) {
      final r = i ~/ _cols;
      final c = i % _cols;
      if (!_shouldBeEmpty(r, c) && _hasSameColorFilter(r, c, row, col)) {
        if (actualIndex < skills.length) actualIndex++;
      }
    }

    if (actualIndex > 0 && actualIndex <= skills.length) {
      final skill = skills[actualIndex - 1];
      return SkillGridTile(skill: skill);
    }
    return const SizedBox.shrink();
  }

  List<Skill> _getSkillsByPosition(int row, int col) {
    final allSkills = _skillRepository.getAllSkills();

    if (_shouldBeBlue(row, col)) {
      final blueList =
          allSkills.where((s) => s.colorSet.name == 'blue').toList()
            ..removeWhere((item) => item.name == 'Flutter & Dart');
      return blueList;
    } else if (_shouldBeGreen(row, col)) {
      return allSkills.where((s) => s.colorSet.name == 'green').toList();
    } else if (_shouldBeYellow(row, col)) {
      return allSkills.where((s) => s.colorSet.name == 'yellow').toList();
    } else if (_shouldBeGray(row, col)) {
      return allSkills.where((s) => s.colorSet.name == 'gray').toList();
    } else if (_shouldBePurple(row, col)) {
      return allSkills.where((s) => s.colorSet.name == 'purple').toList();
    } else {
      return allSkills;
    }
  }

  bool _hasSameColorFilter(int r, int c, int targetRow, int targetCol) {
    if (_shouldBeBlue(r, c) && _shouldBeBlue(targetRow, targetCol)) return true;
    if (_shouldBeGreen(r, c) && _shouldBeGreen(targetRow, targetCol)) {
      return true;
    }
    if (_shouldBeYellow(r, c) && _shouldBeYellow(targetRow, targetCol)) {
      return true;
    }
    if (_shouldBeGray(r, c) && _shouldBeGray(targetRow, targetCol)) return true;
    if (_shouldBePurple(r, c) && _shouldBePurple(targetRow, targetCol)) {
      return true;
    }

    if (!_shouldBeBlue(r, c) &&
        !_shouldBeGreen(r, c) &&
        !_shouldBeYellow(r, c) &&
        !_shouldBeGray(r, c) &&
        !_shouldBePurple(r, c) &&
        !_shouldBeBlue(targetRow, targetCol) &&
        !_shouldBeGreen(targetRow, targetCol) &&
        !_shouldBeYellow(targetRow, targetCol) &&
        !_shouldBeGray(targetRow, targetCol) &&
        !_shouldBePurple(targetRow, targetCol)) {
      return true;
    }
    return false;
  }
}
