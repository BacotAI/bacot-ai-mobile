class ExpressionData {
  final double smile;
  final double serious;
  final double interest;
  final double expressiveness;

  ExpressionData({
    required this.smile,
    required this.serious,
    required this.interest,
    required this.expressiveness,
  });

  factory ExpressionData.empty() {
    return ExpressionData(smile: 0, serious: 0, interest: 0, expressiveness: 0);
  }

  @override
  String toString() {
    return 'ExpressionData(smile: $smile, serious: $serious, interest: $interest, expressiveness: $expressiveness)';
  }
}
