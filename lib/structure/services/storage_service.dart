import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:study_buddy/structure/services/chat_services.dart';

class Storage {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final ChatService _chatService = ChatService();
  Future<void> sendSpecialMessage(
    String filePath,
    String fileName,
    String groupChatid,
    String message,
    String type,
  ) async {
    File file = File(filePath);

    try {
      await _firebaseStorage.ref('chatImages/$fileName').putFile(file);
      String downloadUrl =
          await _firebaseStorage.ref('chatImages/$fileName').getDownloadURL();

      // await _chatService.sendContentMessage(groupChatid, message, "chat", "", '');

      // await _chatService.sendContentMessage(
      //     groupChatid, downloadUrl, type, downloadUrl, '');
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<String?> downloadFile(
    BuildContext context,
    String url,
    String name,
  ) async {
    try {
      Dio dio = Dio();
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = '${appDocDir.path}/$name';

      await dio.download(url, filePath);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File Downloaded'),
        ),
      );

      return filePath;
    } catch (e) {
      print("ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to download file'),
        ),
      );
      return null;
    }
  }

  Future<void> openFile(BuildContext context, String url, String name) async {
    final filePath = await downloadFile(context, url, name);
    if (filePath == null) return;

    try {
      await OpenFile.open(filePath);
    } catch (e) {
      print("ERROR opening file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to open file'),
        ),
      );
    }
  }
}
