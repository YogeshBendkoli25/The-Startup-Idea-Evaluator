import 'package:startup_ideas/features/home/domain/entities/startup_ideas.dart';

abstract class IdeaRepository {
  Future<List<StartupIdea>> getIdeas();
  Future<void> saveIdea(StartupIdea idea);
  Future<void> upvoteIdea(String id);
  Future<void> deleteIdea(String id);
}
