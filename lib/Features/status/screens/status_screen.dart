import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';
import 'package:whatsapp_clone/Common/widgets/loader.dart';
import 'package:whatsapp_clone/Models/status_model.dart';

class StatusScreen extends StatefulWidget {
  static const routename = 'status_screen';
  final Status status;

  const StatusScreen({super.key, required this.status});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

StoryController storyController = StoryController();
List<StoryItem> storyItems = [];

class _StatusScreenState extends State<StatusScreen> {
  @override
  void initState() {
    super.initState();
    initStoryPageItems();
  }

  void initStoryPageItems() {
    storyItems = [];
    for (int i = 0; i < widget.status.photoUrl.length; i++) {
      storyItems.add(StoryItem.pageImage(
          url: widget.status.photoUrl[i], controller: storyController));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItems.isEmpty
          ? const Loader()
          : StoryView(
              storyItems: storyItems,
              controller: storyController,
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) Navigator.pop(context);
              }),
    );
  }
}
