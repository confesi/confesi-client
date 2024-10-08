/// What kind of tap feedback a button should have.
///
/// Includes [none] (no vibration), [lightImpact] (light vibration), and [strongImpact] (strong vibration).
enum TapType {
  none,
  lightImpact,
  strongImpact,
}

/// Where the tooltip should be displayed relative to the widget it surrounds.
///
/// This is simply a PREFERENCE, it does not guarentee positioning.
enum TooltipLocation {
  above,
  below,
}

/// Specifies if the post_tile.dart (ie. a post) widget is currently being displayed in the feed, or detailed view.
enum PostView {
  detailView,
  feedView,
}
