// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navy/core/helpers/ui_constants_helper.dart';
import 'package:navy/theme/app_colors.dart';
import '../utils/gaps.dart';

class PrepareImageToUpload extends StatefulWidget {
  final double? width;
  final double? height;
  final XFile? initialImage;
  final Function(XFile?) onImageChanged;
  final String title;

  const PrepareImageToUpload({
    super.key,
    this.width,
    this.height,
    this.initialImage,
    required this.onImageChanged,
    required this.title,
  });

  @override
  _PrepareImageToUploadState createState() => _PrepareImageToUploadState();
}

class _PrepareImageToUploadState extends State<PrepareImageToUpload> {
  XFile? _image;

  @override
  void initState() {
    super.initState();
    _image = widget.initialImage;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
      widget.onImageChanged(_image);
    }
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
    widget.onImageChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            widget.title,
            maxLines: 2,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        wGap(10),
        Expanded(
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: _image != null ? _buildImagePreview() : _buildImagePicker(),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: UiConstantsHelper.defaultBorderRadius,
          child: kIsWeb
              ? Image.network(_image!.path)
              : Image.file(File(_image!.path)),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.black.withOpacity(.7),
          ),
          child: IconButton(
            onPressed: _pickImage,
            icon: const Icon(Icons.upload, color: Colors.white),
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.black.withOpacity(.7),
            ),
            child: IconButton(
              onPressed: _removeImage,
              icon: const Icon(Icons.close, color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return SizedBox(
      height: 150,
      child: InkWell(
        onTap: _pickImage,
        child: DottedBorder(
          color: Theme.of(context).shadowColor,
          borderType: BorderType.RRect,
          radius: const Radius.circular(10),
          strokeWidth: 1,
          dashPattern: const [10, 5],
          strokeCap: StrokeCap.round,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.upload,
                  color: AppColors.iconGrey,
                ),
                gapW8,
                Text(
                  "Pick image",
                  maxLines: 2,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: AppColors.iconGrey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
