import 'package:flutter/material.dart';
import 'package:observable/observable.dart';
import './chip_spec.dart';
import './sorted_chip.dart';

class _SortedChipsRowState extends State<SortedChipsRow>
    with SingleTickerProviderStateMixin {
  static const FIXED_HEIGHT = 60.0;
  static const FIXED_HORIZONTAL_PADDING = 8.0;

  final List<ChipSpec> chips;
  final List<double> chipsWidth;
  final List<Animation<RelativeRect>> chipsAnimations;
  final List<int> enabledChipsIndexes;
  double totalWidth = 0.0;
  ScrollController scrollController;
  AnimationController animationController;

  _SortedChipsRowState(this.enabledChipsIndexes, this.chips)
      : chipsWidth = List.filled(chips.length, 0.0),
        chipsAnimations = List.filled(
            chips.length, AlwaysStoppedAnimation(RelativeRect.fill));

  @override
  void initState() {
    super.initState();
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
    if (!enabledChipsIndexes.remove(chipIndex)) {
      enabledChipsIndexes.add(chipIndex);
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

  List<int> getChipsOrder() {
    final chipsOrder = List<int>.from(enabledChipsIndexes);
    for (var chipIndex = 0; chipIndex < chips.length; chipIndex++) {
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
    for (var chipIndex = 0; chipIndex < chips.length; chipIndex++) {
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
              children: List.from(chips.asMap().map((index, chip) {
                return MapEntry(
                    index,
                    PositionedTransition(
                        key: Key(index.toString()),
                        child: GestureDetector(
                          onTap: () {
                            _toggleChip(index);
                          },
                          child: FittedBox(
                            alignment: Alignment.centerLeft,
                            fit: BoxFit.scaleDown,
                            child: SortedChip(
                                chipSpec: chips[index],
                                isEnabled: enabledChipsIndexes.contains(index),
                                widthCallback: (width) {
                                  chipsWidth[index] = width;
                                  perhapsLayout();
                                }),
                          ),
                        ),
                        rect: chipsAnimations[index]));
              }).values),
            ),
          )),
    );
  }
}

class SortedChipsRow extends StatefulWidget {
  final ObservableList<int> enabledChartSeries;
  SortedChipsRow(this.enabledChartSeries);

  @override
  _SortedChipsRowState createState() {
    return new _SortedChipsRowState(enabledChartSeries, [
      ChipSpec(label: 'temperature', bgColor: Colors.amber),
      ChipSpec(label: 'blood pressure', bgColor: Colors.cyan),
      ChipSpec(label: 'heart rate', bgColor: Colors.green),
      ChipSpec(
          label: 'Oh no, this label is a bit long', bgColor: Colors.indigo),
    ]);
  }
}
