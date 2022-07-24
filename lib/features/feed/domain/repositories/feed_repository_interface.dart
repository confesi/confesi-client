import 'package:dartz/dartz.dart';

/// The interface for how the implementation of the feed repository should look.
abstract class IFeedRepository {
  // Recents feed.
  Future<Either<String, String>> fetchRecents();
  Future<Either<String, String>> refreshRecents();

  // Trending feed.
  Future<Either<String, String>> fetchTrending();
  Future<Either<String, String>> refreshTrending();

  // Daily Hottest section (on top of trending feed).
  Future<Either<String, String>> fetchDailyHottest();
  Future<Either<String, String>> refreshDailyHottest();

  // Refreshing all feeds.
  Future<Either<String, String>> refreshAllFeeds();
}
