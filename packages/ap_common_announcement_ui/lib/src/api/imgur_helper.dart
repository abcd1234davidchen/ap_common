import 'dart:async';
import 'dart:typed_data';

import 'package:ap_common_flutter_core/ap_common_flutter_core.dart';
import 'package:path/path.dart' as p;

class ImgurHelper {
  ImgurHelper() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.imgbb.com/1',
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
        queryParameters: <String, dynamic>{
          'key': apiKey,
        },
        data: FormData.fromMap(
          <String, dynamic>{
            'image': MultipartFile.fromBytes(bytes),
            'name': p.split(file.path).last,
            if (expireTime != null)
              'expiration': (expireTime.millisecondsSinceEpoch / 1000).round(),
          },
        ),
      );
      if (response.statusCode == 200) {
        final ImgurUploadResponse imgurUploadResponse =
            ImgurUploadResponse.fromJson(response.data!);
        return callback == null
            ? imgurUploadResponse.data
            : callback.onSuccess(imgurUploadResponse.data) as ImgurUploadData;
      } else {
        callback?.onError(
          GeneralResponse(
            statusCode: 201,
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
            statusCode: 201,
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
