import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../controllers/feedback_controller.dart';
import '../../../data/models/feedback_model.dart';
import '../../../data/services/theme_controller.dart';

class FeedbackView extends GetView<FeedbackController> {
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Obx(() => Scaffold(
            backgroundColor: themeController.isHalloweenTheme.value
                ? ThemeController.halloweenCardBg
                : Theme.of(context).colorScheme.background,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(
                'Feedback',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: themeController.isHalloweenTheme.value
                      ? Colors.white
                      : Theme.of(context).colorScheme.onBackground,
                ),
              ),
              bottom: TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: themeController.isHalloweenTheme.value
                      ? ThemeController.halloweenPrimary.withOpacity(0.1)
                      : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
                labelColor: themeController.isHalloweenTheme.value
                    ? ThemeController.halloweenPrimary
                    : Theme.of(context).colorScheme.primary,
                unselectedLabelColor: themeController.isHalloweenTheme.value
                    ? Colors.white70
                    : Colors.grey,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
                tabs: [
                  Tab(text: 'Public'),
                  Tab(text: 'My Reviews'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _buildPublicFeedbacks(context),
                _buildMyFeedbacks(context),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showAddFeedbackSheet(context),
              backgroundColor: themeController.isHalloweenTheme.value
                  ? ThemeController.halloweenPrimary
                  : Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.add_comment_rounded,
                color: themeController.isHalloweenTheme.value
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          )),
    );
  }

  Widget _buildPublicFeedbacks(BuildContext context) {
    return Obx(() {
      if (controller.publicFeedbacks.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.forum_outlined,
                size: 80,
                color: themeController.isHalloweenTheme.value
                    ? Colors.white24
                    : Colors.grey.shade400,
              ),
              SizedBox(height: 16),
              Text(
                'No feedback yet',
                style: TextStyle(
                  color: themeController.isHalloweenTheme.value
                      ? Colors.white70
                      : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        separatorBuilder: (_, __) => SizedBox(height: 12),
        itemCount: controller.publicFeedbacks.length,
        itemBuilder: (context, index) {
          final feedback = controller.publicFeedbacks[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.zero,
            color: themeController.isHalloweenTheme.value
                ? ThemeController.halloweenCardBg
                : Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: themeController.isHalloweenTheme.value
                            ? ThemeController.halloweenPrimary.withOpacity(0.1)
                            : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        child: Icon(
                          Icons.person_outline,
                          color: themeController.isHalloweenTheme.value
                              ? ThemeController.halloweenPrimary
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Anonymous User',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: themeController.isHalloweenTheme.value
                                    ? Colors.white
                                    : null,
                              ),
                            ),
                            Text(
                              timeago.format(feedback.createdAt),
                              style: TextStyle(
                                color: themeController.isHalloweenTheme.value
                                    ? Colors.white70
                                    : Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    feedback.text,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: themeController.isHalloweenTheme.value
                          ? Colors.white
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

Widget _buildMyFeedbacks(BuildContext context) {
  return Obx(() {
    if (controller.myFeedbacks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 80,
              color: themeController.isHalloweenTheme.value
                  ? Colors.white24
                  : Colors.grey.shade400,
            ),
            SizedBox(height: 16),
            Text(
              'No personal reviews yet',
              style: TextStyle(
                color: themeController.isHalloweenTheme.value
                    ? Colors.white70
                    : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      separatorBuilder: (_, __) => SizedBox(height: 12),
      itemCount: controller.myFeedbacks.length,
      itemBuilder: (context, index) {
        final feedback = controller.myFeedbacks[index];
        return Card(
          elevation: 4,
          margin: EdgeInsets.zero,
          color: themeController.isHalloweenTheme.value
              ? ThemeController.halloweenCardBg
              : Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            title: Text(
              feedback.text,
              style: TextStyle(
                height: 1.5,
                color: themeController.isHalloweenTheme.value
                    ? Colors.white
                    : null,
              ),
            ),
            subtitle: Text(
              timeago.format(feedback.createdAt),
              style: TextStyle(
                color: themeController.isHalloweenTheme.value
                    ? Colors.white70
                    : Colors.grey,
                fontSize: 12,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: themeController.isHalloweenTheme.value
                        ? ThemeController.halloweenPrimary
                        : Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () => _showEditFeedbackSheet(context, feedback),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red.shade400,
                  ),
                  onPressed: () => controller.deleteFeedback(feedback.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  });
}


  void _showAddFeedbackSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: themeController.isHalloweenTheme.value
              ? ThemeController.halloweenCardBg
              : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
                    child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add Feedback',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: themeController.isHalloweenTheme.value
                        ? Colors.white
                        : Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: controller.feedbackTextController,
                  maxLines: 5,
                  style: TextStyle(
                    color: themeController.isHalloweenTheme.value
                        ? Colors.white
                        : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Write your feedback...',
                    hintStyle: TextStyle(
                      color: themeController.isHalloweenTheme.value
                          ? Colors.white70
                          : Colors.grey[400],
                    ),
                    filled: true,
                    fillColor: themeController.isHalloweenTheme.value
                        ? ThemeController.halloweenCardBg
                        : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: controller.addFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeController.isHalloweenTheme.value
                        ? ThemeController.halloweenPrimary
                        : Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: themeController.isHalloweenTheme.value
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditFeedbackSheet(BuildContext context, FeedbackModel feedback) {
    controller.feedbackTextController.text = feedback.text;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: themeController.isHalloweenTheme.value
              ? ThemeController.halloweenCardBg
              : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit Feedback',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: themeController.isHalloweenTheme.value
                      ? Colors.white
                      : Theme.of(context).colorScheme.onBackground,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: controller.feedbackTextController,
                maxLines: 5,
                style: TextStyle(
                  color: themeController.isHalloweenTheme.value
                      ? Colors.white
                      : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Update your feedback...',
                  hintStyle: TextStyle(
                    color: themeController.isHalloweenTheme.value
                        ? Colors.white70
                        : Colors.grey[400],
                  ),
                  filled: true,
                  fillColor: themeController.isHalloweenTheme.value
                      ? ThemeController.halloweenCardBg
                      : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  controller.updateFeedback(feedback.id);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeController.isHalloweenTheme.value
                      ? ThemeController.halloweenPrimary
                      : Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Update',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: themeController.isHalloweenTheme.value
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

