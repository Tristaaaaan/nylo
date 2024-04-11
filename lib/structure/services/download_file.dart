// import 'dart:io';

// import 'package:permission_handler/permission_handler.dart';

// class DownloadService {
//   Future<void> requestPermissions() async {
//     await Permission.storage.request();
//   }

//   Future<bool> checkAndRequestStoragePermission() async {
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       status = await Permission.storage.request();
//     }
//     return status.isGranted;
//   }

//   // Future<void> downloadStartMethodUsingFlutterDownloader(
//   //     controller, uri) async {
//   //   print("URI: $uri");
//   //   final taskId = await FlutterDownloader.enqueue(
//   //     url: uri.url.toString(),
//   //     savedDir: (await getExternalStorageDirectory())!.path,

//   //     // allowCellular: true,
//   //     fileName: uri.url.pathSegments.last.toString(),
//   //     showNotification:
//   //         true, // show download progress in status bar (for Android)
//   //     openFileFromNotification:
//   //         true, // click on notification to open downloaded file (for Android)
//   //     allowCellular: true,
//   //   );
//   // }

//   // Future<void> downloadFile(String url, String filename) async {
//   //   String name = DateTime.now().millisecondsSinceEpoch.toString();
//   //   if (Platform.isAndroid) {
//   //     FileDownloader.downloadFile(
//   //         url: url,
//   //         name: "THE FILE NAME AFTER DOWNLOADING", //(optional)
//   //         onProgress: (String? name, double progress) {
//   //           print('FILE fileName HAS PROGRESS $progress');
//   //         },
//   //         onDownloadCompleted: (String path) {
//   //           print('FILE DOWNLOADED TO PATH: $path');
//   //         },
//   //         onDownloadError: (String error) {
//   //           print('DOWNLOAD ERROR: $error');
//   //         });
//   //   }
//     // try {
//     //   if (Platform.isAndroid) {
//     //     final status = await Permission.storage.status;
//     //     if (status != PermissionStatus.granted) {
//     //       final result = await Permission.storage.request();
//     //       if (result != PermissionStatus.granted) {
//     //         // Handle the case where permission is denied
//     //         return;
//     //       }
//     //     }
//     //   }

//     //   Directory appDocDir = await getApplicationDocumentsDirectory();
//     //   String name = DateTime.now().millisecondsSinceEpoch.toString();
//     //   print("$appDocDir/$name");
//     //   await FlutterDownloader.enqueue(
//     //     url: url,
//     //     savedDir: appDocDir.path,
//     //     fileName: name,
//     //     showNotification: true,
//     //     openFileFromNotification: true,
//     //   );
//     // } catch (e) {
//     //   print("Error downloading file: $e");
//     //   // Handle the error as needed
//     // }
//   }

//   // Future<String> getFilePath() async {
//   //   Directory appDocDir = await getApplicationDocumentsDirectory();
//   //   String appDocPath = appDocDir.path;
//   //   String date = DateTime.now().millisecond.toString().replaceAll(" ", "");
//   //   return join(appDocPath, date);
//   // }

//   // Future<void> saveFileLocally(String filename, List<int> bytes) async {
//   //   Directory directory = await getApplicationDocumentsDirectory();
//   //   String path = join(directory.path, filename);
//   //   File file = File(path);
//   //   await file.writeAsBytes(bytes);
//   //   print("File saved at $path");
//   // }
// }
