import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'skill_item.dart';
import 'experience_badge.dart';
import 'active_badge.dart';
import '../../../../widgets/accessibility floating button/accessibility_floating_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SkillChip extends ConsumerStatefulWidget {
  final SkillItem skill;
  final bool isExpanded;
  final VoidCallback? onTap;
  final AppLocalizations l10n;

  const SkillChip({
    super.key,
    required this.skill,
    required this.isExpanded,
    this.onTap,
    required this.l10n,
  });

  @override
  ConsumerState<SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends ConsumerState<SkillChip>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;
  bool _hasBeenTapped = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const _BounceWithPauseCurve(),
      ),
    );

    // Start continuous bouncing animation
    _startBouncingAnimation();
  }

  void _startBouncingAnimation() {
    if (!_hasBeenTapped) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(SkillChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset animation state when expansion state changes
    if (oldWidget.isExpanded != widget.isExpanded) {
      _hasBeenTapped = false;
      _startBouncingAnimation();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    // Stop the animation when tapped
    _hasBeenTapped = true;
    _animationController.stop();

    // Call the original onTap callback
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(accessibilitySettingsProvider);
    final tooltipMessage =
        '${widget.skill.name} - ${widget.l10n.skillTooltipYears(widget.skill.years.toString())}${widget.skill.isCurrentlyUsing ? ' (${widget.l10n.skillTooltipCurrentlyUsing})' : ''} - ${widget.l10n.skillTooltipClickToExpand}';

    Widget chipContent = GestureDetector(
      onTap: _handleTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: widget.isExpanded ? Colors.blue[100] : Colors.blue[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.isExpanded ? Colors.blue[400]! : Colors.blue[200]!,
            width: widget.isExpanded ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: AccessibleText(
                widget.skill.name,
                baseFontSize:
                    Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14,
                fontWeight: FontWeight.w500,
                color: Colors.blue[700],
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 6),
            ExperienceBadge(years: widget.skill.years, l10n: widget.l10n),
            if (widget.skill.isCurrentlyUsing) ...[
              const SizedBox(width: 4),
              ActiveBadge(l10n: widget.l10n),
            ],
            if (widget.skill.hasSubTechnologies) ...[
              const SizedBox(width: 4),
              // Only show animation if pause animations is disabled
              if (!settings.pauseAnimations)
                AnimatedBuilder(
                  animation: _bounceAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _bounceAnimation.value * 4),
                      child: Icon(
                        widget.isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 16,
                        color: Colors.blue[600],
                      ),
                    );
                  },
                )
              else
                Icon(
                  widget.isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 16,
                  color: Colors.blue[600],
                ),
            ],
          ],
        ),
      ),
    );

    // Only wrap with AccessibleCustomCursor and AccessibleTooltip if the skill can expand
    if (widget.skill.hasSubTechnologies) {
      return AccessibleCustomCursor(
        child: AccessibleTooltip(
          message: tooltipMessage,
          baseFontSize: 12,
          color: Colors.white,
          child: chipContent,
        ),
      );
    } else {
      return chipContent;
    }
  }
}

// Custom curve that creates 2-3 bounces followed by a pause
class _BounceWithPauseCurve extends Curve {
  const _BounceWithPauseCurve();

  @override
  double transform(double t) {
    // Create 3 bounces in the first 50% of the animation
    if (t < 0.5) {
      // Normalize t to 0-1 for the bounce section
      double bounceT = t / 0.5;
      // Create 3 bounces using a combination of curves
      return Curves.elasticOut.transform(bounceT) * 0.8;
    } else {
      // Pause for the remaining 50% of the animation
      return 0.0;
    }
  }
}
