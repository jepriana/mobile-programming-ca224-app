import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repositories/contracts/abs_api_upload_repository.dart';

class InputImage extends StatefulWidget {
  final Function(String imageUrl) onSelectImage;
  final String? imageUrl;

  const InputImage({
    super.key,
    required this.onSelectImage,
    this.imageUrl,
  });

  @override
  State<InputImage> createState() => _InputImageState();
}

class _InputImageState extends State<InputImage> {
  String? _imageUrl;
  late AbsApiUploadRepository _apiUploadRepository;
  bool _isLoading = false;

  @override
  void initState() {
    _imageUrl = widget.imageUrl;
    _apiUploadRepository = context.read<AbsApiUploadRepository>();
    super.initState();
  }

  Future<bool> _requestPermission() async {
    // TODO: check and request permission
    return false;
  }

  Future<void> _pickImage() async {
    try {
      if (Platform.isAndroid) {
        final isPermissionGranted = await _requestPermission();
        if (!isPermissionGranted) {
          return;
        }
      }

      // TODO: pick and crop image
    } catch (e) {
      log(e.toString(), name: 'InputImage:_pickImage');
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final result = await _apiUploadRepository.imageUpload(imageFile);
      if (result != null) {
        _imageUrl = result;
        widget.onSelectImage(_imageUrl!);
      }
    } catch (e) {
      log(e.toString(), name: 'InputImage:_uploadImage');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: _imageUrl == null ? 100 / 1 : 4 / 3,
          child: _imageUrl == null
              ? null
              : Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0),
                    borderRadius: const BorderRadius.all(Radius.zero),
                  ),
                  alignment: Alignment.center,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : CachedNetworkImage(
                          imageUrl: _imageUrl!,
                          progressIndicatorBuilder: (context, url, progress) {
                            return CircularProgressIndicator(
                              value: progress.progress,
                            );
                          },
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () {},
              label: const Text('Browse Image'),
              icon: const Icon(
                Icons.image_search_rounded,
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              label: const Text('Capture Image'),
              icon: const Icon(
                Icons.camera_alt_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
