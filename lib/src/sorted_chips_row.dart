import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './chip_spec.dart';
import './sorted_chip.dart';

/// Encapsulates the current state of the chip being rendered.
///
/// The primary purpose of this class is to provide all data necessary for the
/// [SortedChipsRow]'s `comparator`.
class ChipState {
  /// Spec used in creation of the chip.
  final ChipSpec spec;

  /// Initial index of the associated chip's spec in the [SortedChipsRow]'s
  /// `chips` parameter.
  final int initialIndex;

  /// Actual width of the associated chip, calculated after first layout.
  double _width;

  int _currentIndex;

  /// Current position of the associated chip.
  int get currentIndex => _currentIndex;

  bool _isEnabled;

  /// Whether the associated chip is in enabled state.
  bool get isEnabled => _isEnabled;

  ChipState({@required this.spec, @required this.initialIndex})
      : this._isEnabled = spec.initiallyEnabled,
        this._currentIndex = initialIndex,
        this._width = 0.0;
}

/// Renders a row of [Chip]s that get sorted according to the given comparator.
///
/// The widget renders a horizontal, scrollable row of
/// [Material Chip](https://material.io/design/components/chips.html) widgets
/// that get sorted by the function provided to the constructor.
/// 
/// Upon a tap landing on a Chip, the provided `onPress` function is called
/// with [ChipState] associated with that Chip. The call's return value is
/// treated as the new value of a Chip's "enabled" state. If the `onPress`
/// function is not provided by the user, a default one is used, which
/// unconditionally flips the chip's state.
/// 
/// If `onPress` returns a different value than stored in [ChipState.isEnabled]
/// then the `comparator` function is executed to sort the Chip widgets. After
/// determining the new positions of the chips, they are being animated to the
/// appropriate places in the row. If no `comparator` parameter is given to the
/// [SortedChipsRow]'s constructor, a default one is used that puts enabled
/// chips first, and maintains the current order of the chips that haven't
/// changed their state. If a chip has become enabled, it is placed last in the
/// group of enabled chips.
/// 
/// Currently the chip animation cannot be configured. PRs are welcome to
/// introduce such options.
class SortedChipsRow extends StatefulWidget {
  static int _defaultComparator(ChipState a, ChipState b) {
    if (a.isEnabled != b.isEnabled) {
      return (a.isEnabled ? -1 : 1);
    } else {
      return (a.currentIndex - b.currentIndex);
    }
  }

  static bool _defaultOnPress(ChipState state) =>
      !state._isEnabled;

  final List<ChipSpec> chips;
  final bool Function(ChipState) onPress;
  final Comparator<ChipState> comparator;

  /// Creates a SortedChipsRow widget.
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

  final List<ChipState> _chipStates = [];
  final List<Animation<RelativeRect>> _chipsAnimations = [];
  double _totalWidth = 0.0;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    this.widget.chips.asMap().forEach((index, spec) {
      _chipStates.add(ChipState(spec: spec, initialIndex: index));
    });

    _chipsAnimations.addAll(List.filled(
        this.widget.chips.length, AlwaysStoppedAnimation(RelativeRect.fill)));

    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 250),
        animationBehavior: AnimationBehavior.normal);
    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  _toggleChip(int chipIndex) {
    final ChipState chipState = _chipStates[chipIndex];
    assert(chipState.initialIndex == chipIndex);

    bool nextEnabled = this.widget.onPress(chipState);
    if (nextEnabled != chipState._isEnabled) {
      chipState._isEnabled = nextEnabled;
      var sortedStates = List.of(_chipStates)..sort(this.widget.comparator);
      Iterable.generate(sortedStates.length)
          .forEach((index) => sortedStates[index]._currentIndex = index);

      double totalOffset = 0.0;
      sortedStates.forEach((chipState) {
        final chipIndex = chipState.initialIndex;
        final currentRect = _chipsAnimations[chipIndex].value;
        final targetRect = RelativeRect.fromLTRB(totalOffset, 0.0,
            context.size.width - totalOffset - chipState._width, 0.0);
        _chipsAnimations[chipIndex] =
            RelativeRectTween(begin: currentRect, end: targetRect)
                .animate(_animationController);
        totalOffset += chipState._width + FIXED_HORIZONTAL_PADDING;
      });

      _animationController
        ..reset()
        ..animateTo(1.0);
    }
  }

  void perhapsLayout() {
    if (_chipStates.any((chipState) => chipState._width == 0.0)) {
      return;
    }

    double totalOffset = 0.0;
    for (var chipIndex = 0; chipIndex < this.widget.chips.length; chipIndex++) {
      final chipRelativeRect = RelativeRect.fromLTRB(totalOffset, 0.0,
          context.size.width - totalOffset - _chipStates[chipIndex]._width, 0.0);
      _chipsAnimations[chipIndex] = AlwaysStoppedAnimation(chipRelativeRect);
      totalOffset += _chipStates[chipIndex]._width + FIXED_HORIZONTAL_PADDING;
    }

    this.setState(() {
      this._totalWidth = totalOffset - FIXED_HORIZONTAL_PADDING;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: LimitedBox(
        maxWidth: _totalWidth,
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
                  bool isEnabled = _chipStates[index]._isEnabled;
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
                                _chipStates[index]._width = width;
                                perhapsLayout();
                              }),
                        ),
                      ),
                      rect: _chipsAnimations[index]);
                })))),
      ),
    );
  }
}
