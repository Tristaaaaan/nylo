import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:study_buddy/components/textfields/rounded_textfield_title.dart';
import 'package:study_buddy/structure/auth/auth_service.dart';
import 'package:study_buddy/structure/providers/university_provider.dart';
import 'package:study_buddy/structure/providers/user_provider.dart';

class EditProfilePage extends ConsumerWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final AuthService _auth = AuthService();
  final TextEditingController _nameController = TextEditingController();
  EditProfilePage({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo =
        ref.watch(userInfoProvider(_firebaseAuth.currentUser!.uid));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();

              if (_nameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    content: Row(
                      children: [
                        Icon(
                          Icons.notifications,
                          color:
                              Theme.of(context).colorScheme.tertiaryContainer,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Please enter your name",
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                ref.read(userInfoService).changeProfilePicture(
                      ref.watch(editProfilePathNameProvider).toString(),
                      ref.watch(editProfileNameProvider),
                      _firebaseAuth.currentUser!.uid,
                      ref.watch(setGlobalUniversityId),
                      _nameController.text,
                    );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(
                          Icons.notifications,
                          color:
                              Theme.of(context).colorScheme.tertiaryContainer,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Your profile picture has been updated",
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                          ),
                        ),
                      ],
                    ),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    elevation: 4,
                    padding: const EdgeInsets.all(20),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Text(
              "SAVE",
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 125,
                  width: 125,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        final result = await FilePicker.platform.pickFiles(
                          allowMultiple: false,
                          type: FileType.custom,
                          allowedExtensions: [
                            'jpg',
                            'png',
                          ],
                        );

                        if (result == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("No image has been selected."),
                            ),
                          );
                          return;
                        }
                        final path = result.files.single.path;
                        final filename = result.files.single.name;

                        ref.read(editProfilePathProvider.notifier).state =
                            File(path.toString());

                        print("path: ${path.toString()}");

                        ref.read(editProfilePathNameProvider.notifier).state =
                            path.toString();

                        ref.read(editProfileNameProvider.notifier).state =
                            filename;
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor:
                                Theme.of(context).colorScheme.tertiaryContainer,
                          ),
                          userInfo.when(
                            data: (data) {
                              _nameController.text = data.name;
                              return CircleAvatar(
                                backgroundImage: NetworkImage(
                                  data.imageUrl,
                                ),
                                radius: 55,
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
                          if (ref.watch(editProfilePathProvider) != null)
                            CircleAvatar(
                              backgroundImage: FileImage(
                                  ref.watch(editProfilePathProvider)!),
                              radius: 55,
                            ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                radius: 13,
                                child: const Icon(Icons.add),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                RoundedTextFieldTitle(
                  title: "Name",
                  hinttext: "Enter your name",
                  controller: _nameController,
                  onChange: null,
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
