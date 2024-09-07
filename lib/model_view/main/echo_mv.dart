import 'dart:io';

import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class EchoMv {
   // READING ---------------------------------------------------------------------------------------------------------------->
  get(String teachingId) {
    _getFromCache();
  }

  _getFromCache() {}

  constructCacheData() {}

  downloadDocument(String documentPid) {}

  pushLikeToggle(String teachingId) {}

  // EDITING ---------------------------------------------------------------------------------------------------------------->
  void getListOfPublisheds(Function(List) onFinish, [Function(dynamic error)? onFailed]) {
    CApi.request.get('/echo/quest/edit.getlist.giH8YUKxPAVr38DBIg').then(
      (res) => onFinish.call(res.data),
      onError: (e) => onFailed?.call(e),
    );
  }

  update(String teachingId, String title, String newText) {}

  updateDocument(String echoId, String documentPath) {}

  removeDocument(String echoId, String documentPath) {}

  updateAudio(String echoId, String audioPath) {}

  removeAudio(String echoId, String audioPath) {}

  updateImage(String echoId, String imagePath) {}

  Future<Map> remove(String echoId) async {
    var data = await CApi.request.post('/echo/quest/edit.delete.qpu8Grt0tu3L1eNGj6', data: {'id': echoId});

    return data.data as Map;
  }

  Future<Map> toggleHide(String echoId) async {
    var data = await CApi.request.post('/echo/quest/edit.toggle.visibility.cxIwDFNyA7Xm9uYrAn', data: {'id': echoId});

    return data.data as Map;
  }

  // PUBLISHING ------------------------------------------------------------------------------------------------------------->
  post(
    String title,
    String echo,
    void Function(String id) onFinish,
    void Function() onFailed,
  ) async {
    Map<String, dynamic> data = {
      'title': title,
      'echo': echo,
    };

    CApi.request.post('/echo/quest/tSUr7URWYyIaxa4nCN', data: data).then((response) {
      if (response.data['state'] == 'POSTED') {
        onFinish.call(response.data['id']);
      } else {
        onFailed.call();
      }
    }, onError: (e) => onFailed.call());
  }

  postPicture(String pubId, String imagePath, void Function() onFinish, void Function() onFailed) {
    var formData = FormData.fromMap({
      'echo_id': pubId,
      'picture': MultipartFile.fromFileSync(imagePath),
    });

    CApi.request.post('/teaching/quest/jXHh0IbqrGJQe2XxkH', data: formData).then((response) {
      if (response.data['state'] == 'STORED') {
        if (File(imagePath).existsSync()) File(imagePath).delete();

        onFinish.call();
      } else if (response.data['state'] == 'FAILED') {
        onFailed.call();
      }
    }, onError: (error) => onFinish.call());
  }

  sendAudio(String pubId, String audioPath, void Function() onFinish) {
    var formData = FormData.fromMap({
      'echo_id': pubId,
      'audio': MultipartFile.fromFileSync(audioPath),
    });

    CApi.request.post('/echo/quest/VJBZ1EEQMZGDxRSKNz', data: formData).then((response) {
      if (response.data['state'] == 'STORED') {
        // if (File(audioPath).existsSync()) File(audioPath).delete();

        onFinish.call();
      }
    }, onError: (error) => onFinish.call());
  }

  sendDocument(String pubId, String documentPath, void Function() onFinish) {
    var formData = FormData.fromMap({
      'echo_id': pubId,
      'document': MultipartFile.fromFileSync(documentPath),
    });

    CApi.request.post('/echo/quest/8g9D22LLquKYePyDa9', data: formData).then((response) {
      if (response.data['state'] == 'STORED') {
        // if (File(documentPath).existsSync()) File(documentPath).delete();

        onFinish.call();
      } else {
        CSnackbarWidget.direct(const Text("Format du document incorrect"), defaultDuration: true);
        onFinish.call();
      }
    }, onError: (error) => onFinish.call());
  }
}
