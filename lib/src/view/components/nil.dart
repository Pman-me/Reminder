import 'package:flutter/material.dart';

class Nil extends Widget{
  @override
  Element createElement() => _NilElement(this);

}

class _NilElement extends Element{
  _NilElement(super.widget);

  @override
  bool get debugDoingBuild => false;

  @override
  void performRebuild() {}

  @override
  void mount(Element? parent, Object? newSlot) {
    assert(parent is! MultiChildRenderObjectElement,"");

    super.mount(parent, newSlot);
  }

}