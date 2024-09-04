import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// The signature of the [SliverValueLayoutBuilder] builder function.
typedef SliverValueLayoutWidgetBuilder<T> = Widget Function(
  BuildContext context,
  SliverValueConstraints<T> constraints,
);

class SliverValueConstraints<T> extends SliverConstraints {
  SliverValueConstraints({
    required this.value,
    required SliverConstraints constraints,
  }) : super(
          axisDirection: constraints.axisDirection,
          growthDirection: constraints.growthDirection,
          userScrollDirection: constraints.userScrollDirection,
          scrollOffset: constraints.scrollOffset,
          precedingScrollExtent: constraints.precedingScrollExtent,
          overlap: constraints.overlap,
          remainingPaintExtent: constraints.remainingPaintExtent,
          crossAxisExtent: constraints.crossAxisExtent,
          crossAxisDirection: constraints.crossAxisDirection,
          viewportMainAxisExtent: constraints.viewportMainAxisExtent,
          remainingCacheExtent: constraints.remainingCacheExtent,
          cacheOrigin: constraints.cacheOrigin,
        );

  final T value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SliverValueConstraints<T>) return false;
    assert(other is SliverValueConstraints<T> && other.debugAssertIsValid());
    return other is SliverValueConstraints<T> &&
        other.value == value &&
        other.axisDirection == axisDirection &&
        other.growthDirection == growthDirection &&
        other.scrollOffset == scrollOffset &&
        other.overlap == overlap &&
        other.remainingPaintExtent == remainingPaintExtent &&
        other.crossAxisExtent == crossAxisExtent &&
        other.crossAxisDirection == crossAxisDirection &&
        other.viewportMainAxisExtent == viewportMainAxisExtent &&
        other.remainingCacheExtent == remainingCacheExtent &&
        other.cacheOrigin == cacheOrigin;
  }

  @override
  int get hashCode {
    return Object.hash(
      axisDirection,
      growthDirection,
      scrollOffset,
      overlap,
      remainingPaintExtent,
      crossAxisExtent,
      crossAxisDirection,
      viewportMainAxisExtent,
      remainingCacheExtent,
      cacheOrigin,
      value,
    );
  }
}

/// Builds a sliver widget tree that can depend on its own
/// [SliverValueConstraints].
///
/// Similar to the [ValueLayoutBuilder] widget except its builder should return
/// a sliver widget, and [SliverValueLayoutBuilder] is itself a sliver.
/// The framework calls the [builder] function at layout time and provides the
/// current [SliverValueConstraints].
/// The [SliverValueLayoutBuilder]'s final [SliverGeometry] will match the
/// [SliverGeometry] of its child.
///
/// See also:
///
///  * [ValueLayoutBuilder], the non-sliver version of this widget.
class SliverValueLayoutBuilder<T>
    extends ConstrainedLayoutBuilder<SliverValueConstraints<T>> {
  /// Creates a sliver widget that defers its building until layout.
  const SliverValueLayoutBuilder({
    Key? key,
    required SliverValueLayoutWidgetBuilder<T> builder,
  }) : super(key: key, builder: builder);

  /// Called at layout time to construct the widget tree.
  ///
  /// The builder must return a non-null sliver widget.
  @override
  SliverValueLayoutWidgetBuilder<T> get builder => super.builder;

  @override
  _RenderSliverValueLayoutBuilder<T> createRenderObject(BuildContext context) =>
      _RenderSliverValueLayoutBuilder<T>();
}

class _RenderSliverValueLayoutBuilder<T> extends RenderSliver
    with
        RenderObjectWithChildMixin<RenderSliver>,
        RenderConstrainedLayoutBuilder<SliverValueConstraints<T>,
            RenderSliver> {
  @override
  double childMainAxisPosition(RenderObject child) {
    assert(child == this.child);
    return 0;
  }

  @override
  void performLayout() {
    rebuildIfNecessary();
    child?.layout(constraints, parentUsesSize: true);
    geometry = child?.geometry ?? SliverGeometry.zero;
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    assert(child == this.child);
    // child's offset is always (0, 0), transform.translate(0, 0) does not mutate the transform.
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // This renderObject does not introduce additional offset to child's position.
    if (child?.geometry?.visible == true) context.paintChild(child!, offset);
  }

  @override
  bool hitTestChildren(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    return child != null &&
        child!.geometry!.hitTestExtent > 0 &&
        child!.hitTest(result,
            mainAxisPosition: mainAxisPosition,
            crossAxisPosition: crossAxisPosition);
  }
}
