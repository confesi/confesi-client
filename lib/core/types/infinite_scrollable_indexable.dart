import 'package:flutter/material.dart';

/// Allows for an item to be indexed by an infinite list.
///
/// AKA: it returns an ID which can be referenced as the last shown item. This
/// helps with fetching more items.
class InfiniteScrollIndexable {
  final dynamic key;
  final Widget child;

  InfiniteScrollIndexable(this.key, this.child);

  // tostring
  @override
  String toString() {
    return 'InfiniteScrollIndexable{id: $key, child: $child}';
  }
}
