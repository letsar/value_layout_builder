import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:value_layout_builder/value_layout_builder.dart';

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
  void updateRenderObject(BuildContext context, _RenderTester<T> renderObject) {
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
    BoxValueConstraints<T> constraints = BoxValueConstraints<T>(
      constraints: this.constraints,
      value: value,
    );
    child?.layout(constraints);
    size = constraints.biggest;
  }
}

void main() {
  testWidgets('the constraints have the specified value', (tester) async {
    List<String> logs = <String>[];

    await tester.pumpWidget(
      _Tester<String>(
        value: 'test',
        child: ValueLayoutBuilder<String>(
          builder: (context, constraints) {
            logs.add(constraints.value);
            return SizedBox.shrink();
          },
        ),
      ),
    );

    expect(logs, ['test']);

    await tester.pumpWidget(
      _Tester<String>(
        value: '42',
        child: ValueLayoutBuilder<String>(
          builder: (context, constraints) {
            logs.add(constraints.value);
            return SizedBox.shrink();
          },
        ),
      ),
    );

    expect(logs, ['test', '42']);
  });
}
