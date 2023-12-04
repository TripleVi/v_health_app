import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/resources/colors.dart';
import '../../../core/resources/style.dart';
import '../../../domain/entities/post.dart';
import '../../notification/view/notifications_page.dart';
import '../../widgets/appBar.dart';
import '../../widgets/loading_indicator.dart';
import '../bloc/feed_bloc.dart';
import '../post/view/post_page.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FeedBloc>(
      create: (context) => FeedBloc(),
      child: Navigator(
        onGenerateRoute: (settings) {
          if(settings.name == "/feed") {
            return MaterialPageRoute<void>(
              builder: (context) => const FeedView(),
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
                style: AppStyle.label(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: CustomAppBar.get(
        title: 'vHealth',
        actions: <Widget>[
          _notificationButton(context),
        ]
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppColor.onBackgroundColor)),
        ),
        child: BlocBuilder<FeedBloc, FeedState>(
          builder: (context, state) {
            if(state is FeedLoading) {
              return const AppLoadingIndicator();
            }
            if(state is FeedLoaded) {
              return _buildListView(state.posts);
            }
            return Center(child: Text((state as FeedError).message));
          },
        ),
      ),
    );
  }

  ListView _buildListView(List<Post> posts) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostPage(posts[index]);
      }
    );
  }
}
