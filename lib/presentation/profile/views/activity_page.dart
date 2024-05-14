import "package:flutter/material.dart";

import "../../../core/resources/style.dart";
import "../../../data/sources/api/post_service.dart";
import "../../../domain/entities/post.dart";
import "../../feed/post/views/post_page.dart";
import "../../widgets/app_bar.dart";
import "../../widgets/loading_indicator.dart";

class ActivityContainer extends StatelessWidget {
  const ActivityContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = ModalRoute.of(context)!.settings.arguments as String;
    return ActivityPage(uid: uid);
  }
}

class ActivityPage extends StatefulWidget {
  final String uid;
  const ActivityPage({super.key, required this.uid});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  var loading = true;
  final posts = <Post>[];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final service = PostService();
    final result = await service.fetchPosts(widget.uid);
    setState(() {
      posts.addAll(result);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      appBar: CustomAppBar.get(title: "Your activities"),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 520.0,
            minHeight: MediaQuery.of(context).size.height-152,
          ),
          child: loading 
              ? const AppLoadingIndicator() 
              : mainContent(),
        ),
      ),
    );
  }

  Widget mainContent() {
    return posts.isEmpty 
        ? Container(
          width: double.maxFinite,
          color: AppStyle.surfaceColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/fitness.png",
                cacheWidth: 96,
                cacheHeight: 96,
                filterQuality: FilterQuality.high,
                isAntiAlias: true,
                fit: BoxFit.contain,
              ),
              Text(
                "Let's start recording your workouts now.", 
                style: AppStyle.caption1(),
              ),
            ],
          ),
        ) 
        : Column(
          children: List.generate(posts.length, (index) => 
              PostPage(index, posts[index])),
        );
  }
}
