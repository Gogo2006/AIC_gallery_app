class NumResults {
  final int count;

  NumResults({required this.count});

  factory NumResults.fromJson(Map<String, dynamic> json) {
    return NumResults(
        count: json['pagination']['total']
    );
  }
}