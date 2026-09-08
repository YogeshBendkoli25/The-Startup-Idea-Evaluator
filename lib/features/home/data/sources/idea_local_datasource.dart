import 'package:shared_preferences/shared_preferences.dart';
import 'package:startup_ideas/features/home/data/models/startup_idea_model.dart';

abstract class IdeaLocalDataSource {
  Future<List<StartupIdeaModel>> getIdeas();
  Future<void> saveIdea(StartupIdeaModel idea);
  Future<void> upvoteIdea(String id);
  Future<void> deleteIdea(String id);
}

class IdeaLocalDataSourceImpl implements IdeaLocalDataSource {
  static const String _ideasKey = 'saved_startup_ideas';
  final SharedPreferences prefs;

  IdeaLocalDataSourceImpl({required this.prefs});

  @override
  Future<List<StartupIdeaModel>> getIdeas() async {
    final jsonList = prefs.getStringList(_ideasKey) ?? [];
    return jsonList.map((e) => StartupIdeaModel.fromJson(e)).toList();
  }

  @override
  Future<void> saveIdea(StartupIdeaModel idea) async {
    final ideas = await getIdeas();
    ideas.insert(0, idea);
    await prefs.setStringList(_ideasKey, ideas.map((e) => e.toJson()).toList());
  }

  @override
  Future<void> upvoteIdea(String id) async {
    final ideas = await getIdeas();
    final index = ideas.indexWhere((item) => item.id == id);
    if (index != -1 && !ideas[index].hasVoted) {
      final updated = StartupIdeaModel(
        id: ideas[index].id,
        name: ideas[index].name,
        tagline: ideas[index].tagline,
        description: ideas[index].description,
        aiScore: ideas[index].aiScore,
        aiVerdict: ideas[index].aiVerdict,
        votes: ideas[index].votes + 1,
        hasVoted: true,
      );
      ideas[index] = updated;
      await prefs.setStringList(
        _ideasKey,
        ideas.map((e) => e.toJson()).toList(),
      );
    }
  }

  @override
  Future<void> deleteIdea(String id) async {
    // getIdeas() here returns List<StartupIdeaModel>, which has toJson()
    final ideas = await getIdeas();
    ideas.removeWhere((item) => item.id == id);

    // prefs is properly defined in this class
    await prefs.setStringList(
      'saved_startup_ideas',
      ideas.map((e) => e.toJson()).toList(),
    );
  }
}
