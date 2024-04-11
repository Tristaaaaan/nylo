import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:study_buddy/components/containers/member_request_decision_container.dart';
import 'package:study_buddy/structure/providers/create_group_chat_providers.dart';
import 'package:study_buddy/structure/providers/groupchat_provider.dart';
import 'package:study_buddy/structure/providers/university_provider.dart';

class MembersRequest extends ConsumerWidget {
  final String groupChatId;
  final String groupChatTitle;

  const MembersRequest({
    super.key,
    required this.groupChatId,
    required this.groupChatTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final memberRequestModel = ref.watch(
      singleGroupChatInformationProvider(groupChatId),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Member Request"),
        centerTitle: true,
      ),
      body: memberRequestModel.when(
        data: (memberRequests) {
          if (memberRequests.membersRequestId.isEmpty) {
            return Center(
              child: Text("No member request",
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.tertiaryContainer)),
            );
          } else {
            return auth.currentUser!.uid == memberRequests.creatorId
                ? ListView.builder(
                    itemCount: memberRequests.membersRequestId.length,
                    itemBuilder: (context, index) {
                      final memberRequest =
                          memberRequests.membersRequest[index];
                      final memberRequestId =
                          memberRequests.membersRequestId[index];
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  memberRequest,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            MemberRequestDecisionContainer(
                              text: "Deny",
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              iconColor:
                                  Theme.of(context).colorScheme.inversePrimary,
                              textColor:
                                  Theme.of(context).colorScheme.inversePrimary,
                              icon: Icons.remove_circle_outline,
                              onTap: () async {
                                ref.read(isLoadingProvider.notifier).state =
                                    true;

                                await ref
                                    .read(groupChatMemberRequestProvider)
                                    .acceptOrreject(
                                      groupChatId,
                                      memberRequest,
                                      memberRequestId,
                                      false,
                                      groupChatTitle,
                                      ref.watch(setGlobalUniversityId),
                                    );

                                ref.read(isLoadingProvider.notifier).state =
                                    false;
                              },
                            ),

                            //
                            const SizedBox(
                              width: 5,
                            ),
                            MemberRequestDecisionContainer(
                              text: "Accept",
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                              iconColor:
                                  Theme.of(context).colorScheme.background,
                              textColor:
                                  Theme.of(context).colorScheme.background,
                              icon: Icons.check_circle_outline,
                              onTap: () async {
                                ref.read(isLoadingProvider.notifier).state =
                                    true;

                                await ref
                                    .read(groupChatMemberRequestProvider)
                                    .acceptOrreject(
                                      groupChatId,
                                      memberRequest,
                                      memberRequestId,
                                      true,
                                      groupChatTitle,
                                      ref.watch(setGlobalUniversityId),
                                    );

                                ref.read(isLoadingProvider.notifier).state =
                                    false;
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Container();
          }
        },
        error: (error, stackTrace) {
          return Center(
            child: Text('Error: $error'),
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
