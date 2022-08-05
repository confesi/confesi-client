import 'package:dartz/dartz.dart';

import '../../../../core/results/failures.dart';
import '../entities/post.dart';

/// The interface for how the implementation of the feed repository should look.
abstract class IFeedRepository {
  // Recents feed.
  Future<Either<Failure, List<Post>>> fetchRecents(String lastSeenPostId, String token);
  Future<Either<Failure, List<Post>>> refreshRecents(String token);

  // Trending feed.
  Future<Either<Failure, List<Post>>> fetchTrending();
  Future<Either<Failure, List<Post>>> refreshTrending(String token);

  // Daily Hottest section (on top of trending feed).
  Future<Either<Failure, List<Post>>> fetchDailyHottest(String token);
  Future<Either<Failure, List<Post>>> refreshDailyHottest(String token);

  // Refreshing all feeds.
  Future<Either<Failure, List<Post>>> refreshAllFeeds(String token);
}
