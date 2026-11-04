import 'package:equatable/equatable.dart';

sealed class ExploreEvent extends Equatable {
  const ExploreEvent();

  @override
  List<Object?> get props => [];
}

class ExploreRequested extends ExploreEvent {
  const ExploreRequested();
}

class ExploreCategoryChanged extends ExploreEvent {
  const ExploreCategoryChanged(this.category);

  final String category;

  @override
  List<Object?> get props => [category];
}

class ExploreTopicChanged extends ExploreEvent {
  const ExploreTopicChanged(this.topic);

  final String topic;

  @override
  List<Object?> get props => [topic];
}
