import 'dart:async';
import 'dart:typed_data';

import 'package:ap_common_flutter_core/ap_common_flutter_core.dart';

class ImgurHelper {
  ImgurHelper() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.imgbb.com/1',
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'Flutter App',
        },
      ),
    );
  }

  static ImgurHelper? get instance {
    return _instance ??= ImgurHelper();
  }

  late Dio dio;

  static const String apiKey = '20778f37dcc08538363199547e461796';

  static ImgurHelper? _instance;

  Future<ImgurUploadData?> uploadImageToImgur({
    required XFile file,
    DateTime? expireTime,
    GeneralCallback<ImgurUploadData?>? callback,
  }) async {
    try {
      final Uint8List bytes = await file.readAsBytes();
      final Response<Map<String, dynamic>> response = await dio.post(
        '/upload',
        data: FormData.fromMap(
          <String, dynamic>{
            'key': apiKey,
            'image': MultipartFile.fromBytes(
              bytes,
              filename: file.name,
            ),
            if (expireTime != null)
              'expiration': (expireTime.millisecondsSinceEpoch / 1000).round(),
          },
        ),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> imgbbData =
            response.data!['data'] as Map<String, dynamic>;
        final Map<String, dynamic> fullResponse = {
          'status': response.data!['status'],
          'success': response.data!['success'],
          'data': <String, dynamic>{
            'id': imgbbData['id'],
            'link': imgbbData['url'],
            'title': imgbbData['title'],
            'width': imgbbData['width'],
            'height': imgbbData['height'],
            'size': imgbbData['size'],
            'type': imgbbData['mime'],
            'name': imgbbData['filename'],
          },
        };
        final ImgurUploadResponse imgurUploadResponse =
            ImgurUploadResponse.fromJson(fullResponse);
        if (callback == null) {
          return imgurUploadResponse.data;
        } else {
          callback.onSuccess(imgurUploadResponse.data);
          return imgurUploadResponse.data;
        }
      } else {
        callback?.onError(
          GeneralResponse(
            statusCode: 500,
            message:
                response.statusMessage ?? ApLocalizations.current.unknownError,
          ),
        );

        return null;
      }
    } on DioException catch (dioException) {
      if (dioException.type == DioExceptionType.badResponse &&
          dioException.response?.statusCode == 400) {
        callback?.onError(
          GeneralResponse(
            statusCode: 400,
            message: ApLocalizations.current.notSupportImageType,
          ),
        );
      } else {
        callback?.onFailure(dioException);
      }
      return null;
    }
  }
}
