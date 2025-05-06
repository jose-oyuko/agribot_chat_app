import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaPicker {
  static Future<bool> _requestPermission() async {
    final status =
        await [
          Permission.camera,
          Permission.photos,
          Permission.storage,
        ].request();

    return status.values.every((p) => p.isGranted);
  }

  static final ImagePicker _picker = ImagePicker();

  static Future<ChatMedia?> pickImageFromCamera() async {
    final hasPermission = await _requestPermission();
    if (!hasPermission) return null;

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      return ChatMedia(
        fileName: photo.name,
        url: photo.path,
        type: MediaType.image,
      );
    }
    return null;
  }

  static Future<ChatMedia?> pickImageFromGallery() async {
    final hasPermission = await _requestPermission();
    if (!hasPermission) return null;

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return ChatMedia(
        fileName: image.name,
        url: image.path,
        type: MediaType.image,
      );
    }
    return null;
  }

  static Future<ChatMedia?> pickFileAttachment() async {
    final hasPermission = await _requestPermission();
    if (!hasPermission) return null;

    final result = await FilePicker.platform.pickFiles(withData: true);
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      return ChatMedia(
        url: file.path!,
        fileName: file.name,
        type: MediaType.file,
      );
    }
    return null;
  }
}
