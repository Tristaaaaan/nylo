import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:study_buddy/components/containers/category_container.dart';
import 'package:study_buddy/pages/home/my_profile.dart';
import 'package:study_buddy/structure/models/category_model.dart';
import 'package:study_buddy/structure/providers/groupchat_provider.dart';
import 'package:study_buddy/structure/providers/user_provider.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkMemberRequest =
        ref.watch(userHasStudyGroupRequest(_firebaseAuth.currentUser!.uid));

    final userInfo =
        ref.watch(userInfoProvider(_firebaseAuth.currentUser!.uid));

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Nylo"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: 10,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ),
                  );
                },
                child: userInfo.when(
                  data: (image) {
                    return CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(image.imageUrl),
                    );
                  },
                  error: (error, stackTrace) {
                    return Center(
                      child: Text('Error: $error'),
                    );
                  },
                  loading: () {
                    return Center(
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: ClipRRect(
                child: SvgPicture.asset('assets/icons/image2vector.svg'),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            userInfo.when(
              data: (names) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      names.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
              error: (error, stackTrace) {
                return Center(
                  child: Text('Error: $error'),
                );
              },
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            const SizedBox(
              height: 25,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 30),
              child: Text(
                "Connect with study partners and tutors easily.",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Category",
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    checkMemberRequest.when(
                      data: (value) {
                        print("value: $value");
                        return Expanded(
                          child: GridView.builder(
                            itemCount:
                                CategoryModel.getCategories(context).length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (context, index) {
                              final category =
                                  CategoryModel.getCategories(context)[index];

                              return Category(
                                text: category.name,
                                iconPath: category.iconPath,
                                onTap: category.onTap,
                                caption: category.caption,
                                notification:
                                    category.name == "Study Groups" && value
                                        ? true
                                        : false,
                              );
                            },
                          ),
                        );
                      },
                      error: (error, stackTrace) {
                        return Center(
                          child: Text('Error: $error'),
                        );
                      },
                      loading: () {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
