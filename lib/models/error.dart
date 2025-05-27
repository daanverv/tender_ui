class ErrorLog {
  final String timestamp;
  final String level;
  final String message;

  ErrorLog({required this.timestamp, required this.level, required this.message});

  factory ErrorLog.fromJson(Map<String, dynamic> json) {
    return ErrorLog(
      timestamp: json['timestamp'],
      level: json['level'],
      message: json['message'],
    );
  }
}
