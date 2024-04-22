import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../core/resources/style.dart";
import "../../../domain/entities/post.dart";
import "../../widgets/app_bar.dart";
import "../../widgets/loading_indicator.dart";
import "../comments/views/comments_page.dart";
import "../cubit/feed_cubit.dart";
import "../details/views/details_page.dart";
import "../likes/views/likes_page.dart";
import "../map/views/map_page.dart";
import "../post/views/post_page.dart";

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FeedCubit>(
      create: (context) => FeedCubit(),
      child: Navigator(
        onGenerateRoute: (settings) {
          if(settings.name == "/feed") {
            return MaterialPageRoute<void>(
              builder: (context) => const FeedView(),
              settings: settings,
            );
          }
          if(settings.name == "/likesPage") {
            return MaterialPageRoute<void>(
              builder: (context) => const LikesPage(),
              settings: settings,
            );
          }
          if(settings.name == "/commentsPage") {
            return MaterialPageRoute<void>(
              builder: (context) => const CommentsPage(),
              settings: settings,
            );
          }
          if(settings.name == "/mapPage") {
            return MaterialPageRoute<void>(
              builder: (context) => const MapPage(),
              settings: settings,
            );
          }
          if(settings.name == "/detailsPage") {
            return MaterialPageRoute<void>(
              builder: (context) => const DetailsPage(),
              settings: settings,
            );
          }
          return null;
        },
        initialRoute: "/feed",
      ),
    );
  }
}

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      appBar: CustomAppBar.get(
        title: "vHealth",
        actions: <Widget>[
          _notificationButton(context),
        ]
      ),
      body: RefreshIndicator(
        color: AppStyle.primaryColor,
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 5));
          return context.read<FeedCubit>().pullToRefresh();
        },
        child: BlocBuilder<FeedCubit, FeedState>(
          builder: (context, state) {
            if(state is FeedLoading) {
              return const AppLoadingIndicator();
            }
            if(state is FeedLoaded) {
              return mainContent(state.posts);
            }
            return Center(child: Text((state as FeedError).message));
          },
        ),
      ),
    );
  }

  _notificationButton(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        GestureDetector(
          onTap: () {
            
          },
          child: const Icon(Icons.notifications_rounded, size: 28.0),
        ),
        Positioned(
          left: 24.0,
          top: 24.0,
          child: CircleAvatar(
            backgroundColor: Colors.red,
            minRadius: 8.0,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text("12", 
                style: AppStyle.caption2(
                  fontSize: 12.0,
                  color: Colors.white,
                  height: 1.0,
                )
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget mainContent(List<Post> posts) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 500.0,
      ),
      child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostPage(posts[index]);
        }
      ),
    );
  }
}
