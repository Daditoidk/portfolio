import 'package:flutter/material.dart';
import '../../../../data/models/skill.dart';
import '../../../theme/portfolio_theme.dart';
import '../../../../data/repositories/skill_repository.dart';
import 'skill_grid_tile.dart';

class SkillsGrid extends StatelessWidget {
  SkillsGrid({super.key});

  double itemWidth = 0;

  // Initialize the skill repository
  final SkillRepository _skillRepository = SkillRepository();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate aspect ratio that fits best while showing all items
        final double aspectRatio = _calculateOptimalAspectRatio(constraints);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            mainAxisSpacing: 13.0,
            crossAxisSpacing: 13.0,
            childAspectRatio: aspectRatio,
          ),
          itemCount: 30,
          itemBuilder: (context, index) {
            int row = index ~/ 6;
            int col = index % 6;

            if (_shouldBeEmpty(row, col)) {
              return const SizedBox.shrink();
            }

            if (row == 3 && col == 2) {
              return Transform.translate(
                offset: Offset(-(itemWidth / 3), 0),
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
              );
            }

            return _buildSkillTile(row, col, index);
          },
        );
      },
    );
  }

  double _calculateOptimalAspectRatio(BoxConstraints constraints) {
    // Calculate what the aspect ratio should be to fit exactly
    final double totalHorizontalSpacing = 13.0 * 5;
    final double totalVerticalSpacing = 13.0 * 4;

    final double availableWidth = constraints.maxWidth - totalHorizontalSpacing;
    final double availableHeight = constraints.maxHeight - totalVerticalSpacing;

    // Ideal item dimensions
    itemWidth = availableWidth / 6;
    final double itemHeight = availableHeight / 5;

    double aspectRatio = itemWidth / itemHeight;

    // If the container is very wide, limit the aspect ratio to prevent overly wide tiles
    if (aspectRatio > 1.5) {
      aspectRatio = 1.5;
    } else if (aspectRatio < 0.7) {
      aspectRatio = 0.7;
    }

    return aspectRatio;
  }

  bool _shouldBeEmpty(int row, int col) {
    Set<String> emptyCells = {
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

  bool _shouldBeBlue(int row, int col) {
    Set<String> blueCells = {
      '3-4', //
      '3-5', //
      '2-4', //
    };
    return blueCells.contains('$row-$col');
  }

  bool _shouldBeGreen(int row, int col) {
    Set<String> greenCells = {
      '3-0', //
      '4-0', //
      '4-1', //
    };
    return greenCells.contains('$row-$col');
  }

  bool _shouldBeYellow(int row, int col) {
    Set<String> yellowCells = {
      '0-4', // This will be overridden by empty
      '0-5', // This will be overridden by empty
      '1-5', // This will be overridden by empty
    };
    return yellowCells.contains('$row-$col');
  }

  bool _shouldBeGray(int row, int col) {
    Set<String> grayCells = {
      '1-1', //
      '1-2', //
      '2-1', //
      '2-2', //
    };
    return grayCells.contains('$row-$col');
  }

  bool _shouldBePurple(int row, int col) {
    Set<String> purpleCells = {
      '4-3', //
      '4-4', //
    };
    return purpleCells.contains('$row-$col');
  }

  Widget _buildSkillTile(int row, int col, int index) {
    // Initialize skills data if not already done
    if (_skillRepository.skillCount == 0) {
      _skillRepository.initializeWithSampleData();
    }

    // Get skills filtered by color based on position
    List<Skill> skills = _getSkillsByPosition(row, col);

    // Calculate the index for this position within the filtered skills
    int skillIndex = (row * 6 + col);

    // Adjust for empty cells - count only non-empty positions of the same color
    int actualIndex = 0;
    for (int i = 0; i <= skillIndex; i++) {
      int r = i ~/ 6;
      int c = i % 6;
      if (!_shouldBeEmpty(r, c) && _hasSameColorFilter(r, c, row, col)) {
        if (actualIndex < skills.length) {
          actualIndex++;
        }
      }
    }

    // If we have a skill for this position
    if (actualIndex > 0 && actualIndex <= skills.length) {
      final skill = skills[actualIndex - 1];
      return SkillGridTile(skill: skill);
    }

    // Fallback for empty positions
    return SizedBox.shrink();
  }

  List<Skill> _getSkillsByPosition(int row, int col) {
    final allSkills = _skillRepository.getAllSkills();

    if (_shouldBeBlue(row, col)) {
      var blueList = allSkills
          .where((skill) => skill.colorSet.name == 'blue')
          .toList();
      blueList.removeWhere((item) => item.name == 'Flutter & Dart');
      return blueList;
    } else if (_shouldBeGreen(row, col)) {
      return allSkills
          .where((skill) => skill.colorSet.name == 'green')
          .toList();
    } else if (_shouldBeYellow(row, col)) {
      return allSkills
          .where((skill) => skill.colorSet.name == 'yellow')
          .toList();
    } else if (_shouldBeGray(row, col)) {
      return allSkills.where((skill) => skill.colorSet.name == 'gray').toList();
    } else if (_shouldBePurple(row, col)) {
      return allSkills
          .where((skill) => skill.colorSet.name == 'purple')
          .toList();
    } else {
      // For non-empty positions that don't have a specific color
      return allSkills;
    }
  }

  bool _hasSameColorFilter(int r, int c, int targetRow, int targetCol) {
    // Check if the position has the same color filter as the target position
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

    // If neither position has a specific color filter, they're the same
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
