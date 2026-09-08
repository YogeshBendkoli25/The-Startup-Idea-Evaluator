import 'package:equatable/equatable.dart';
import 'package:startup_ideas/features/home/domain/entities/startup_ideas.dart';

enum IdeaStatus { initial, loading, loaded, error }

class IdeaState extends Equatable {
  final IdeaStatus status;
  final List<StartupIdea> ideas;
  final bool sortByVotes;
  final String? message;

  const IdeaState({
    this.status = IdeaStatus.initial,
    this.ideas = const [],
    this.sortByVotes = true,
    this.message,
  });

  IdeaState copyWith({
    IdeaStatus? status,
    List<StartupIdea>? ideas,
    bool? sortByVotes,
    String? message,
  }) {
    return IdeaState(
      status: status ?? this.status,
      ideas: ideas ?? this.ideas,
      sortByVotes: sortByVotes ?? this.sortByVotes,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, ideas, sortByVotes, message];
}