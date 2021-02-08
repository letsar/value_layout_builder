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
  _SliverRenderTester<T> createRenderObject(BuildContext context) {
    return _SliverRenderTester<T>(value: value);
  }

  @override
  void updateRenderObject(
      BuildContext context, _SliverRenderTester<T> renderObject) {
    renderObject.value = value;
  }
}

class _SliverRenderTester<T> extends RenderSliver
    with RenderObjectWithChildMixin<RenderSliver> {
  _SliverRenderTester({
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
    SliverValueConstraints<T> constraints = SliverValueConstraints<T>(
      constraints: this.constraints,
      value: value,
    );
    child?.layout(constraints);
    geometry = SliverGeometry.zero;
  }
}

void main() {
  testWidgets('the constraints have the specified value', (tester) async {
    List<String> logs = <String>[];

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: CustomScrollView(
          slivers: <Widget>[
            _Tester<String>(
              value: 'test',
              child: SliverValueLayoutBuilder<String>(
                builder: (context, constraints) {
                  logs.add(constraints.value);
                  return SliverToBoxAdapter(
                    child: SizedBox.shrink(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    expect(logs, ['test']);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: CustomScrollView(
          slivers: <Widget>[
            _Tester<String>(
              value: '42',
              child: SliverValueLayoutBuilder<String>(
                builder: (context, constraints) {
                  logs.add(constraints.value);
                  return SliverToBoxAdapter(
                    child: SizedBox.shrink(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    expect(logs, ['test', '42']);
  });
}
