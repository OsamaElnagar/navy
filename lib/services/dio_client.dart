import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:navy/core/helpers/log_helper.dart';
import 'package:navy/features/authentication/service/user_hive_service.dart';
import 'package:navy/models/errors_model.dart';
import 'package:navy/utils/app_constants.dart';
import 'package:navy/controllers/upload_controller.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_checker.dart';

class DioClient extends GetxService {
  final String? appBaseUrl;

  static final String noInternetMessage = 'connection_to_api_server_failed'.tr;
  final int timeoutInSeconds = 60;

  late Dio _dio;
  String? token;

  DioClient({
    required this.appBaseUrl,
  }) {
    token = Get.find<UserHiveService>().getUser()?.token ?? '';
    printLog('Token: $token');

    _dio = Dio(
      BaseOptions(
        baseUrl: appBaseUrl ?? '',
        connectTimeout: Duration(seconds: timeoutInSeconds),
        receiveTimeout: Duration(seconds: timeoutInSeconds),
        headers: _getHeaders(),
      ),
    );

    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: false,
      requestBody: false,
      responseHeader: false,
      responseBody: true,
      error: true,
      compact: true,
      maxWidth: 90,
    ));

    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        logPrint: print,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
      ),
    );
  }

  Map<String, String> _getHeaders({
    String? overrideToken,
    String? zoneIDs,
    String? languageCode,
    String? guestID,
  }) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      AppConstants.zoneId: zoneIDs ?? '',
      AppConstants.appApiKey: AppConstants.appApiValue,
      AppConstants.localizationKey:
          languageCode ?? AppConstants.languages[0].languageCode!,
      'Authorization': 'Bearer ${overrideToken ?? token}',
      AppConstants.guestId: guestID ?? "",
    };
  }

  void updateHeader({
    String? token,
    String? zoneIDs,
    String? languageCode,
    String? guestID,
  }) {
    _dio.options.headers = _getHeaders(
      overrideToken: token,
      zoneIDs: zoneIDs,
      languageCode: languageCode,
      guestID: guestID,
    );
  }

  String _formatSpeed(int bytes, int total) {
    const durationInSeconds =
        1; // We'll use a 1-second window for speed calculation
    final speed = bytes / durationInSeconds;

    if (speed > 1024 * 1024) {
      return '${(speed / (1024 * 1024)).toStringAsFixed(1)} MB/s';
    } else if (speed > 1024) {
      return '${(speed / 1024).toStringAsFixed(1)} KB/s';
    }
    return '${speed.toStringAsFixed(1)} B/s';
  }

  String _formatBytes(int bytes) {
    if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '$bytes B';
  }

  Future<Response<T>> getData<T>(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<T>(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<Response<T>> postData<T>(
    String uri,
    dynamic data, {
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post<T>(
        uri,
        data: data,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<Response> postMultipartData({
    required String uri,
    required Map<String, String> fields,
    required List<MultipartBody> files,
    Options? options,
    String? uploadId,
    CancelToken? cancelToken,
  }) async {
    try {
      final formData = FormData();
      // ignore: unused_local_variable
      int totalBytes = 0;

      // Calculate total size for accurate progress
      for (var file in files) {
        if (!kIsWeb) {
          final fileStats = await File(file.file.path).stat();
          totalBytes += fileStats.size;
        }
      }

      // Add fields
      fields.forEach((key, value) {
        formData.fields.add(MapEntry(key, value));
      });

      // Add files
      for (var file in files) {
        if (kIsWeb) {
          final bytes = await file.file.readAsBytes();
          formData.files.add(
            MapEntry(
              file.key!,
              MultipartFile.fromBytes(
                bytes,
                filename: basename(file.file.path),
                contentType: MediaType.parse(
                  _getContentType(file.file.path),
                ),
              ),
            ),
          );
        } else {
          formData.files.add(
            MapEntry(
              file.key!,
              await MultipartFile.fromFile(
                file.file.path,
                filename: basename(file.file.path),
                contentType: MediaType.parse(
                  _getContentType(file.file.path),
                ),
              ),
            ),
          );
        }
      }

      DateTime lastUpdate = DateTime.now();
      const updateInterval = Duration(milliseconds: 100);
      int lastBytes = 0;

      final response = await _dio.post(
        uri,
        data: formData,
        options: options?.copyWith(
              sendTimeout: const Duration(minutes: 30),
              receiveTimeout: const Duration(minutes: 30),
            ) ??
            Options(
              sendTimeout: const Duration(minutes: 30),
              receiveTimeout: const Duration(minutes: 30),
            ),
        cancelToken: cancelToken,
        onSendProgress: (count, total) {
          final now = DateTime.now();
          if (now.difference(lastUpdate) >= updateInterval) {
            final bytesPerSecond = (count - lastBytes) *
                (1000 / now.difference(lastUpdate).inMilliseconds);

            if (uploadId != null) {
              Get.find<UploadController>().updateProgress(
                uploadId,
                total > 0 ? count / total : 0.0,
                {
                  'speed': _formatSpeed(bytesPerSecond.toInt(), total),
                  'uploaded': _formatBytes(count),
                  'total': _formatBytes(total),
                },
              );
            }

            lastBytes = count;
            lastUpdate = now;
          }
        },
      );

      if (uploadId != null) {
        Get.find<UploadController>().completeUpload(uploadId);
      }

      return response;
    } on DioException catch (e) {
      if (uploadId != null) {
        Get.find<UploadController>().failUpload(
          uploadId,
          error: e.message ?? 'Upload failed',
        );
      }
      return _handleError<dynamic>(e);
    }
  }

  Future<Response> postMultipartDataConversation(
    String uri,
    Map<String, String> fields,
    List<MultipartBody>? files, {
    List<PlatformFile>? otherFiles,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final formData = FormData();

      fields.forEach((key, value) {
        formData.fields.add(MapEntry(key, value));
      });

      if (files != null) {
        for (var file in files) {
          formData.files.add(
            MapEntry(
              file.key!,
              await MultipartFile.fromFile(
                file.file.path,
                filename: '${DateTime.now().toString()}.png',
                contentType: MediaType.parse('image/png'),
              ),
            ),
          );
        }
      }

      if (otherFiles != null) {
        for (var file in otherFiles) {
          if (file.bytes != null) {
            formData.files.add(
              MapEntry(
                'files[${otherFiles.indexOf(file)}]',
                MultipartFile.fromBytes(
                  file.bytes!,
                  filename: file.name,
                  contentType: MediaType.parse(
                    _getContentType(file.name),
                  ),
                ),
              ),
            );
          } else if (file.path != null) {
            formData.files.add(
              MapEntry(
                'files[${otherFiles.indexOf(file)}]',
                await MultipartFile.fromFile(
                  file.path!,
                  filename: file.name,
                  contentType: MediaType.parse(
                    _getContentType(file.name),
                  ),
                ),
              ),
            );
          }
        }
      }

      return await _dio.post(
        uri,
        data: formData,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      return _handleError<dynamic>(e);
    }
  }

  String _getContentType(String path) {
    final ext = extension(path).toLowerCase();
    switch (ext) {
      case '.jpeg':
      case '.jpg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.mp4':
        return 'video/mp4';
      case '.mov':
        return 'video/quicktime';
      case '.pdf':
        return 'application/pdf';
      case '.doc':
        return 'application/msword';
      case '.docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      default:
        return 'application/octet-stream';
    }
  }

  Future<Response<T>> putData<T>(
    String uri,
    dynamic data, {
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put<T>(
        uri,
        data: data,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<Response> putMultipartData({
    required String uri,
    required Map<String, String> fields,
    List<MultipartBody>? files,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final formData = FormData();

      // Add fields
      fields.forEach((key, value) {
        if (value.isNotEmpty) {
          formData.fields.add(MapEntry(key, value));
        }
      });

      // Add files if provided
      if (files != null) {
        for (var file in files) {
          if (kIsWeb) {
            final bytes = await file.file.readAsBytes();
            formData.files.add(
              MapEntry(
                file.key!,
                MultipartFile.fromBytes(
                  bytes,
                  filename: basename(file.file.path),
                  contentType: MediaType.parse(
                    _getContentType(file.file.path),
                  ),
                ),
              ),
            );
          } else {
            formData.files.add(
              MapEntry(
                file.key!,
                await MultipartFile.fromFile(
                  file.file.path,
                  filename: basename(file.file.path),
                  contentType: MediaType.parse(
                    _getContentType(file.file.path),
                  ),
                ),
              ),
            );
          }
        }
      }

      final response = await _dio.put(
        uri,
        data: formData,
        options: options,
        cancelToken: cancelToken,
      );

      return response;
    } on DioException catch (e) {
      return _handleError<dynamic>(e);
    }
  }

  Future<Response<T>> deleteData<T>(
    String uri, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete<T>(
        uri,
        data: data,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<Response<T>> _handleError<T>(DioException error) async {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return Response<T>(
        requestOptions: error.requestOptions,
        statusCode: 408,
        statusMessage: 'Request Timeout',
      );
    }

    if (error.type == DioExceptionType.connectionError) {
      return Response<T>(
        requestOptions: error.requestOptions,
        statusCode: 0,
        statusMessage: noInternetMessage,
      );
    }

    if (error.response != null) {
      ApiChecker.checkApi(error.response!);
      try {
        if (error.response!.data != null &&
            error.response!.data.toString().startsWith('{response_code:')) {
          ErrorsModel errorResponse =
              ErrorsModel.fromJson(error.response!.data);

          return Response<T>(
            requestOptions: error.requestOptions,
            statusCode: error.response!.statusCode,
            data: error.response!.data as T?,
            statusMessage: errorResponse.responseCode,
          );
        }
      } catch (e) {
        printLog('Error parsing error response: $e');
      }
      return error.response as Response<T>;
    }

    return Response<T>(
      requestOptions: error.requestOptions,
      statusCode: 1,
      statusMessage: noInternetMessage,
    );
  }
}

class MultipartBody {
  String? key;
  XFile file;

  MultipartBody(this.key, this.file);

  factory MultipartBody.fromFile(String path, String name) {
    return MultipartBody(name, XFile(path));
  }
}
