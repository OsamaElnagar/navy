import 'package:get/get.dart';
import 'package:navy/models/upload_task.dart';
// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

class UploadController extends GetxController implements GetxService {
  static UploadController get to => Get.find();

  final _uploads = <String, UploadTask>{}.obs;
  Map<String, UploadTask> get uploads => _uploads;

  // Create a new upload task and return its ID
  String createUploadTask(String type, {Map<String, dynamic> data = const {}}) {
    final id = const Uuid().v4();
    final task = UploadTask(id: id, type: type, data: data);
    _uploads[id] = task;
    return id;
  }

  // Update upload progress
  void updateProgress(String taskId, double progress,
      [Map<String, dynamic>? stats]) {
    if (_uploads.containsKey(taskId)) {
      _uploads[taskId] = _uploads[taskId]!.copyWith(
        progress: progress.clamp(0.0, 0.99), // Cap at 99% until complete
        status: 'uploading',
        stats: stats,
      );
    }
  }

  // Mark upload as complete
  void completeUpload(String taskId) {
    if (_uploads.containsKey(taskId)) {
      _uploads[taskId] = _uploads[taskId]!.copyWith(
        progress: 1.0,
        status: 'completed',
      );
      // Remove completed upload after some time
      Future.delayed(const Duration(seconds: 3), () {
        _uploads.remove(taskId);
      });
    }
  }

  // Mark upload as failed
  void failUpload(String taskId, {String? error}) {
    if (_uploads.containsKey(taskId)) {
      _uploads[taskId] = _uploads[taskId]!.copyWith(
        status: 'error',
        error: error,
      );
      Future.delayed(const Duration(seconds: 3), () {
        _uploads.remove(taskId);
      });
    }
  }

  // Cancel upload
  void cancelUpload(String taskId) {
    _uploads.remove(taskId);
  }
}
