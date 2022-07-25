import 'package:dartz/dartz.dart';

import '../../../../core/results/failures.dart';
import '../../../../core/results/successes.dart';
import '../entities/post.dart';

/// The interface for how the implementation of the feed repository should look.
abstract class IFeedRepository {
  // Recents feed.
  Future<Either<Failure, List<Post>>> fetchRecents(String lastSeenPostId);
  Future<Either<Failure, Success>> refreshRecents();

  // Trending feed.
  Future<Either<Failure, List<Post>>> fetchTrending(String lastSeenPostId);
  Future<Either<Failure, Success>> refreshTrending();

  // Daily Hottest section (on top of trending feed).
  Future<Either<Failure, List<Post>>> fetchDailyHottest();
  Future<Either<Failure, Success>> refreshDailyHottest();

  // Refreshing all feeds.
  Future<Either<Failure, Success>> refreshAllFeeds();
}
