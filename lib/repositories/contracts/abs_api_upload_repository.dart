import 'dart:io';

abstract class AbsApiUploadRepository {
  Future<String?> imageUpload(File file);
}
