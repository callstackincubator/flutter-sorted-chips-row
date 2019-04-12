import 'package:flutter/material.dart';
import './chip_spec.dart';
import './sorted_chip.dart';

class SortedChipsRow extends StatefulWidget {
  static bool _defaultOnPress(int _, bool currentlyEnabled) =>
      !currentlyEnabled;

  final List<ChipSpec> chips;
  final bool Function(int, bool) onPress;

  SortedChipsRow({this.chips = const [], this.onPress = _defaultOnPress});

  @override
  _SortedChipsRowState createState() {
    return new _SortedChipsRowState();
  }
}

class _SortedChipsRowState extends State<SortedChipsRow>
    with SingleTickerProviderStateMixin {
  static const FIXED_HEIGHT = 60.0;
  static const FIXED_HORIZONTAL_PADDING = 8.0;

  final List<double> chipsWidth = [];
  final List<Animation<RelativeRect>> chipsAnimations = [];
  final List<int> enabledChipsIndexes = [];
  double totalWidth = 0.0;
  ScrollController scrollController;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();

    chipsWidth.addAll(List.filled(this.widget.chips.length, 0.0));
    chipsAnimations.addAll(List.filled(
        this.widget.chips.length, AlwaysStoppedAnimation(RelativeRect.fill)));
    for (int i = 0; i < this.widget.chips.length; i++) {
      if (this.widget.chips[i].initiallyEnabled) {
        enabledChipsIndexes.add(i);
      }
    }

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

  _toggleChip(int chipIndex, bool isEnabled) {
    bool nextEnabled = this.widget.onPress(chipIndex, isEnabled);
    if (nextEnabled != isEnabled) {
      if (nextEnabled) {
        enabledChipsIndexes.add(chipIndex);
      } else {
        enabledChipsIndexes.remove(chipIndex);
      }
      final chipsOrder = getChipsOrder();

      double totalOffset = 0.0;
      chipsOrder.forEach((chipIndex) {
        final currentRect = chipsAnimations[chipIndex].value;
        final targetRect = RelativeRect.fromLTRB(totalOffset, 0.0,
            context.size.width - totalOffset - chipsWidth[chipIndex], 0.0);
        chipsAnimations[chipIndex] =
            RelativeRectTween(begin: currentRect, end: targetRect)
                .animate(animationController);
        totalOffset += chipsWidth[chipIndex] + FIXED_HORIZONTAL_PADDING;
      });

      animationController
        ..reset()
        ..animateTo(1.0);
    }
  }

  List<int> getChipsOrder() {
    final chipsOrder = List<int>.from(enabledChipsIndexes);
    for (var chipIndex = 0; chipIndex < this.widget.chips.length; chipIndex++) {
      if (!enabledChipsIndexes.contains(chipIndex)) {
        chipsOrder.add(chipIndex);
      }
    }

    return chipsOrder;
  }

  void perhapsLayout() {
    if (chipsWidth.any((width) => width == 0.0)) {
      return;
    }

    double totalOffset = 0.0;
    for (var chipIndex = 0; chipIndex < this.widget.chips.length; chipIndex++) {
      final chipRelativeRect = RelativeRect.fromLTRB(totalOffset, 0.0,
          context.size.width - totalOffset - chipsWidth[chipIndex], 0.0);
      chipsAnimations[chipIndex] = AlwaysStoppedAnimation(chipRelativeRect);
      totalOffset += chipsWidth[chipIndex] + FIXED_HORIZONTAL_PADDING;
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
                  bool isEnabled = enabledChipsIndexes.contains(index);
                  return PositionedTransition(
                      key: Key(index.toString()),
                      child: GestureDetector(
                        onTap: () {
                          _toggleChip(index, isEnabled);
                        },
                        child: FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: SortedChip(
                              chipSpec: this.widget.chips[index],
                              isEnabled: isEnabled,
                              widthCallback: (width) {
                                chipsWidth[index] = width;
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
