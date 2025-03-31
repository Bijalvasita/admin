class FeedbackModel {
  final String? id;
  final String message;
  final String reason;
  final String loanNumber;
  final String userId;
  final DateTime createdAt;
  String? userName;

  // constructor
  FeedbackModel({
    this.id,
    required this.message,
    required this.reason,
    required this.loanNumber,
    required this.userId,
    required this.createdAt,
  });

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'reason': reason,
      'loanNumber': loanNumber,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // fromJson method
  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'],
      message: json['message'],
      reason: json['reason'],
      loanNumber: json['loanNumber'],
      userId: json['userId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  @override
  String toString() {
    return 'FeedbackModel{id: $id, message: $message, reason: $reason, loanNumber: $loanNumber, userId: $userId}';
  }
}
