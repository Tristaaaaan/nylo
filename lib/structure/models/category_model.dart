import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:study_buddy/pages/home/create_study_group.dart';
import 'package:study_buddy/pages/home/my_courses.dart';
import 'package:study_buddy/pages/home/my_study_groups.dart';
import 'package:study_buddy/pages/home/search_study_group.dart';
import 'package:study_buddy/structure/providers/groupchat_provider.dart';

class CategoryModel {
  String name;
  String iconPath;
  Color backgroundColor;
  VoidCallback? onTap;
  String caption;

  CategoryModel({
    required this.name,
    required this.iconPath,
    required this.backgroundColor,
    required this.onTap,
    required this.caption,
  });

  static List<CategoryModel> getCategories(
      BuildContext context, WidgetRef ref) {
    List<CategoryModel> categories = [];

    categories.add(
      CategoryModel(
        name: "Courses",
        iconPath: 'assets/icons/study-student_svgrepo.com.svg',
        backgroundColor: const Color.fromARGB(255, 222, 159, 172),
        caption: "Check your courses",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FindCourses(),
            ),
          );
        },
      ),
    );

    categories.add(
      CategoryModel(
        name: "Study Groups",
        iconPath: 'assets/icons/users-group_svgrepo.com.svg',
        backgroundColor: const Color.fromARGB(255, 222, 159, 172),
        caption: "Communicate with your circle",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              settings: const RouteSettings(name: "/MyChats"),
              builder: (context) => FindPage(),
            ),
          );
        },
      ),
    );

    categories.add(
      CategoryModel(
        name: "Create",
        caption: "Lead the study group",
        iconPath:
            'assets/icons/book-shelf-books-education-learning-school-study_svgrepo.com.svg',
        backgroundColor: const Color.fromARGB(255, 222, 159, 172),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateStudyGroup(),
            ),
          );
        },
      ),
    );

    categories.add(
      CategoryModel(
        caption: "Connect with other groups",
        name: "Find",
        iconPath: 'assets/icons/search-phone_svgrepo.com.svg',
        backgroundColor: const Color.fromARGB(255, 222, 159, 172),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FindStudyGroup(),
            ),
          );
          ref.read(searchQueryLengthProvider.notifier).update((state) => 0);
          ref.read(searchQueryProvider.notifier).update((state) => '');
        },
      ),
    );

    return categories;
  }
}
