import 'package:get/get.dart' hide Response;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navy/components/custom_snackbar.dart';
import 'package:navy/features/posts/controller/post_controller.dart';
import 'package:navy/features/posts/repo/post_repository.dart';
// import 'package:navy/services/api_client.dart';
import 'package:navy/controllers/upload_controller.dart';
import 'dart:io';

import 'package:navy/services/dio_client.dart';

class CreatePostController extends GetxController {
  static CreatePostController get instance => Get.find<CreatePostController>();

  final PostRepository postRepo;
  CreatePostController({required this.postRepo});

  final uploadController = Get.find<UploadController>();
  String? currentUploadId;

  @override
  void onClose() {
    // If there's an ongoing upload, transfer its ownership to the UploadController
    if (currentUploadId != null &&
        uploadController.uploads[currentUploadId]?.status == 'uploading') {
      // The upload will continue in the UploadController
      currentUploadId = null;
    }
    super.onClose();
  }

  final TextEditingController _contentController = TextEditingController();

  bool _isLoading = false;

  TextEditingController get contentController => _contentController;
  bool get isLoading => _isLoading;

  final RxList<XFile> _selectedMedia = <XFile>[].obs;
  RxList<XFile> get selectedMedia => _selectedMedia;

  Future<void> createPost() async {
    try {
      final errors = validatePost();
      if (errors.isNotEmpty) {
        customSnackBar(errors.join('\n'), isError: true);
        return;
      }

      _isLoading = true;
      update();
      final content = _contentController.text;

      Map<String, String> body = {
        'content': content,
        'visibility': 'public',
        'location': '123456',
        'featured': '1',
        'status': 'active',
      };

      final media = _selectedMedia
          .map((e) => MultipartBody.fromFile(e.path, 'media[]'))
          .toList();

      currentUploadId = uploadController.createUploadTask('post', data: {
        'content': _contentController.text,
        // Add other relevant data
      });

      final response = await postRepo.createPost(
        body: body,
        multipartBody: media,
        uploadId: currentUploadId,
      );

      if (response.statusCode == 200) {
        customSnackBar('Post created successfully', isError: false);
        Get.find<PostController>().refreshPosts();
        _clearForm();
      } else {
        customSnackBar('Failed to create post', isError: true);
      }
    } catch (e) {
      customSnackBar('An error occurred: ${e.toString()}', isError: true);
    } finally {
      _isLoading = false;
      update();
    }
  }

  void _clearForm() {
    _contentController.clear();
    _selectedMedia.clear();
    currentUploadId = null;
    update();
  }

  void pickImageMedia() async {
    final media = await ImagePicker().pickMultiImage(
      imageQuality: 50,
      limit: 4,
    );
    _selectedMedia.addAll(media);
    update();
  }

  void pickGalleryVideo() async {
    final media = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.rear,
      maxDuration: const Duration(seconds: 60),
    );
    if (media != null) {
      _selectedMedia.add(media);
      update();
    }
  }

  void pickCameraVideo() async {
    final media = await ImagePicker().pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: 60),
    );
    if (media != null) {
      _selectedMedia.add(media);
      update();
    }
  }

  void removeMedia(XFile media) {
    _selectedMedia.remove(media);
    update();
  }

  void clearMedia() {
    _selectedMedia.clear();
    update();
  }

  List<String> validatePost() {
    final content = _contentController.text;
    final List<String> errors = [];

    // Validate that at least content or media is present
    if (content.isEmpty && _selectedMedia.isEmpty) {
      errors.add('Either content or media is required');
    }

    // Media validation
    for (var media in _selectedMedia) {
      final String mimeType = media.path.toLowerCase();
      final File file = File(media.path);
      final int fileSizeKB = file.lengthSync() ~/ 1024; // Convert bytes to KB

      if (mimeType.endsWith('.jpg') ||
          mimeType.endsWith('.jpeg') ||
          mimeType.endsWith('.png')) {
        // Image validation - max 3MB (3 * 1024 KB)
        if (fileSizeKB > 10 * 1024) {
          errors.add('Image ${media.name} exceeds the size limit of 10MB');
        }
      } else if (mimeType.endsWith('.mp4') ||
          mimeType.endsWith('.mov') ||
          mimeType.endsWith('.avi')) {
        // Video validation - max 50MB (50 * 1024 KB)
        if (fileSizeKB > 50 * 1024) {
          errors.add('Video ${media.name} exceeds the size limit of 50MB');
        }
      } else {
        errors.add('Unsupported file type for ${media.name}');
      }
    }

    // Visibility validation
    const validVisibilities = ['public', 'friends', 'private'];
    if (!validVisibilities.contains('public')) {
      // Update this if you add visibility selection
      errors.add('Invalid visibility value');
    }

    // If there are any validation errors, throw them
    return errors;
  }
}
