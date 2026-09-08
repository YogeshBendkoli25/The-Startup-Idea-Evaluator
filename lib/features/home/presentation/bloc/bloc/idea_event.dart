import 'package:equatable/equatable.dart';
import 'package:startup_ideas/features/home/domain/entities/startup_ideas.dart';

abstract class IdeaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadIdeasEvent extends IdeaEvent {}

class SubmitIdeaEvent extends IdeaEvent {
  final StartupIdea idea;
  SubmitIdeaEvent(this.idea);

  @override
  List<Object?> get props => [idea];
}

class UpvoteIdeaEvent extends IdeaEvent {
  final String id;
  UpvoteIdeaEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class SortIdeasEvent extends IdeaEvent {
  final bool sortByVotes;
  SortIdeasEvent({required this.sortByVotes});

  @override
  List<Object?> get props => [sortByVotes];
}

class DeleteIdeaEvent extends IdeaEvent {
  final String id;
  DeleteIdeaEvent(this.id);

  @override
  List<Object?> get props => [id];
}
