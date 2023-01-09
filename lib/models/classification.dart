class Classification {
  final double confidence;
  final int index;
  final String label;

  Classification(
      {required this.confidence, required this.index, required this.label});

  factory Classification.fromJson(Map<dynamic, dynamic> json) {
    return Classification(
      confidence: json['confidence'],
      index: json['index'],
      label: json['label'],
    );
  }
}
