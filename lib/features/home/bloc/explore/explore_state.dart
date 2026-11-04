import 'package:equatable/equatable.dart';
import 'package:w2t_mobile/features/home/data/home_content.dart';
import 'package:w2t_mobile/features/home/data/models/explore_video.dart';

enum ExploreStatus { loading, success, failure }

class ExploreState extends Equatable {
  ExploreState({
    this.status = ExploreStatus.loading,
    String? category,
    this.topic = 'Trending',
    this.videos = const [],
    this.errorMessage,
  }) : category = category ?? HomeContent.categories.first.label;

  final ExploreStatus status;
  final String category;
  final String topic;
  final List<ExploreVideo> videos;
  final String? errorMessage;

  List<ExploreVideo> get visibleVideos {
    final filtered =
        videos.where((video) => video.hasTopic(topic)).toList(growable: false);
    return filtered.isEmpty ? videos : filtered;
  }

  ExploreState copyWith({
    ExploreStatus? status,
    String? category,
    String? topic,
    List<ExploreVideo>? videos,
    String? errorMessage,
  }) {
    return ExploreState(
      status: status ?? this.status,
      category: category ?? this.category,
      topic: topic ?? this.topic,
      videos: videos ?? this.videos,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, category, topic, videos, errorMessage];
}
