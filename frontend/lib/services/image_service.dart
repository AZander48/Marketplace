import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

class ImageService {
  final String baseUrl;
  final ImagePicker _picker = ImagePicker();

  ImageService({required this.baseUrl});

  Future<String?> pickAndUploadImage() async {
    try {
      // Pick an image
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return null;

      // Create multipart request
      final uri = Uri.parse('$baseUrl/api/upload');
      final request = http.MultipartRequest('POST', uri);

      // Add the image file
      final file = File(image.path);
      final mimeType = lookupMimeType(image.path);
      final stream = http.ByteStream(file.openRead());
      final length = await file.length();

      final multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: path.basename(image.path),
      );

      request.files.add(multipartFile);

      // Send the request
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonData = json.decode(responseData);
        return jsonData['url']; // Return the URL from the response
      } else {
        // add error
        return null;
      }
    } catch (e) {
      // add error
      return null;
    }
  }
} 