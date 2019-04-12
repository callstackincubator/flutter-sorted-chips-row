import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import './chip_spec.dart';

class SortedChip extends StatefulWidget {
  final ChipSpec chipSpec;
  final Function widthCallback;

  const SortedChip({Key key, this.chipSpec, this.widthCallback})
      : super(key: key);

  @override
  _SortedChipState createState() => _SortedChipState();
}

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
    final Color color = this.widget.isEnabled
        ? this.widget.chipSpec.enabledColor ?? theme.buttonColor
        : this.widget.chipSpec.disabledColor ?? theme.disabledColor;

    return Chip(
        avatar: this.widget.chipSpec.avatar ?? DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100.0)),
              border: Border.all(color: color)),
          child: CircleAvatar(
              backgroundColor:
                  this.widget.isEnabled ? Colors.white : theme.buttonColor,
              child: Icon(Icons.check, size: CHIP_ICON_SIZE, color: color)),
        ),
        key: this.widget.key,
        backgroundColor: color,
        label: Text(this.widget.chipSpec.label),
        labelStyle: this.widget.chipSpec.labelStyle,
        clipBehavior: this.widget.chipSpec.clipBehaviour,
        elevation: this.widget.chipSpec.elevation);
  }
}
