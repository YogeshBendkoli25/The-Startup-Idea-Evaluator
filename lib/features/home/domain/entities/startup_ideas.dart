import 'package:equatable/equatable.dart';

class StartupIdea extends Equatable {
  final String id;
  final String name;
  final String tagline;
  final String description;
  final int aiScore;
  final String aiVerdict;
  final int votes;
  final bool hasVoted;

  const StartupIdea({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.aiScore,
    required this.aiVerdict,
    this.votes = 0,
    this.hasVoted = false,
  });

  StartupIdea copyWith({int? votes, bool? hasVoted}) {
    return StartupIdea(
      id: id,
      name: name,
      tagline: tagline,
      description: description,
      aiScore: aiScore,
      aiVerdict: aiVerdict,
      votes: votes ?? this.votes,
      hasVoted: hasVoted ?? this.hasVoted,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    tagline,
    description,
    aiScore,
    aiVerdict,
    votes,
    hasVoted,
  ];
}
