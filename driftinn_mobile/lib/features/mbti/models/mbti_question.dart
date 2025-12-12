class MbtiOption {
  final String label; // A, B, C, D
  final String text;
  final Map<String, int> scores; // e.g. {'E': 2} or {'I': 1}

  MbtiOption({required this.label, required this.text, required this.scores});
}

class MbtiQuestion {
  final String id;
  final String question;
  final String subtitle;
  final List<MbtiOption> options;
  // Which dimension pair does this mainly target? (For adaptive selection)
  final String dimension; // 'EI', 'SN', 'TF', 'JP'

  MbtiQuestion({
    required this.id,
    required this.question,
    this.subtitle = '',
    required this.options,
    required this.dimension,
  });
}
