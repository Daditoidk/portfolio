import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../theme/portfolio_theme.dart';

class HashtagCarousel extends StatefulWidget {
  const HashtagCarousel({
    super.key,
    required this.tags,
    this.scrollUpwards = true,
  });

  final List<String> tags;
  final bool scrollUpwards;

  @override
  State<HashtagCarousel> createState() => _HashtagCarouselState();
}

class _HashtagCarouselState extends State<HashtagCarousel>
    with SingleTickerProviderStateMixin {
  static const double _pixelsPerSecond = 24.0;

  late final ScrollController _scrollController;
  late final Ticker _ticker;
  late List<String> _loopingTags;

  double _scrollOffset = 0;
  Duration _lastTick = Duration.zero;
  double? _loopExtent;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loopingTags =
        widget.tags.isEmpty ? const [] : List<String>.from(widget.tags)
          ..addAll(widget.tags);
    _ticker = createTicker(_handleTick);
    _scheduleTickerStart();
  }

  void _handleTick(Duration elapsed) {
    if (!_scrollController.hasClients) {
      return;
    }

    _ensureLoopExtent();
    final loopExtent = _loopExtent;
    if (loopExtent == null || loopExtent == 0) {
      return;
    }

    final delta = elapsed - _lastTick;
    _lastTick = elapsed;

    final deltaSeconds = delta.inMicroseconds / Duration.microsecondsPerSecond;
    if (deltaSeconds <= 0) {
      return;
    }

    _scrollOffset += deltaSeconds * _pixelsPerSecond;
    if (_scrollOffset >= loopExtent) {
      _scrollOffset -= loopExtent;
    }

    _scrollController.jumpTo(_scrollOffset);
  }

  void _ensureLoopExtent() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;
    if (position.maxScrollExtent <= 0) {
      _loopExtent = null;
      _scrollOffset = 0;
      if (_ticker.isActive) {
        _ticker.stop();
      }
      if (_scrollController.offset != 0) {
        _scrollController.jumpTo(0);
      }
      return;
    }

    final totalExtent = position.maxScrollExtent + position.viewportDimension;
    if (totalExtent <= 0) {
      return;
    }
    final newLoopExtent = totalExtent / 2;
    if (_loopExtent != newLoopExtent) {
      _loopExtent = newLoopExtent;
      if (_scrollOffset >= newLoopExtent) {
        _scrollOffset = _scrollOffset % newLoopExtent;
        _scrollController.jumpTo(_scrollOffset);
      }
    }
  }

  @override
  void didUpdateWidget(covariant HashtagCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    final tagsChanged = !listEquals(widget.tags, oldWidget.tags);
    final directionChanged = widget.scrollUpwards != oldWidget.scrollUpwards;

    if (tagsChanged || directionChanged) {
      _loopingTags =
          widget.tags.isEmpty ? const [] : List<String>.from(widget.tags)
            ..addAll(widget.tags);
      _scrollOffset = 0;
      _loopExtent = null;
      _lastTick = Duration.zero;
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
      if (_loopingTags.isEmpty) {
        _ticker.stop();
      } else {
        _scheduleTickerStart();
      }
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loopingTags.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportHeight = constraints.hasBoundedHeight
            ? constraints.maxHeight
            : MediaQuery.of(context).size.height;

        return SizedBox(
          height: viewportHeight,
          child: NotificationListener<SizeChangedLayoutNotification>(
            onNotification: (_) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _ensureLoopExtent();
                }
              });
              return false;
            },
            child: SizeChangedLayoutNotifier(child: _buildCarouselList()),
          ),
        );
      },
    );
  }

  Widget _buildCarouselList() {
    Widget listView = ListView.builder(
      controller: _scrollController,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _loopingTags.length,
      itemBuilder: (context, index) {
        final tag = _loopingTags[index];
        final item = Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Center(
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(tag, style: PortfolioTheme.manropeBold20),
            ),
          ),
        );

        if (widget.scrollUpwards) {
          return item;
        }

        return Transform.scale(scaleY: -1, child: item);
      },
    );

    if (widget.scrollUpwards) {
      return listView;
    }

    return Transform.scale(scaleY: -1, child: listView);
  }

  void _scheduleTickerStart() {
    if (_loopingTags.isEmpty) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _loopingTags.isEmpty || _ticker.isActive) {
        return;
      }
      _ensureLoopExtent();
      if (_loopExtent != null && !_ticker.isActive) {
        _lastTick = Duration.zero;
        _ticker.start();
      } else if (_loopExtent == null) {
        if (_scrollController.hasClients &&
            _scrollController.position.maxScrollExtent <= 0) {
          return;
        }
        _scheduleTickerStart();
      }
    });
  }
}
