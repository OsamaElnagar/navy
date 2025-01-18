class UploadTask {
  final String id;
  final String type;
  final double progress;
  final String status;
  final Map<String, dynamic> data;
  final DateTime startTime;
  final Map<String, dynamic>? stats;
  final String? error;

  UploadTask({
    required this.id,
    required this.type,
    this.progress = 0.0,
    this.status = 'pending',
    this.data = const {},
    DateTime? startTime,
    this.stats,
    this.error,
  }) : startTime = startTime ?? DateTime.now();

  UploadTask copyWith({
    String? id,
    String? type,
    double? progress,
    String? status,
    Map<String, dynamic>? data,
    DateTime? startTime,
    Map<String, dynamic>? stats,
    String? error,
  }) {
    return UploadTask(
      id: id ?? this.id,
      type: type ?? this.type,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      data: data ?? this.data,
      startTime: startTime ?? this.startTime,
      stats: stats ?? this.stats,
      error: error,
    );
  }
}
