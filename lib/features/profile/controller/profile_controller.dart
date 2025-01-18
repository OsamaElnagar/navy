import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:navy/core/helpers/log_helper.dart';
import 'package:navy/features/profile/model/trash_post_model.dart';
import 'package:navy/models/pagination.dart';
import 'package:navy/services/dio_client.dart';
import 'package:image_picker/image_picker.dart';
import '../../authentication/service/user_hive_service.dart';
import 'package:navy/features/profile/repo/profile_repo.dart';
import 'package:navy/features/authentication/model/user_response.dart';
import 'package:navy/features/posts/model/post_model.dart' hide Pagination;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ProfileController extends GetxController {
  final ProfileRepository repository;

  ProfileController({
    required this.repository,
  });

  UserResponse? userResponse;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  var currentIndex = 0.obs;
  Pagination _pagination = Pagination(
    currentPage: 1,
    lastPage: 1,
    perPage: 10,
    total: 10,
  );
  Pagination? get pagination => _pagination;

  final PagingController<int, Post> postsPagingController =
      PagingController(firstPageKey: 1);

  final PagingController<int, TrashPost> trashedPostsPagingController =
      PagingController(firstPageKey: 1);

  final _imagePicker = ImagePicker();
  final selectedImage = Rx<File?>(null);
  final isLoading = false.obs;

  @override
  void onInit() {
    userResponse = Get.find<UserHiveService>().getUser();
    initPagingPosts();
    _initializeControllers();
    super.onInit();
  }

  void _initializeControllers() {
    nameController.text = userResponse!.user.name;
    emailController.text = userResponse!.user.email;
    phoneController.text = userResponse!.user.phone ?? "";
    dateOfBirthController.text = userResponse!.user.dateOfBirth.toString();
    bioController.text = userResponse!.user.bio ?? "";
    locationController.text = userResponse!.user.location ?? "";
    websiteController.text = userResponse!.user.website ?? "";
  }

  void onTabChange(int index) {
    currentIndex(index);
  }

  void initPagingPosts() {
    postsPagingController.addPageRequestListener((pageKey) {
      getProfile(pageKey);
    });
  }

  Future<void> getProfile(int page) async {
    try {
      dio.Response response = await repository.getProfile(page: page);
      if (response.statusCode == 200) {
        List posts = response.data['content']['posts'];
        final user = response.data['content']['user'];
        userResponse =
            await Get.find<UserHiveService>().updateUser(User.fromJson(user));
        _pagination = Pagination.fromJson(response.data['pagination']);

        final isLastPage = page >= _pagination.lastPage;

        List<Post> newPosts = posts.map((e) => Post.fromJson(e)).toList();

        if (newPosts.isEmpty) {
          postsPagingController.error = 'YOU HAVE NO POSTS';
        } else if (isLastPage) {
          postsPagingController.appendLastPage(newPosts);
        } else {
          final nextPageKey = page + 1;
          postsPagingController.appendPage(newPosts, nextPageKey);
        }
      } else {
        postsPagingController.error =
            'Something went wrong while fetching data';
      }
    } catch (error) {
      postsPagingController.error = 'Error fetching data\n$error';
    }
    update();
  }

  Future<void> refreshProfile() async {
    return postsPagingController.refresh();
  }

  RxBool loadingTrash = false.obs;
  Future<void> getTrashedPosts(int page, bool reload) async {
    loadingTrash(true);
    try {
      dio.Response response = await repository.getTrashedPosts(page);
      if (response.statusCode == 200) {
        List content = response.data['content'];
        _pagination = Pagination.fromJson(response.data['pagination']);

        final isLastPage = page >= _pagination.lastPage;
        if (reload) {
          trashedPostsPagingController.refresh();
        }

        List<TrashPost> newPosts =
            content.map((e) => TrashPost.fromJson(e)).toList();

        printLog(newPosts.length.toString());
        // Check if the newPosts list is empty
        if (newPosts.isEmpty) {
          trashedPostsPagingController.error = 'No trashed posts found.';
        } else if (isLastPage) {
          trashedPostsPagingController.appendLastPage(newPosts);
        } else {
          final nextPageKey = page + 1;
          trashedPostsPagingController.appendPage(newPosts, nextPageKey);
        }
      } else {
        trashedPostsPagingController.error = 'Error fetching data';
      }
    } catch (error) {
      trashedPostsPagingController.error = 'Error fetching data\n$error';
    }
    loadingTrash(false);
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateProfile() async {
    try {
      if (!_validateInputs()) return;

      isLoading.value = true;

      final fields = {
        'name': nameController.text.trim(),
        'bio': bioController.text.trim(),
        'date_of_birth': dateOfBirthController.text.trim(),
        'location': locationController.text.trim(),
        'website': websiteController.text.trim(),
      };

      List<MultipartBody>? files;
      if (selectedImage.value != null) {
        files = [MultipartBody('avatar', XFile(selectedImage.value!.path))];
      }

      final response = await repository.updateProfile(
        fields: fields,
        files: files,
      );

      if (response.statusCode == 200) {
        // Update local user data from response
        final updatedUser = User.fromJson(response.data['content']['user']);
        userResponse =
            await Get.find<UserHiveService>().updateUser(updatedUser);

        Get.back();
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw 'Failed to update profile';
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'Something went wrong: $error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateInputs() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Name is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (websiteController.text.isNotEmpty &&
        !GetUtils.isURL(websiteController.text.trim())) {
      Get.snackbar(
        'Error',
        'Please enter a valid website URL',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    bioController.dispose();
    locationController.dispose();
    websiteController.dispose();
    dateOfBirthController.dispose();
    postsPagingController.dispose();
    super.onClose();
  }

  Future<void> restorePost(int postId) async {
    try {
      final response = await repository.restorePost(postId);
      if (response.statusCode == 200) {
        trashedPostsPagingController.refresh();
        Get.snackbar(
          'Success',
          'Post restored successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to restore post',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> forceDeletePost(int postId) async {
    try {
      final response = await repository.forceDeletePost(postId);
      if (response.statusCode == 200) {
        trashedPostsPagingController.refresh();
        Get.snackbar(
          'Success',
          'Post permanently deleted',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to delete post',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
