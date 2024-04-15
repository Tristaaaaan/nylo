import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:study_buddy/structure/services/subject_matter_services.dart';

final courseProvider = StateProvider.autoDispose<SubjectMatter>((ref) {
  return SubjectMatter();
});
