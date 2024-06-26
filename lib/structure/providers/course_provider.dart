// collect to all the document
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:study_buddy/structure/models/user_courses.dart';
import 'package:study_buddy/structure/providers/university_provider.dart';
import 'package:study_buddy/structure/services/course_services.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
final multipleStudentCoursesInformationProvider =
    StreamProvider.family<List<StudentCoursesModel>, String>((ref, userId) {
  final institutionId = ref.watch(setGlobalUniversityId);
  final getUserCourses = _firestore
      .collection("institution")
      .doc(institutionId)
      .collection('students')
      .doc(userId)
      .collection("courses")
      .snapshots()
      .map(
        (querySnapshot) => querySnapshot.docs
            .map(
              (snapshot) => StudentCoursesModel.fromSnapshot(snapshot),
            )
            .toList(),
      );
  return getUserCourses;
});

final currentStudentCoursesInformationProvider =
    StreamProvider.family<List<StudentCoursesModel>, String>((ref, userId) {
  final institutionId = ref.watch(setGlobalUniversityId);

  final getCurrentUserCourses = _firestore
      .collection("institution")
      .doc(institutionId)
      .collection('students')
      .doc(userId)
      .collection("courses")
      .snapshots()
      .map(
        (querySnapshot) => querySnapshot.docs
            .map(
              (snapshot) => StudentCoursesModel.fromSnapshot(snapshot),
            )
            .where((course) => !course.isCompleted)
            .toList(),
      );
  return getCurrentUserCourses;
});

final completedStudentCoursesInformationProvider =
    StreamProvider.family<List<StudentCoursesModel>, String>((ref, userId) {
  final institutionId = ref.watch(setGlobalUniversityId);

  final getCompletedUserCourses = _firestore
      .collection("institution")
      .doc(institutionId)
      .collection('students')
      .doc(userId)
      .collection("courses")
      .snapshots()
      .map(
        (querySnapshot) => querySnapshot.docs
            .map(
              (snapshot) => StudentCoursesModel.fromSnapshot(snapshot),
            )
            .where((course) => course.isCompleted)
            .toList(),
      );
  return getCompletedUserCourses;
});

// search course
final unenrolledCoursesProvider = StreamProvider.autoDispose
    .family<List<Map<String, dynamic>>, String>((ref, userId) {
  final searchQuery = ref.watch(courseSearchQueryProvider);
  final institutionId = ref.watch(setGlobalUniversityId);

  final stream = _firestore
      .collection("institution")
      .doc(institutionId)
      .collection("subjects")
      .snapshots()
      .map((querySnapshot) => querySnapshot.docs
          .map((snapshot) => {
                'subjectId': snapshot.id,
                'subject_code': snapshot.data()['subject_code'],
                'subject_title': snapshot.data()['subject_title'],
                'studentId': snapshot.data()['studentId'],
              })
          .where((group) =>
              !group['studentId'].contains(userId) &&
              (group['subject_code']
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) ||
                  group['subject_title']
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) ||
                  searchQuery.isEmpty))
          .toList());

  return stream;
});

// ======================= STATE PROVIDERS =============================

final courseSearchQueryProvider = StateProvider<String>((ref) => '');

final courseSearchQueryLengthProvider = StateProvider<int>((ref) => 0);

final courseProvider = StateProvider.autoDispose<Courses>((ref) {
  return Courses();
});

final isNotCompleted = StateProvider<bool>((ref) => true);
