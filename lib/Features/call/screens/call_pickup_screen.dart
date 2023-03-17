import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Features/call/controller/call_controller.dart';
import 'package:whatsapp_clone/Models/call.dart';

class CallPickupScreen extends ConsumerWidget {
  final Widget scaffold;
  const CallPickupScreen({required this.scaffold, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
        stream: ref.watch(callControllerProvider).callSteam,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.data() != null) {
            Call call =
                Call.fromMap(snapshot.data!.data() as Map<String, dynamic>);
            if (!call.hasDialled) {
              return Scaffold(
                body: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'inComing Call',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(call.callerPic),
                        radius: 60,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        call.callerName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(
                        height: 75,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.call_end,
                                color: Colors.redAccent,
                              )),
                          const SizedBox(
                            width: 30,
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.call,
                                color: Colors.green,
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
          }
          return scaffold;
        });
  }
}
