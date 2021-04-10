import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:value_layout_builder/value_layout_builder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: SafeArea(
          child: _Tester<String>(
            value: 'test',
            child: ValueLayoutBuilder<String>(
              builder: (context, constraints) {
                // The constraints holds the String value.
                final String value = constraints.value;
                return Text(value);
              },
            ),
          ),
        ),
      ),
    );
  }
}

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
    child!.layout(constraints);
    size = constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.paintChild(child!, offset);
  }
}
