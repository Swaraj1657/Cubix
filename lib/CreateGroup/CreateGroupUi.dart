import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:cubix/CreateGroup/CreateGroupLogic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CometChatCreateGroup extends StatefulWidget {
  const CometChatCreateGroup({Key? key}) : super(key: key);

  @override
  State<CometChatCreateGroup> createState() => _CometChatCreateGroupState();
}

class _CometChatCreateGroupState extends State<CometChatCreateGroup>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late CometChatCreateGroupController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(CometChatCreateGroupController());
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      controller.onTabChanged(_tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.white54 : Colors.black54;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                  child: Icon(Icons.group_outlined, size: 40, color: textColor),
                ),
                const SizedBox(height: 8),
                Text(
                  "New Group",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: hintColor,
            tabs: const [
              Tab(text: "Public"),
              Tab(text: "Private"),
              Tab(text: "Password"),
            ],
          ),
          const SizedBox(height: 16),
          Text("Group Name", style: TextStyle(color: textColor)),
          TextField(
            controller: controller.nameController,
            onChanged: controller.onNameChange,
            decoration: InputDecoration(
              hintText: "Enter group name",
              hintStyle: TextStyle(color: hintColor),
            ),
            style: TextStyle(color: textColor),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller.aboutController,
            onChanged: controller.onAboutChange,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Group About',
              hintText: 'Tell members what this group is about...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => controller.groupType.value == GroupTypeConstants.password
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Password", style: TextStyle(color: textColor)),
                      TextField(
                        controller: controller.passwordController,
                        onChanged: controller.onPasswordChange,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Enter password",
                          hintStyle: TextStyle(color: hintColor),
                        ),
                        style: TextStyle(color: textColor),
                      ),
                      const SizedBox(height: 12),
                    ],
                  )
                : const SizedBox(),
          ),
          Obx(
            () => controller.isEmpty.value || controller.isError.value
                ? Text(
                    controller.isEmpty.value
                        ? "Group name is required"
                        : "Something went wrong",
                    style: const TextStyle(color: Colors.red),
                  )
                : const SizedBox(),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (controller.groupName.isNotEmpty ||
                  (controller.groupType.value == GroupTypeConstants.password &&
                      controller.groupPassword.isNotEmpty)) {
                controller.isEmpty.value = false;
                controller.createGroup(context);
              } else {
                controller.isEmpty.value = true;
              }
            },
            child: Obx(
              () => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : const Text("Create Group"),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

Future showCreateGroup(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: (isDark ? Colors.grey[850] : Colors.grey[200])!
        .withOpacity(0.6),
    builder: (_) => const CometChatCreateGroup(),
  );
}
