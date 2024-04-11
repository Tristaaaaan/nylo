import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:study_buddy/structure/services/storage_service.dart';

final uploadFileProvider = StateProvider.autoDispose<Storage>((ref) {
  return Storage();
});
final pathNameProvider = StateProvider<String>((ref) => '');
final fileNameProvider = StateProvider<String>((ref) => '');
final documentTypeProvider = StateProvider<String>((ref) => '');
