import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import './chip_spec.dart';

class _SortedChipState extends State<SortedChip>
    with AfterLayoutMixin<SortedChip> {
  static const CHIP_ICON_SIZE = 15.0;

  @override
  void afterFirstLayout(BuildContext context) {
    this.widget.widthCallback(context.size.width);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
        avatar: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100.0)),
              border: Border.all(
                  color: this.widget.isEnabled
                      ? this.widget.chipSpec.bgColor
                      : theme.disabledColor)),
          child: CircleAvatar(
              backgroundColor: this.widget.isEnabled
                  ? Colors.white
                  : theme.buttonColor,
              child: Icon(Icons.check,
                  size: CHIP_ICON_SIZE,
                  color: this.widget.isEnabled
                      ? this.widget.chipSpec.bgColor
                      : theme.disabledColor)),
        ),
        key: this.widget.key,
        label: Text(this.widget.chipSpec.label),
        backgroundColor: this.widget.isEnabled
            ? this.widget.chipSpec.bgColor
            : theme.buttonColor);
  }
}

class SortedChip extends StatefulWidget {
  final ChipSpec chipSpec;
  final Function widthCallback;
  final isEnabled;

  const SortedChip({Key key, this.chipSpec, this.widthCallback, this.isEnabled})
      : super(key: key);

  @override
  _SortedChipState createState() => _SortedChipState();
}
