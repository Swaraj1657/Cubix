import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:cubix/Message/MessageScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CometChatCreateGroupController extends GetxController {
  BuildContext? context;
  late TabController tabController;

  CometChatCreateGroupController() {
    tag = "tag\$counter";
    counter++;
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void tabControllerListener() {
    if (tabController.index == 0) {
      groupType.value = GroupTypeConstants.public;
    } else if (tabController.index == 1) {
      groupType.value = GroupTypeConstants.private;
    } else if (tabController.index == 2) {
      groupType.value = GroupTypeConstants.password;
    }
  }

  void onTabChanged(int index) {
    if (index == 0) {
      groupType.value = GroupTypeConstants.public;
    } else if (index == 1) {
      groupType.value = GroupTypeConstants.private;
    } else if (index == 2) {
      groupType.value = GroupTypeConstants.password;
    }
    update();
  }

  static int counter = 0;
  late String tag;

  var groupType = GroupTypeConstants.public.obs;
  var groupName = ''.obs;
  var groupPassword = ''.obs;
  var groupAbout = ''.obs;

  var isLoading = false.obs;
  var isEmpty = false.obs;
  var isError = false.obs;

  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final aboutController = TextEditingController();

  void onPasswordChange(String val) {
    groupPassword.value = val;
  }

  void onNameChange(String val) {
    groupName.value = val;
  }

  void onAboutChange(String val) {
    groupAbout.value = val;
  }

  void createGroup(BuildContext context) async {
    if (groupName.value.trim().isEmpty) {
      debugPrint("Group name cannot be empty.");
      isLoading.value = false;
      isError.value = true;
      return;
    }

    if (groupType.value == GroupTypeConstants.password &&
        groupPassword.value.trim().isEmpty) {
      debugPrint("Password required for password-protected group.");
      isLoading.value = false;
      isError.value = true;
      return;
    }

    if (groupAbout.value.trim().length > 300) {
      debugPrint("Group about must be under 300 characters.");
      isLoading.value = false;
      isError.value = true;
      return;
    }
    String gUid = "group_${DateTime.now().millisecondsSinceEpoch}";

    isLoading.value = true;

    Group group = Group(
      guid: gUid,
      name: groupName.value.trim(),
      description: groupAbout.value.trim(),
      type: groupType.value,
      password: groupType.value == GroupTypeConstants.password
          ? groupPassword.value.trim()
          : null,
    );

    CometChat.createGroup(
      group: group,
      onSuccess: (Group group) {
        debugPrint("Group Created Successfully: $group");
        isLoading.value = false;
        isError.value = false;
        Navigator.pop(context);
        CometChatGroupEvents.ccGroupCreated(group);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MessagesScreen(group: group)),
        );
      },
      onError: (CometChatException e) {
        isLoading.value = false;
        isError.value = true;
        debugPrint("Group Creation failed with exception: ${e.message}");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
      },
    );
  }
}
