import "package:cached_network_image/cached_network_image.dart";
import "package:card_loading/card_loading.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../../core/resources/style.dart";
import "../../../../core/utilities/utils.dart";
import "../../../../domain/entities/post.dart";
import "../../../site/bloc/site_bloc.dart";
import "../../cubit/feed_cubit.dart";
import "../cubit/post_cubit.dart";

class PostPage extends StatelessWidget {
  final int index;
  final Post post;
  const PostPage(this.index, this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (context) => PostCubit(index, post),
      child: const PostView(),
    );
  }
}

class PostView extends StatelessWidget {
  const PostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.only(top: 8.0),
      color: AppStyle.surfaceColor,
      child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if(state is PostLoading) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardLoading(
                    height: 30,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    width: 100,
                    margin: EdgeInsets.only(bottom: 10),
                  ),
                  CardLoading(
                    height: 100,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    margin: EdgeInsets.only(bottom: 10),
                  ),
                  CardLoading(
                    height: 30,
                    width: 200,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    margin: EdgeInsets.only(bottom: 10),
                  ),
                ],
              ),
            );
          }
          if(state is PostLoaded) {
            return mainContent(context, state);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget mainContent(BuildContext context, PostLoaded state) {
    return GestureDetector(
      onTapDown: (_) => context.read<FeedCubit>().viewPost(state.index),
      behavior: HitTestBehavior.translucent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTapDown: (_) => context.read<FeedCubit>().viewPost(state.index),
            onTap: () {
              Navigator.pushNamed(context, "/detailsPage", arguments: state.post);
            },
            behavior: HitTestBehavior.translucent,
            child: Padding(
              padding: const EdgeInsets
                  .symmetric(horizontal: AppStyle.horizontalPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _headerSection(context, state),
                  const SizedBox(height: 12.0),
                  _contentSection(context, state),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
          ),
          _mapSection(context, state),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              state.likes+state.comments == 0 ? const SizedBox() : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  state.likes == 0 ? const SizedBox() : GestureDetector(
                    onTapDown: (_) => context.read<FeedCubit>().viewPost(state.index),
                    onTap: () {
                      Navigator
                          .pushNamed(context, "/likesPage", arguments: state.post.id)
                          .then((_) => context.read<PostCubit>().updatePostInfo());
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.thumb_up_rounded, 
                            size: 20.0, 
                            color: AppStyle.primaryColor,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            "${state.likes}", 
                            style: AppStyle.caption1(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  state.comments == 0 ? const SizedBox() : GestureDetector(
                    onTapDown: (_) => context.read<FeedCubit>().viewPost(state.index),
                    onTap: () {
                      Navigator.pushNamed<void>(
                          context, "/commentsPage", arguments: state.post.id)
                          .then((_) => context.read<PostCubit>().updatePostInfo());
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${state.comments} ${state.comments > 1 ? "comments" : "comment"}", 
                        style: AppStyle.caption1(),
                      ),
                    ),
                  ),
                ],
              ),
              state.comments+state.likes == 0 ? const SizedBox() : Padding(
                padding: const EdgeInsets
                    .symmetric(horizontal: AppStyle.horizontalPadding),
                child: Container(
                  height: 1.0,
                  color: AppStyle.neutralColor200,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _likeButton(context, state),
              _commentButton(context, state),
            ],
          ),
        ],
      ),
    );
  }

  Widget _likeButton(BuildContext context, PostLoaded state) {
    return GestureDetector(
      onTapDown: (_) => context.read<FeedCubit>().viewPost(state.index),
      onTap: context.read<PostCubit>().likePost,
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            state.isLiked 
                ? const Icon(
                  Icons.thumb_up, 
                  size: 20.0, 
                  color: AppStyle.primaryColor,
                )
                : const Icon(
                  Icons.thumb_up_outlined, 
                  size: 20.0, 
                  color: AppStyle.neutralColor400,
                ),
            const SizedBox(width: 8.0),
            Text(
              "Like", 
              style: state.isLiked
                  ? AppStyle.caption1(color: AppStyle.primaryColor)
                  : AppStyle.caption1(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _commentButton(BuildContext context, PostLoaded state) {
    return GestureDetector(
      onTapDown: (_) => context.read<FeedCubit>().viewPost(state.index),
      onTap: () {
        Navigator
            .pushNamed(context, "/commentsPage", arguments: state.post.id)
            .then((_) => context.read<PostCubit>().updatePostInfo());
      },
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.mode_comment_outlined, 
              size: 20.0, 
              color: AppStyle.neutralColor400,
            ),
            const SizedBox(width: 8.0),
            Text("Comment", style: AppStyle.caption1()),
          ],
        ),
      ),
    );
  }

  Widget _contentSection(BuildContext context, PostLoaded state) {
    final record = state.post.record;
    final distanceMap = MyUtils.getFormattedDistance(record.distance);
    final caloriesMap = MyUtils.getFormattedCalories(record.calories);
    final activeTime = MyUtils.getFormattedMinutes(record.activeTime);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(state.post.title, style: AppStyle.heading5()),
        const SizedBox(height: 4.0),
        GestureDetector(
          onTapDown: (_) => context.read<FeedCubit>().viewPost(state.index),
          onTap: () {
            if(state.readMore) {
              context.read<PostCubit>().toggleReadMore();
            }
          },
          child: Text(
            state.post.content, 
            style: AppStyle.bodyText(fontSize: 14.0),
            maxLines: state.readMore ? null : 2, 
            overflow: state.readMore ? null : TextOverflow.ellipsis,
          ),
        ),
        state.readMore ? const SizedBox(height: 12.0) : GestureDetector(
          onTapDown: (_) => context.read<FeedCubit>().viewPost(state.index),
          onTap: context.read<PostCubit>().toggleReadMore,
          behavior: HitTestBehavior.translucent,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 12.0, 12.0),
            child: Text("Read more", style: AppStyle.caption2Bold()),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Distance", style: AppStyle.caption1()),
                Row(
                  children: [
                    Text("${distanceMap["value"]!} ", style: AppStyle.heading4()),
                    Text(distanceMap["unit"]!, style: AppStyle.heading5()),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Time", style: AppStyle.caption1()),
                Text(activeTime, style: AppStyle.heading4()),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Calories", style: AppStyle.caption1()),
                Row(
                  children: [
                    Text("${caloriesMap["value"]!} ", style: AppStyle.heading4()),
                    Text(caloriesMap["unit"]!, style: AppStyle.heading5()),
                  ],
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget _mapSection(BuildContext context, PostLoaded state) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 180.0),
      child: GestureDetector(
        onTapDown: (_) => context.read<FeedCubit>().viewPost(state.index),
        onTap: () async {
          context.read<SiteBloc>().add(NavbarHidden());
          await Navigator.pushNamed<void>(
            context, "/mapPage", 
            arguments: state.post,
          );
          await Future.delayed(const Duration(milliseconds: 500))
              .then((_) => context.read<SiteBloc>().add(NavbarShown()));
        },
        child: CachedNetworkImage(
          imageUrl: state.post.mapUrl,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          progressIndicatorBuilder: (context, url, download) => Container(
            color: AppStyle.backgroundColor,
            child: Center(
              child: CircularProgressIndicator(value: download.progress)
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }

  Row _headerSection(BuildContext context, PostLoaded state) {
    final author = state.post.author;
    const avatarSize = 32;
    return Row(
      children: [
        GestureDetector(
          onTapDown: (_) => context.read<FeedCubit>().viewPost(state.index),
          onTap: () async {

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTapDown: (_) => context.read<FeedCubit>().viewPost(state.index),
                onTap: () {

                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    author.username, 
                    style: AppStyle.heading5(),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    "${state.txtDate} ",
                    style: AppStyle.caption2(),
                  ),
                  const SizedBox(width: 4.0),
                  Container(
                    width: 4.0,
                    height: 4.0,
                    decoration: const BoxDecoration(
                      color: AppStyle.secondaryTextColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    " ${state.post.address}", 
                    style: AppStyle.caption2(),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8.0),
        const Icon(
          Icons.more_horiz_rounded, 
          size: 24.0, 
          color: AppStyle.neutralColor400,
        ),
      ],
    );
  }
}