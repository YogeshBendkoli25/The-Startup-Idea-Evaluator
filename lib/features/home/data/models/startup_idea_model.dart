import 'dart:convert';

import 'package:startup_ideas/features/home/domain/entities/startup_ideas.dart';

class StartupIdeaModel extends StartupIdea {
  const StartupIdeaModel({
    required super.id,
    required super.name,
    required super.tagline,
    required super.description,
    required super.aiScore,
    required super.aiVerdict,
    super.votes,
    super.hasVoted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'tagline': tagline,
      'description': description,
      'aiScore': aiScore,
      'aiVerdict': aiVerdict,
      'votes': votes,
      'hasVoted': hasVoted,
    };
  }

  factory StartupIdeaModel.fromMap(Map<String, dynamic> map) {
    return StartupIdeaModel(
      id: map['id'],
      name: map['name'],
      tagline: map['tagline'],
      description: map['description'],
      aiScore: map['aiScore'],
      aiVerdict: map['aiVerdict'] ?? 'Promising Concept',
      votes: map['votes'] ?? 0,
      hasVoted: map['hasVoted'] ?? false,
    );
    }

  String toJson() => json.encode(toMap());
  factory StartupIdeaModel.fromJson(String source) =>
      StartupIdeaModel.fromMap(json.decode(source));
}
