import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/style.dart';
import '../../../../core/utilities/utils.dart';
import '../../../../domain/entities/post.dart';
import '../../../site/bloc/site_bloc.dart';
import '../../../widgets/loading_indicator.dart';
import '../cubit/post_cubit.dart';

class PostPage extends StatelessWidget {
  final Post post;
  const PostPage(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (context) => PostCubit(post),
      child: const PostView(),
    );
  }
}

class PostView extends StatelessWidget {
  const PostView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        if(state is PostLoading) {
          return const AppLoadingIndicator();
        }
        if(state is PostLoaded) {
          return Container(
            margin: const EdgeInsets.only(top: 8.0),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 10.0, 
                  color: AppStyle.neutralColor400,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context, 
                    "/detailsPage",
                    arguments: state.post,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppStyle.horizontalPadding,
                    ),
                    color: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _headerSection(state),
                        const SizedBox(height: 20.0),
                        _metricsSection(state),
                        const SizedBox(height: 12.0),
                      ],
                    ),
                  ),
                ),
                _mapSection(context, state),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppStyle.horizontalPadding
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      state.likes == 0
                        ? const SizedBox() 
                        : GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context, "/likesPage", 
                            arguments: state.post.id,
                          ),
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Icon(
                                  Icons.thumb_up_rounded, 
                                  size: 20.0, 
                                  color: AppStyle.primaryColor,
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  "${state.likes}", 
                                  style: AppStyle.bodyText(height: 1.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      state.comments == 0 
                        ? const SizedBox()
                        : GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context, "/commentsPage", 
                            arguments: state.post.id,
                          ),
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${state.comments} ", 
                                  style: AppStyle.bodyText(height: 1.0),
                                ),
                                Text("comments", style: AppStyle.bodyText(height: 1.0)),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppStyle.horizontalPadding),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: AppStyle.neutralColor400)),
                  ),
                ),
                const SizedBox(height: 4.0),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppStyle.horizontalPadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _likeButton(context, state),
                      _commentButton(context, state),
                    ],
                  ),
                ),
                const SizedBox(height: 4.0),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _likeButton(BuildContext context, PostLoaded state) {
    return GestureDetector(
      onTap: () => context.read<PostCubit>().likePost(),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            state.isLiked 
                ? const Icon(
                  Icons.thumb_up, 
                  size: 28.0, 
                  color: AppStyle.primaryColor,
                )
                : const Icon(
                  Icons.thumb_up_outlined, 
                  size: 28.0, 
                  color: AppStyle.neutralColor400,
                ),
            const SizedBox(width: 8.0),
            Text(
              "Like", 
              style: state.isLiked
                  ? AppStyle.bodyText(color: AppStyle.primaryColor, height: 1.0)
                  : AppStyle.bodyText(height: 1.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _commentButton(BuildContext context, PostLoaded state) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "/commentsPage", arguments: state.post.id),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.mode_comment_outlined, 
              size: 28.0, 
              color: AppStyle.neutralColor400,
            ),
            const SizedBox(width: 8.0),
            Text(" comments", style: AppStyle.bodyText(height: 1.0)),
          ],
        ),
      ),
    );
  }

  Row _metricsSection(PostLoaded state) {
    final record = state.post.record;
    final distanceMap = MyUtils.getFormattedDistance(record.distance);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              "Distance", 
              style: AppStyle.bodyText(fontSize: 14, height: 1.0),
            ),
            const SizedBox(height: 4.0),
            Text(
              distanceMap["value"]!, 
              style: AppStyle.heading1(height: 1.0),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "Time", 
              style: AppStyle.bodyText(fontSize: 14, height: 1.0),
            ),
            const SizedBox(height: 4.0),
            Text(
              state.recordTime, 
              style: AppStyle.heading1(height: 1.0),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "Calories", 
              style: AppStyle.bodyText(fontSize: 14, height: 1.0),
            ),
            const SizedBox(height: 4.0),
            Text(
              "${record.calories}", 
              style: AppStyle.heading1(height: 1.0),
            ),
          ],
        )
      ],
    );
  }

  Widget _mapSection(BuildContext context, PostLoaded state) {
    return GestureDetector(
      onTap: () async {
        context.read<SiteBloc>().add(NavbarHidden());
        await Navigator.pushNamed<void>(
          context, "/mapPage", 
          arguments: state.post,
        );
        await Future.delayed(const Duration(milliseconds: 500))
            .then((_) => context.read<SiteBloc>().add(NavbarShown()));
      },
      child: AspectRatio(
        aspectRatio: 2 / 1,
        child: Image.network(
          state.post.mapUrl,
          // loadingBuilder: (context, child, loadingProgress) {
          //   return const AppLoadingIndicator();
          // },
          filterQuality: FilterQuality.high,
          fit: BoxFit.contain,
          isAntiAlias: true,
        ),
      ),
    );
  }

  Widget _headerSection(PostLoaded state) {
    final author = state.post.author;
    const avatarSize = 40;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            
          },
          child: CircleAvatar(
            radius: avatarSize/2,
            backgroundColor: AppStyle.surfaceColor,
            backgroundImage: Image.asset(
              "assets/images/avatar.jpg",
              cacheWidth: avatarSize,
              cacheHeight: avatarSize,
              filterQuality: FilterQuality.high,
              isAntiAlias: true,
              fit: BoxFit.contain,
            ).image,
            foregroundImage: CachedNetworkImageProvider(
              author.avatarUrl, 
              maxWidth: avatarSize, 
              maxHeight: avatarSize,
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              GestureDetector(
                onTap: () {

                },
                child: Text(
                  author.username, 
                  style: AppStyle.heading2(height: 1.0),
                ),
              ),
              const SizedBox(height: 2.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${state.txtDate} ",
                    style: AppStyle.bodyText(fontSize: 14.0, height: 1.0),
                  ),
                  Text(
                    ".",
                    style: AppStyle.bodyText(fontSize: 22.0, height: 0.3),
                  ),
                  Text(
                    " ${state.address}", 
                    style: AppStyle.bodyText(fontSize: 14.0, height: 1.0),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8.0),
        Icon(
          Icons.more_horiz_rounded, 
          size: 30.0, 
          color: AppStyle.neutralColor400,
        ),
      ],
    );
  }
}