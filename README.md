# sorted_chips_row

A Flutter Widget displaying a row of [Material Chips](https://material.io/design/components/chips.html), sorted according to the provided comparison function.

![sorted chips row](https://static.callstack.com/assets/sorted_chips_row.gif)

## How to use

### Adding dependency

This package is currently available only through GitHub (we'll soon publish it in the `pub` repository). To add this package as a dependency, add the following under `dependencies` section in your `pubspec.yaml`:

```
  sorted_chips_row:
    git:
      url: https://github.com/callstackincubator/flutter-sorted-chips-row.git
```

By default this dependency will get upgraded whenever a new version is being pushed to the `master` branch. To avoid that, we recommend that you also specify a ref pointing to a commit you verified:
```
      ref: COMMIT_ID
```

For details see the [dart documentation on Git dependencies](https://www.dartlang.org/tools/pub/dependencies#git-packages)

### Using in code

The main widget class in this package is [`SortedChipsRow`](https://github.com/callstackincubator/flutter-sorted-chips-row/blob/master/lib/src/sorted_chips_row.dart). See the [library's main file](https://github.com/callstackincubator/flutter-sorted-chips-row/blob/master/lib/sorted_chips_row.dart) for usage example.  

## Getting Started with Flutter

This project is a starting point for a Dart [package](https://flutter.dev/developing-packages/), a library module containing code that can be shared easily across multiple Flutter or Dart projects.

For help getting started with Flutter, view the [online documentation](https://flutter.dev/docs), which offers tutorials,  samples, guidance on mobile development, and a full API reference.
