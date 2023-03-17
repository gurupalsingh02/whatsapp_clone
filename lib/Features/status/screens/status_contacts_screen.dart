import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Common/widgets/loader.dart';
import 'package:whatsapp_clone/Features/status/controllers/status_controller.dart';
import 'package:whatsapp_clone/Features/status/screens/status_screen.dart';
import 'package:whatsapp_clone/Models/status_model.dart';

class StatusContactsScreen extends ConsumerWidget {
  const StatusContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Status>>(
        future: ref.read(statusControllerProvider).getStatus(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var statusData = snapshot.data![index];
                return Column(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, StatusScreen.routename,
                              arguments: {'status': statusData});
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(statusData.profilePic)),
                          title: Text(statusData.userName),
                        )),
                    const Divider()
                  ],
                );
              });
        });
  }
}
