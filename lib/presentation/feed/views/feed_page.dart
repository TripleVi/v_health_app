import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../core/resources/style.dart";
import "../../../domain/entities/post.dart";
import "../../friend/views/friend_page.dart";
import "../../site/bloc/site_bloc.dart";
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
          if(settings.name == "/searchPage") {
            return MaterialPageRoute<void>(
              builder: (context) => const FriendPage(),
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
        actions: appBarActions(context),
      ),
      body: RefreshIndicator(
        color: AppStyle.primaryColor,
        onRefresh: context.read<FeedCubit>().pullToRefresh,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 520.0,
              minHeight: MediaQuery.of(context).size.height-152,
            ),
            child: BlocBuilder<FeedCubit, FeedState>(
              builder: (context, state) {
                if(state is FeedLoading) {
                  return const AppLoadingIndicator();
                }
                if(state is FeedLoaded) {
                  return mainContent(context, state.posts);
                }
                if(state is FeedRefreshed) {
                  return const SizedBox();
                }
                return Center(child: Text((state as FeedError).message));
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> appBarActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () async {
          context.read<SiteBloc>().add(NavbarHidden());
          await Navigator.pushNamed<void>(context, "/searchPage");
          await Future.delayed(const Duration(milliseconds: 500))
              .then((_) => context.read<SiteBloc>().add(NavbarShown()));
        },
        icon: const Icon(Icons.search_rounded),
      ),
    ];
  }

  Widget mainContent(BuildContext context, List<Post> posts) {
    return posts.isEmpty 
        ? GestureDetector(
          onTap: () {
            context.read<FeedCubit>().test();
          },
          behavior: HitTestBehavior.translucent,
          child: Container(
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
                  "Let's follow people to see their fitness progress", 
                  style: AppStyle.caption1(),
                ),
              ],
            ),
          ),
        ) 
        : Column(
          children: List.generate(posts.length, (index) => 
              PostPage(index, posts[index])),
        );
  }
}
