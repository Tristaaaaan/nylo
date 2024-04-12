// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String senderEmail;
  final String groupChatId;
  final String message;
  final String senderImage;
  final Timestamp timestamp;
  final String type;
  final String? downloadUrl;
  final String? category;
  final String? filename;

  MessageModel({
    required this.senderId,
    required this.senderEmail,
    required this.groupChatId,
    required this.message,
    required this.senderImage,
    required this.timestamp,
    required this.type,
    this.downloadUrl,
    this.category,
    this.filename,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'senderEmail': senderEmail,
      'groupChatId': groupChatId,
      'message': message,
      'senderImage': senderImage,
      'timestamp': timestamp,
      'type': type,
      'downloadUrl': downloadUrl,
      'category': category,
      'filename': filename,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] as String,
      senderEmail: map['senderEmail'] as String,
      groupChatId: map['groupChatId'] as String,
      message: map['message'] as String,
      senderImage: map['groupChatId'] as String,
      timestamp: Timestamp.fromDate(DateTime.parse(map['timestamp'] as String)),
      type: map['type'] as String,
      downloadUrl: map['downloadUrl'] as String,
      category: map['category'] as String,
      filename: map['filename'] as String,
    );
  }

  factory MessageModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return MessageModel(
      senderId: doc['senderId'],
      senderEmail: doc['senderEmail'],
      groupChatId: doc['groupChatId'],
      message: doc['message'],
      senderImage: doc['senderImage'],
      timestamp: doc['timestamp'],
      type: doc['type'],
      downloadUrl: doc['downloadUrl'],
      category: doc['category'],
      filename: doc['filename'],
    );
  }
}
