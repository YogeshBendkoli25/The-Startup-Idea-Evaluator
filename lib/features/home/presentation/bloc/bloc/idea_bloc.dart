import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_ideas/features/home/domain/repositories/idea_repository.dart';

import 'idea_event.dart';
import 'idea_state.dart';

class IdeaBloc extends Bloc<IdeaEvent, IdeaState> {
  final IdeaRepository repository;

  IdeaBloc({required this.repository}) : super(const IdeaState()) {
    on<LoadIdeasEvent>(_onLoadIdeas);
    on<SubmitIdeaEvent>(_onSubmitIdea);
    on<UpvoteIdeaEvent>(_onUpvoteIdea);
    on<SortIdeasEvent>(_onSortIdeas);
    on<DeleteIdeaEvent>(_onDeleteIdea);
  }

  Future<void> _onLoadIdeas(
    LoadIdeasEvent event,
    Emitter<IdeaState> emit,
  ) async {
    emit(state.copyWith(status: IdeaStatus.loading));
    try {
      final ideas = await repository.getIdeas();
      _sortAndEmit(ideas, state.sortByVotes, emit);
    } catch (e) {
      emit(
        state.copyWith(
          status: IdeaStatus.error,
          message: "Failed to load ideas.",
        ),
      );
    }
  }

  Future<void> _onSubmitIdea(
    SubmitIdeaEvent event,
    Emitter<IdeaState> emit,
  ) async {
    try {
      await repository.saveIdea(event.idea);
      final ideas = await repository.getIdeas();
      _sortAndEmit(
        ideas,
        state.sortByVotes,
        emit,
        message: "Idea analyzed and launched! 🚀",
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: IdeaStatus.error,
          message: "Failed to submit idea.",
        ),
      );
    }
  }

  Future<void> _onUpvoteIdea(
    UpvoteIdeaEvent event,
    Emitter<IdeaState> emit,
  ) async {
    try {
      await repository.upvoteIdea(event.id);
      final ideas = await repository.getIdeas();

      // We added the message string here so the UI triggers the SnackBar Toast
      _sortAndEmit(
        ideas,
        state.sortByVotes,
        emit,
        message: "Vote cast successfully! 👍",
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: IdeaStatus.error,
          message: "Failed to cast vote.",
        ),
      );
    }
  }

  void _onSortIdeas(SortIdeasEvent event, Emitter<IdeaState> emit) {
    _sortAndEmit(state.ideas, event.sortByVotes, emit);
  }

  void _sortAndEmit(
    List<dynamic> ideas,
    bool sortByVotes,
    Emitter<IdeaState> emit, {
    String? message,
  }) {
    final sorted = List<dynamic>.from(ideas);
    if (sortByVotes) {
      sorted.sort((a, b) => b.votes.compareTo(a.votes));
    } else {
      sorted.sort((a, b) => b.aiScore.compareTo(a.aiScore));
    }
    emit(
      state.copyWith(
        status: IdeaStatus.loaded,
        ideas: sorted.cast(),
        sortByVotes: sortByVotes,
        message: message,
      ),
    );
  }

  Future<void> _onDeleteIdea(
    DeleteIdeaEvent event,
    Emitter<IdeaState> emit,
  ) async {
    try {
      await repository.deleteIdea(event.id);
      final ideas = await repository.getIdeas();
      _sortAndEmit(
        ideas,
        state.sortByVotes,
        emit,
        message: "Pitch permanently deleted 🗑️",
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: IdeaStatus.error,
          message: "Failed to delete pitch.",
        ),
      );
    }
  }
}
