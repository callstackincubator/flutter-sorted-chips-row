import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sorted_chips_row/sorted_chips_row.dart';

void main() {
  var findChipByLabelAndColor = (Text label, Color color) => find.byWidgetPredicate(
      (widget) =>
          widget is Chip &&
          widget.label == label &&
          widget.backgroundColor == color);

  group('SortedChipsRow', () {
    testWidgets("doesn\'t render Chips if passed empty list",
        (WidgetTester wt) async {
      await wt.pumpWidget(MaterialApp(home: SortedChipsRow(chips: [])));
      expect(find.byType(Chip), findsNothing);
    });

    testWidgets("renders single Chip with given label",
        (WidgetTester wt) async {
      final Text label = Text('Test Label');
      await wt.pumpWidget(
          MaterialApp(home: SortedChipsRow(chips: [ChipSpec(label: label)])));

      expect(
          find.byWidgetPredicate(
              (widget) => widget is Chip && widget.label == label),
          findsOneWidget);
    });

    testWidgets("renders single Chip with other attributes",
        (WidgetTester wt) async {
      final ChipSpec spec = ChipSpec(
          label: Text('Foo bar'),
          labelStyle: TextStyle(color: Colors.amber),
          avatar: CircleAvatar(child: Text('F')),
          clipBehaviour: Clip.hardEdge,
          enabledColor: Colors.white,
          disabledColor: Colors.black,
          elevation: 100.0,
          initiallyEnabled: true,
          key: Key("Chip Key"));

      await wt.pumpWidget(MaterialApp(home: SortedChipsRow(chips: [spec])));

      expect(
          find.byWidgetPredicate((widget) =>
              widget is Chip &&
              widget.label == spec.label &&
              widget.labelStyle == spec.labelStyle &&
              widget.avatar == spec.avatar &&
              widget.clipBehavior == spec.clipBehaviour &&
              widget.backgroundColor == spec.enabledColor &&
              widget.elevation == spec.elevation),
          findsOneWidget);
    });

    testWidgets("Rerenders chips according to default onPress function",
        (WidgetTester wt) async {
      final ChipSpec spec1 = ChipSpec(
          label: Text('Foo Bar'),
          initiallyEnabled: false,
          enabledColor: Colors.white,
          disabledColor: Colors.black);
      final ChipSpec spec2 = ChipSpec(
          label: Text('Bar Baz'),
          initiallyEnabled: true,
          enabledColor: Colors.white,
          disabledColor: Colors.black);

      await wt.pumpWidget(MaterialApp(
          home: Center(child: SortedChipsRow(chips: [spec1, spec2]))));
      await wt.pumpAndSettle();

      expect(find.byType(Chip), findsNWidgets(2));
      expect(findChipByLabelAndColor(spec1.label, Colors.black), findsOneWidget);
      expect(findChipByLabelAndColor(spec2.label, Colors.white), findsOneWidget);

      await wt.tap(find.byType(Chip).first);
      await wt.tap(find.byType(Chip).last);
      await wt.pumpAndSettle();

      expect(findChipByLabelAndColor(spec1.label, Colors.white), findsOneWidget);
      expect(findChipByLabelAndColor(spec2.label, Colors.black), findsOneWidget);
    });
  });
}
