import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Common/widgets/utils/utils.dart';
import 'package:whatsapp_clone/Features/group/controller/group_controller.dart';
import 'package:whatsapp_clone/Features/group/widgets/select_contacts_group.dart';
import 'package:whatsapp_clone/colors.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  static const routename = 'create_group_screen';
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  File? image;
  final TextEditingController groupNameController = TextEditingController();
  selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
  }

  void createGroup() {
    if (groupNameController.text.trim().isNotEmpty && image != null) {
      ref.read(groupControllerProvider).createGroup(
          context: context,
          name: groupNameController.text.trim(),
          profilePic: image!,
          selectedContact: ref.read(selectedGroupContactsProvider));
      ref.read(selectedGroupContactsProvider.notifier).update((state) => []);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
      ),
      body: Center(
        child: Column(
          children: [
            Stack(
              children: [
                image == null
                    ? const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(defaultPhotoUrl))
                    : CircleAvatar(
                        radius: 64,
                        backgroundImage: FileImage(image!),
                      ),
                Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                        onPressed: () {
                          selectImage();
                        },
                        icon: const Icon(
                          Icons.add_a_photo,
                        ))),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: groupNameController,
                decoration: const InputDecoration(hintText: 'Enter Group name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  'Select Contacts',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SelectContactsGroup()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createGroup,
        backgroundColor: tabColor,
        child: const Icon(Icons.done, color: Colors.white),
      ),
    );
  }
}
