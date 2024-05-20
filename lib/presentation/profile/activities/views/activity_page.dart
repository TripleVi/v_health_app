import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../../core/resources/style.dart";
import "../../../../domain/entities/post.dart";
import "../../../post/views/post_page.dart";
import "../../../widgets/app_bar.dart";
import "../../../widgets/loading_indicator.dart";
import "../cubit/activity_cubit.dart";

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = ModalRoute.of(context)!.settings.arguments as String;
    return BlocProvider<ActivityCubit>(
      create: (context) => ActivityCubit(uid),
      child: const ActivityView(),
    );
  }
}

class ActivityView extends StatelessWidget {
  const ActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityCubit, ActivityState>(
      builder: (context, state) {
        Widget content = const SizedBox();
        var title = "Your activities";
        if(state is ActivityLoading) {
          content = const AppLoadingIndicator();
        }
        if(state is ActivityLoaded) {
          content = mainContent(state);
          if(state.other) title = "Activities";
        }
        return Scaffold(
          backgroundColor: AppStyle.backgroundColor,
          appBar: CustomAppBar.get(title: title),
          body: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 520.0,
              minHeight: MediaQuery.of(context).size.height - 152,
            ),
            child: content,
          ),
        );
      },
    );
  }

  Widget mainContent(ActivityLoaded state) {
    return state.posts.isEmpty
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
                  state.other 
                      ? "Let's start recording your workouts now."
                      : "No activities yet.",
                  style: AppStyle.caption1(),
                ),
              ],
            ),
          )
        : 
        // ListView.builder(
        //     addAutomaticKeepAlives: ,
        //     findChildIndexCallback: (key) {
        //       final ValueKey valueKey = key as ValueKey<Post>;
        //       return state.posts.indexOf(valueKey.value);
        //     },
        //     itemCount: state.posts.length,
        //     itemBuilder: (context, index) => PostPage(index, state.posts[index]),
        //   );
          ListView(children: state.posts.map((e) {
            print(state.posts.length);
            return PostPage(null, e);
          }).toList());
  }
}
