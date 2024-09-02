import 'dart:io';

import 'package:cfc_christ/configs/c_api.dart';
import 'package:dio/dio.dart';

class TeachingMv {
  // READING ---------------------------------------------------------------------------------------------------------------->
  get(String teachingId) {
    _getFromCache();
  }

  _getFromCache() {}

  constructCacheData() {}

  downloadDocument(String documentPid) {}

  pushLikeToggle(String teachingId) {}

  // EDITING ---------------------------------------------------------------------------------------------------------------->
  update(String teachingId, String title, String newText) {}

  updateDocument(String teachingId, String documentPath) {}

  removeDocument(String teachingId, String documentPath) {}

  updateAudio(String teachingId, String audioPath) {}

  removeAudio(String teachingId, String audioPath) {}

  updateImage(String teachingId, String imagePath) {}

  remove(String teachingId, String imagePath) {}

  // PUBLISHING ------------------------------------------------------------------------------------------------------------->
  post(
    String title,
    String teaching,
    String date,
    String verse,
    String predicator,
    void Function(String id) onFinish,
    void Function() onFailed,
  ) async {
    Map<String, dynamic> data = {
      'title': title,
      'teaching': teaching,
      'verse': verse,
      'date': date,
      'predicator': predicator,
    };

    CApi.request.post('/teaching/quest/6P25iKiAj3KlIXXkrs', data: data).then((response) {
      if (response.data['state'] == 'POSTED') {
        onFinish.call(response.data['id']);
      } else {
        onFailed.call();
      }
    }, onError: (e) => onFailed.call());
  }

  postHeadImage(String pubId, String imagePath, void Function() onFinish) {
    var formData = FormData.fromMap({
      'teaching_id': pubId,
      'picture': MultipartFile.fromFileSync(imagePath),
    });

    CApi.request.post('/teaching/quest/hYEVGEpbMC1K40FBcb', data: formData).then((response) {
      if (response.data['state'] == 'STORED') {
        File(imagePath).delete();

        onFinish.call();
      }
    }, onError: (error) => onFinish.call());
  }

  sendAudio(String pubId, String audioPath, void Function() onFinish) {
    var formData = FormData.fromMap({
      'teaching_id': pubId,
      'audio': MultipartFile.fromFileSync(audioPath),
    });

    CApi.request.post('/teaching/quest/IUWI1vWLpVmeAzCmSR', data: formData).then((response) {
      if (response.data['state'] == 'STORED') {
        File(audioPath).delete();

        onFinish.call();
      }
    }, onError: (error) => onFinish.call());
  }

  sendDocument(String pubId, String documentPath, void Function() onFinish) {
    var formData = FormData.fromMap({
      'teaching_id': pubId,
      'document': MultipartFile.fromFileSync(documentPath),
    });

    CApi.request.post('/teaching/quest/hoXiIFCRIzaMiLCd36', data: formData).then((response) {
      if (response.data['state'] == 'STORED') {
        File(documentPath).delete();

        onFinish.call();
      }
    }, onError: (error) => onFinish.call());
  }
}
