//  Copyright 2019 Callstack.io sp zo.o.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import './chip_spec.dart';

/// Renders [Chip] according to the provided [ChipSpec].
class SortedChip extends StatefulWidget {
  final ChipSpec chipSpec;
  final void Function(double) widthCallback;
  final bool isEnabled;

  /// Creates the SortedChip widget.
  ///
  /// This widget primarily draws [Chip] according to the passed `chipSpec`,
  /// while choosing the color scheme based on `isEnabled` argument.
  ///
  /// On first render, the widget will execute the passed `widthCallback` with
  /// the value of `context.size.width`.
  ///
  /// Note that the SortedChip widget is Stateful only to satisfy requirements
  /// of [AfterLayoutMixin].
  const SortedChip(
      {Key key,
      @required this.chipSpec,
      @required this.widthCallback,
      @required this.isEnabled})
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

    return Material(
      type: MaterialType.card,
      color: Colors.transparent,
      child: Chip(
          avatar: this.widget.chipSpec.avatar ??
              DecoratedBox(
                position: DecorationPosition.foreground,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    border: Border.all(color: color)),
                child: CircleAvatar(
                    backgroundColor: this.widget.isEnabled
                        ? Colors.white
                        : theme.buttonColor,
                    child:
                        Icon(Icons.check, size: CHIP_ICON_SIZE, color: color)),
              ),
          key: this.widget.key,
          backgroundColor: color,
          label: this.widget.chipSpec.label,
          labelStyle: this.widget.chipSpec.labelStyle,
          clipBehavior: this.widget.chipSpec.clipBehaviour,
          elevation: this.widget.chipSpec.elevation),
    );
  }
}
