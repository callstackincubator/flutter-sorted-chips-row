import 'package:flutter/material.dart';
import './chip_spec.dart';
import './sorted_chip.dart';

class ChipState {
  final ChipSpec spec;
  final int initialIndex;

  double _width;

  int _currentIndex;
  int get currentIndex => _currentIndex;

  bool _isEnabled;
  bool get isEnabled => _isEnabled;

  ChipState({this.spec, this.initialIndex}) {
    this._isEnabled = this.spec.initiallyEnabled;
    this._currentIndex = this.initialIndex;
    this._width = 0.0;
  }
}

class SortedChipsRow extends StatefulWidget {
  static int _defaultComparator(ChipState a, ChipState b) {
    if (a.isEnabled != b.isEnabled) {
      return (a.isEnabled ? -1 : 1);
    } else {
      return (a.currentIndex - b.currentIndex);
    }
  }

  static bool _defaultOnPress(int _, bool currentlyEnabled) =>
      !currentlyEnabled;

  final List<ChipSpec> chips;
  final bool Function(int, bool) onPress;
  final Comparator<ChipState> comparator;

  SortedChipsRow(
      {this.chips = const [],
      this.onPress = _defaultOnPress,
      this.comparator = _defaultComparator});

  @override
  _SortedChipsRowState createState() {
    return new _SortedChipsRowState();
  }
}

class _SortedChipsRowState extends State<SortedChipsRow>
    with SingleTickerProviderStateMixin {
  static const FIXED_HEIGHT = 60.0;
  static const FIXED_HORIZONTAL_PADDING = 8.0;

  final List<ChipState> chipStates = [];
  final List<Animation<RelativeRect>> chipsAnimations = [];
  double totalWidth = 0.0;
  ScrollController scrollController;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();

    this.widget.chips.asMap().forEach((index, spec) {
      chipStates.add(ChipState(spec: spec, initialIndex: index));
    });

    chipsAnimations.addAll(List.filled(
        this.widget.chips.length, AlwaysStoppedAnimation(RelativeRect.fill)));

    scrollController = ScrollController();
    animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 250),
        animationBehavior: AnimationBehavior.normal);
    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  _toggleChip(int chipIndex) {
    final ChipState chipState = chipStates[chipIndex];
    assert(chipState.initialIndex == chipIndex);

    bool isEnabled = chipState._isEnabled;
    bool nextEnabled = this.widget.onPress(chipIndex, chipState._isEnabled);
    if (nextEnabled != isEnabled) {
      chipState._isEnabled = nextEnabled;
      var sortedStates = List.of(chipStates)..sort(this.widget.comparator);
      Iterable.generate(sortedStates.length).forEach((index) => sortedStates[index]._currentIndex = index);

      double totalOffset = 0.0;
      sortedStates.forEach((chipState) {
        final chipIndex = chipState.initialIndex;
        final currentRect = chipsAnimations[chipIndex].value;
        final targetRect = RelativeRect.fromLTRB(totalOffset, 0.0,
            context.size.width - totalOffset - chipState._width, 0.0);
        chipsAnimations[chipIndex] =
            RelativeRectTween(begin: currentRect, end: targetRect)
                .animate(animationController);
        totalOffset += chipState._width + FIXED_HORIZONTAL_PADDING;
      });

      animationController
        ..reset()
        ..animateTo(1.0);
    }
  }

  void perhapsLayout() {
    if (chipStates.any((chipState) => chipState._width == 0.0)) {
      return;
    }

    double totalOffset = 0.0;
    for (var chipIndex = 0; chipIndex < this.widget.chips.length; chipIndex++) {
      final chipRelativeRect = RelativeRect.fromLTRB(totalOffset, 0.0,
          context.size.width - totalOffset - chipStates[chipIndex]._width, 0.0);
      chipsAnimations[chipIndex] = AlwaysStoppedAnimation(chipRelativeRect);
      totalOffset += chipStates[chipIndex]._width + FIXED_HORIZONTAL_PADDING;
    }

    this.setState(() {
      this.totalWidth = totalOffset - FIXED_HORIZONTAL_PADDING;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: LimitedBox(
        maxWidth: totalWidth,
        maxHeight: FIXED_HEIGHT,
        child: Container(
            alignment: Alignment.centerLeft,
            height: FIXED_HEIGHT,
            child: Stack(
                overflow: Overflow.visible,
                fit: StackFit.expand,
                children: List.of(
                    Iterable<int>.generate(this.widget.chips.length)
                        .map((index) {
                  bool isEnabled = chipStates[index]._isEnabled;
                  return PositionedTransition(
                      key: Key(index.toString()),
                      child: GestureDetector(
                        onTap: () {
                          _toggleChip(index);
                        },
                        child: FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: SortedChip(
                              chipSpec: this.widget.chips[index],
                              isEnabled: isEnabled,
                              widthCallback: (width) {
                                chipStates[index]._width = width;
                                perhapsLayout();
                              }),
                        ),
                      ),
                      rect: chipsAnimations[index]);
                })))),
      ),
    );
  }
}
