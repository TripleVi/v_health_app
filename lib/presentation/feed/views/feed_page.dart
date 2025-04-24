import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../core/resources/style.dart";
import "../../friend/views/friend_page.dart";
import "../../post/views/post_page.dart";
import "../../site/bloc/site_bloc.dart";
import "../../widgets/app_bar.dart";
import "../../widgets/card_loading.dart";
import "../../widgets/loading_indicator.dart";
import "../cubit/feed_cubit.dart";

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FeedCubit>(
      create: (context) => FeedCubit(),
      child: Navigator(
        onGenerateRoute: (settings) {
          if (settings.name == "/") {
            return MaterialPageRoute<void>(
              builder: (context) => const FeedView(),
              settings: settings,
            );
          }
          if (settings.name == "/search") {
            return MaterialPageRoute<void>(
              builder: (context) => const FriendPage(),
              settings: settings,
            );
          }
          return null;
        },
        initialRoute: "/",
      ),
    );
  }
}

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
          // print("viewInsets");
          // print(MediaQuery.of(context).viewInsets);
          // print("viewPadding");
          // print(MediaQuery.of(context).viewPadding);
          // print("padding");
          // print(MediaQuery.of(context).padding);
          // print(MediaQuery.of(context).size.height);
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      // resizeToAvoidBottomInset: false,
      appBar: CustomAppBar.get(
        title: "vHealth",
        actions: appBarActions(context),
      ),
      body: BlocBuilder<FeedCubit, FeedState>(
        builder: (context, state) {
          if(state is FeedLoading) {
            return const SingleChildScrollView(
              child: Column(
                children: [
                  AppCardLoading(),
                  AppCardLoading(),
                  AppCardLoading(),
                  AppCardLoading(),
                ],
              ),
            );
          }
          Widget content = const SizedBox();
          if(state is FeedLoaded) {
            content = postList(context, state);
          }else if(state is FeedError) {
            content = Center(child: Text(state.message));
          }
          return content;
        },
      ),
    );
  }

  List<Widget> appBarActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () async {
          context.read<SiteBloc>().add(NavbarHidden());
          await Navigator.pushNamed<void>(context, "/search");
          await Future.delayed(const Duration(milliseconds: 500))
              .then((_) => context.read<SiteBloc>().add(NavbarShown()));
        },
        icon: const Icon(Icons.search_rounded),
      ),
    ];
  }

  Widget postList(BuildContext context, FeedLoaded state) {
    return state.data.isEmpty
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
        : ListView.builder(
            itemCount: state.data.length,
            itemBuilder: (context, index) => PostPage(state.data[index]),
          );
  }
}
