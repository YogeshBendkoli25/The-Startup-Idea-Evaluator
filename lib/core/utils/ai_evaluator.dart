import 'dart:math';

class AIEvaluatorResult {
  final int score;
  final String verdict;
  AIEvaluatorResult(this.score, this.verdict);
}

class AIEvaluator {
  static final _verdicts = {
    85: [
      "Unicorn potential! Silicon Valley VCs are already typing an email.",
      "Incredible market fit. Ship it yesterday.",
    ],
    70: [
      "Solid B2B SaaS vibes. High probability of healthy bootstrapping.",
      "Great niche concept with high defensibility.",
    ],
    50: [
      "Pivot needed. Good vision, but monetisation looks hazy.",
      "High CAC risk ahead. Rethink the go-to-market strategy.",
    ],
    0: [
      "Your burn rate will beat your ARR. Back to the whiteboard!",
      "Solution in search of a problem. Test smaller.",
    ],
  };

  static AIEvaluatorResult evaluate(String name, String description) {
    final random = Random();
    final score = 45 + random.nextInt(51); // 45 to 95 for realistic excitement

    String verdict = "Interesting thesis. Needs sharper unit economics.";
    for (final threshold in [85, 70, 50, 0]) {
      if (score >= threshold) {
        final list = _verdicts[threshold]!;
        verdict = list[random.nextInt(list.length)];
        break;
      }
    }
    return AIEvaluatorResult(score, verdict);
  }
}
