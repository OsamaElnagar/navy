import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navy/controllers/upload_controller.dart';
import 'package:navy/models/upload_task.dart';
import 'package:navy/utils/gaps.dart';

class ActiveUploadsIndicator extends StatelessWidget {
  const ActiveUploadsIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final uploads = Get.find<UploadController>().uploads;
      if (uploads.isEmpty) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).dividerColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: uploads.values.map((task) {
            return _UploadTaskItem(task: task);
          }).toList(),
        ),
      );
    });
  }
}

class _UploadTaskItem extends StatelessWidget {
  final UploadTask task;

  const _UploadTaskItem({required this.task});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getIconForType(task.type),
                size: 16,
                color: _getStatusColor(context, task.status),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getTaskTitle(task.type),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              if (task.stats != null && task.stats!['speed'] != null)
                Text(
                  task.stats!['speed'],
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              gapW16,
              Text(
                '${(task.progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: task.progress,
              minHeight: 4,
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getStatusColor(context, task.status),
              ),
            ),
          ),
          if (task.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                task.error!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(BuildContext context, String status) {
    switch (status) {
      case 'completed':
        return Theme.of(context).colorScheme.primary;
      case 'error':
        return Theme.of(context).colorScheme.error;
      case 'uploading':
        return Theme.of(context).colorScheme.primary;
      default:
        return Theme.of(context).colorScheme.secondary;
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'post':
        return Icons.post_add;
      case 'comment':
        return Icons.comment;
      case 'story':
        return Icons.auto_stories;
      case 'chat':
        return Icons.chat;
      default:
        return Icons.upload_file;
    }
  }

  String _getTaskTitle(String type) {
    switch (type) {
      case 'post':
        return 'Uploading post...';
      case 'comment':
        return 'Uploading comment...';
      case 'story':
        return 'Uploading story...';
      case 'chat':
        return 'Uploading file...';
      default:
        return 'Uploading...';
    }
  }
}
