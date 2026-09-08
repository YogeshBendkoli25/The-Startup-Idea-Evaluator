import 'package:startup_ideas/features/home/data/models/startup_idea_model.dart';
import 'package:startup_ideas/features/home/data/sources/idea_local_datasource.dart';
import 'package:startup_ideas/features/home/domain/entities/startup_ideas.dart';
import 'package:startup_ideas/features/home/domain/repositories/idea_repository.dart';

class IdeaRepositoryImpl implements IdeaRepository {
  final IdeaLocalDataSource localDataSource;

  IdeaRepositoryImpl({required this.localDataSource});

  @override
  Future<List<StartupIdea>> getIdeas() => localDataSource.getIdeas();

  @override
  Future<void> saveIdea(StartupIdea idea) {
    return localDataSource.saveIdea(
      StartupIdeaModel(
        id: idea.id,
        name: idea.name,
        tagline: idea.tagline,
        description: idea.description,
        aiScore: idea.aiScore,
        aiVerdict: idea.aiVerdict,
        votes: idea.votes,
        hasVoted: idea.hasVoted,
      ),
    );
  }

  @override
  Future<void> upvoteIdea(String id) => localDataSource.upvoteIdea(id);

  @override
  Future<void> deleteIdea(String id) async {
    // Simply pass the ID down to the datasource
    return await localDataSource.deleteIdea(id);
  }
}
