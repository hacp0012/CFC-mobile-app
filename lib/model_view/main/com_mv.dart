import 'dart:io';

import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ComMv {
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
    CApi.request.get('/com/quest/edit.getlist.d8CmMR0YTSeFFF6mUe').then(
      (res) {
        if (res.data is List) {
          onFinish.call(res.data);
        } else {
          onFailed?.call('Conversion error');
        }
      },
      onError: (e) => onFailed?.call(e),
    );
  }

  update(String teachingId, String title, String newText) {}

  updateDocument(String teachingId, String documentPath) {}

  removeDocument(String teachingId, String documentPath) {}

  updateAudio(String teachingId, String audioPath) {}

  removeAudio(String teachingId, String audioPath) {}

  updateImage(String teachingId, String imagePath) {}

  Future<Map> remove(String teachingId) async {
    var data = await CApi.request.post('/com/quest/edit.delete.6Hwc5FQq029YMiVQkl', data: {'id': teachingId});

    return data.data as Map;
  }

  Future<Map> toggleHide(String teachingId) async {
    var data = await CApi.request.post('/com/quest/edit.toggle.visibility.Lnnq0j9aiS4trdkArb', data: {'id': teachingId});

    return data.data as Map;
  }

  // PUBLISHING ------------------------------------------------------------------------------------------------------------->
  post(String title, String com, bool stataus, void Function(String id) onFinish, void Function() onFailed) async {
    Map<String, dynamic> data = {
      'title': title,
      'com': com,
      'status': stataus,
    };

    CApi.request.post('/com/quest/meXRQbm0WQP6ZpAN5U', data: data).then((response) {
      print(response.data);
      if (response.data['state'] == 'POSTED') {
        onFinish.call(response.data['id']);
      } else {
        onFailed.call();
      }
    }, onError: (e) {
      onFailed.call();
    });
  }

  postHeadImage(String pubId, String imagePath, void Function() onFinish) {
    var formData = FormData.fromMap({
      'com_id': pubId,
      'picture': MultipartFile.fromFileSync(imagePath),
    });

    CApi.request.post('/com/quest/vNaLNWUX4Boh3PcpxO', data: formData).then((response) {
      if (response.data['state'] == 'STORED') {
        if (File(imagePath).existsSync()) File(imagePath).delete();

        onFinish.call();
      } else {
        onFinish.call();
      }
    }, onError: (error) => onFinish.call());
  }

  sendDocument(String pubId, String documentPath, void Function() onFinish) {
    var formData = FormData.fromMap({
      'com_id': pubId,
      'document': MultipartFile.fromFileSync(documentPath),
    });

    CApi.request.post('/com/quest/rw0rEEOIJOYeuG4mUL', data: formData).then((response) {
      if (response.data['state'] == 'STORED') {
        // File(documentPath).delete();

        onFinish.call();
      } else {
        CSnackbarWidget.direct(const Text("Format du document incorrect"), defaultDuration: true);
        onFinish.call();
      }
    }, onError: (error) => onFinish.call());
  }
}
