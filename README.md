# value_layout_builder

[![Pub](https://img.shields.io/pub/v/value_layout_builder.svg)][pub]

A `LayoutBuilder` with an extra value. It's useful when you want to build a widget with a value computed during layout.

## Features
* ValueLayoutBuilder - The RenderBox version.
* SliverValueLayoutBuilder - The RenderSliver version.

## Getting started

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  value_layout_builder:
```

In your library add the following import:

```dart
import 'package:value_layout_builder/value_layout_builder.dart';
```

For help getting started with Flutter, view the online [documentation](https://flutter.io/).

## Usage

`ValueLayoutBuilder` and `SliverValueLayoutBuilder` will pair with a custom `RenderObject` which accepts a one of them as a child.

For example it is used in [flutter_sticky_header][flutter_sticky_header] in order to know how much the header is hidden.


The typical usage is to expose a builder in the parameter of your widget's constructor which takes a `BuildContext` and the value you want to get from layout, and to pass it from your custom `RenderObject`.

The following code is a dumb example to show you how to use it:
```dart
class _Tester<T> extends SingleChildRenderObjectWidget {
  const _Tester({
    Key? key,
    required this.value,
    required Widget child,
  }) : super(key: key, child: child);

  final T value;

  @override
  _RenderTester<T> createRenderObject(BuildContext context) {
    return _RenderTester<T>(value: value);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderTester<T> renderObject,
  ) {
    renderObject.value = value;
  }
}

class _RenderTester<T> extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  _RenderTester({
    required T value,
  }) : _value = value;

  T get value => _value;
  T _value;
  set value(T value) {
    if (_value != value) {
      _value = value;
      markNeedsLayout();
    }
  }

  @override
  void performLayout() {
    // We create a specific constraints with the value we want to pass to the builder.
    BoxValueConstraints<T> constraints = BoxValueConstraints<T>(
      constraints: this.constraints,
      value: value,
    );
    child.layout(constraints);
    size = constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.paintChild(child, offset);
  }
}
```

We can then use `_Tester<T> ` like this:
```dart
_Tester<String>(
  value: 'test',
  child: ValueLayoutBuilder<String>(
    builder: (context, constraints) {
      // The constraints holds the String value.
      final String value = constraints.value;
      return Text(value);
    },
  ),
)
```

## Sponsoring

I'm working on my packages on my free-time, but I don't have as much time as I would. If this package or any other package I created is helping you, please consider to sponsor me. By doing so, I will prioritize your issues or your pull-requests before the others. 

## Changelog

Please see the [Changelog][changelog] page to know what's recently changed.

## Contributions

Feel free to contribute to this project.

If you find a bug or want a feature, but don't know how to fix/implement it, please fill an [issue][issue].  
If you fixed a bug or implemented a feature, please send a [pull request][pr].

<!--Links-->
[pub]: https://pub.dartlang.org/packages/value_layout_builder
[changelog]: https://github.com/letsar/value_layout_builder/blob/master/CHANGELOG.md
[issue]: https://github.com/letsar/value_layout_builder/issues
[pr]: https://github.com/letsar/value_layout_builder/pulls
[flutter_sticky_header]: https://github.com/letsar/flutter_sticky_header/

