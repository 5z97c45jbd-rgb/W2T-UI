import 'package:w2t_mobile/features/home/data/models/explore_video.dart';

class ExploreReelsExtra {
  const ExploreReelsExtra({
    required this.videos,
    this.initialIndex = 0,
  });

  final List<ExploreVideo> videos;
  final int initialIndex;
}
