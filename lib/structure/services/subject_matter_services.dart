import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubjectMatter {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> teachCourse(String subjectMatterId) async {
    // get current info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    // create a new course
    StudentCoursesModel newCourse = StudentCoursesModel(
      courseId: courseId,
      courseCode: courseCode,
      courseTitle: courseTitle,
      isCompleted: false,
      completedDate: null,
      joinedDate: timestamp,
    );

    // add new course to user database
    await _firestore
        .collection('institution')
        .doc(institutionId)
        .collection('students')
        .doc(currentUserId)
        .collection("courses")
        .doc(courseId)
        .set(newCourse.toMap());

    // add the student Id to the list of who taken a specific course
    await FirebaseFirestore.instance
        .collection("institution")
        .doc(institutionId)
        .collection('subjects')
        .doc(courseId)
        .update({
      'studentId': FieldValue.arrayUnion(
        [currentUserId],
      )
    });
  }
}
