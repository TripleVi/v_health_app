import 'dart:io' as io;
import 'dart:typed_data';

import 'package:image/image.dart' as i;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as pp;

class ImageUtils {
  static const userFolder = "user";
  ImageUtils._();

  static Future<io.Directory> getUserFolder() async {
    final dir = await pp.getApplicationDocumentsDirectory();
    final path = p.join(dir.path, userFolder);
    final imageDir = io.Directory(path);
    if(!imageDir.existsSync()) {
      imageDir.createSync();
    }
    return imageDir;
  }

  static Future<io.File> getUserFile(String name) async {
    final folder = await getUserFolder();
    final path = p.join(folder.path, name);
    return io.File(path);
  }

  static Future<io.Directory> getRecordFolder(String recordId) async {
    final dir = await pp.getApplicationDocumentsDirectory();
    final path = p.join(dir.path, recordId);
    final recordDir = io.Directory(path);
    if(!recordDir.existsSync()) {
      recordDir.createSync();
    }
    return recordDir;
  }

  static Future<io.File> getRecordFile({
    required String recordId, 
    required String fileName,
  }) async {
    final folder = await getRecordFolder(recordId);
    final path = p.join(folder.path, fileName);
    return io.File(path);
  }

  static Future<String> saveImageBytes({
    required Uint8List bytes,
    required io.Directory directory,
    String extension = "jpg",
  }) async {
    final image = i.decodeImage(bytes);
    if(image == null) {
      throw Exception("Decoding the image file bytes failed");
    }
    String name = generateImageName(extension: extension);
    if(!directory.existsSync()) {
      throw Exception("Directory doest not exist at ${directory.uri}");
    }
    final path = p.join(directory.path, name);
    final isSuccess = await i.encodeJpgFile(path, image);
    if(isSuccess) {
      return name;
    }
    throw Exception("Encoding image bytes as jpg failed");
  }

  static Uint8List editMapImage(Uint8List mapBytes) {
    final image = i.decodeImage(mapBytes);
    if(image == null) {
      throw Exception("Decoding the image file bytes failed");
    }
    final width = image.width,
    height = image.height,
    expectedHeight = width ~/ 2;
    final offsetY = (height - expectedHeight) ~/ 2;
    final croppedImage = i.copyCrop(
      image, x: 0, y: offsetY,
      width: width, height: expectedHeight,
    );
    return i.encodeJpg(croppedImage);
  }

  static String generateImageName({String extension = "jpg"}) {
    return "${DateTime.now().millisecondsSinceEpoch}.$extension";
  }

  // Future<void> _rotateImageAndSave(List<int> bytes, String path) async {
  //   final originalImage = img.decodeImage(bytes);
  //   final fixedImage = img.copyRotate(originalImage!, 90);
  //   await io.File(path).writeAsBytes(img.encodeJpg(fixedImage));
  // }
}
