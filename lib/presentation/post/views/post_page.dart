import "package:cached_network_image/cached_network_image.dart";
import "package:card_loading/card_loading.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../core/resources/style.dart";
import "../../../core/utilities/utils.dart";
import "../../../data/sources/api/post_service.dart";
import "../../../domain/entities/post.dart";
import "../../site/bloc/site_bloc.dart";
import "../comments/views/comments_page.dart";
import "../cubit/post_cubit.dart";
import "../details/views/details_page.dart";
import "../likes/views/likes_page.dart";
import "../map/views/map_page.dart";

class PostPage extends StatelessWidget {
  final PostData data;

  const PostPage(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (context) => PostCubit(data),
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
    final post = state.data.post;
    final likes = state.data.likes;
    final comments = state.data.comments;
    final isLided = state.data.isLiked;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => _goToDetailsPage(context, post),
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
            likes+comments == 0 ? const SizedBox() : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                likes == 0 ? const SizedBox() : GestureDetector(
                  onTap: () => _goToLikesPage(context, post.id),
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
                          "$likes", 
                          style: AppStyle.caption1(),
                        ),
                      ],
                    ),
                  ),
                ),
                comments == 0 ? const SizedBox() : GestureDetector(
                  onTap: () => _goToCommentsPage(context, post.id),
                  behavior: HitTestBehavior.translucent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${comments} ${comments > 1 ? "comments" : "comment"}", 
                      style: AppStyle.caption1(),
                    ),
                  ),
                ),
              ],
            ),
            comments+likes == 0 ? const SizedBox() : Padding(
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
    );
  }

  Future<void> _goToLikesPage(BuildContext context, String postId) {
    return Navigator.push<void>(context, MaterialPageRoute(
      builder: (context) => const LikesPage(), 
      settings: RouteSettings(name: "/likes", arguments: postId),
    )).then((_) => context.read<PostCubit>().updatePostInfo());
  }

  Future<void> _goToCommentsPage(BuildContext context, String postId) {
    return Navigator.push<void>(context, MaterialPageRoute(
      builder: (context) => const CommentsPage(), 
      settings: RouteSettings(name: "/comments", arguments: postId),
    )).then((_) => context.read<PostCubit>().updatePostInfo());
  }

  Future<void> _goToMapPage(BuildContext context, String postId) {
    return Navigator.push<void>(context, MaterialPageRoute(
      builder: (context) => const MapPage(), 
      settings: RouteSettings(name: "/map", arguments: postId),
    ));
  }

  Future<void> _goToDetailsPage(BuildContext context, Post post) {
    return Navigator.push<void>(context, MaterialPageRoute(
      builder: (context) => const DetailsPage(), 
      settings: RouteSettings(name: "/details", arguments: post),
    ));
  }

  Widget _likeButton(BuildContext context, PostLoaded state) {
    return GestureDetector(
      onTap: context.read<PostCubit>().likePost,
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            state.data.isLiked 
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
              style: state.data.isLiked
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
      onTap: () => _goToCommentsPage(context, state.data.post.id),
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
    final record = state.data.post.record;
    final distanceMap = MyUtils.getFormattedDistance(record.distance);
    final caloriesMap = MyUtils.getFormattedCalories(record.calories);
    final [hours, minutes, seconds] = state.time;
    var timeWidget = Row(children: [
      Text("$seconds", style: AppStyle.heading4()),
      Text("s", style: AppStyle.heading5()),
    ]);
    if(hours > 0) {
      timeWidget = Row(children: [
        Text("$hours", style: AppStyle.heading4()),
        Text("h ", style: AppStyle.heading5()),
        Text("$minutes", style: AppStyle.heading4()),
        Text("m", style: AppStyle.heading5()),
      ]);
    }else if(minutes > 0) {
      timeWidget = Row(children: [
        Text("$minutes", style: AppStyle.heading4()),
        Text("m ", style: AppStyle.heading5()),
        Text("$seconds", style: AppStyle.heading4()),
        Text("s", style: AppStyle.heading5()),
      ]);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(state.data.post.title, style: AppStyle.heading5()),
        const SizedBox(height: 4.0),
        GestureDetector(
          onTap: () {
            if(state.readMore) {
              context.read<PostCubit>().toggleReadMore();
            }
          },
          child: Text(
            state.data.post.content, 
            style: AppStyle.bodyText(fontSize: 14.0),
            maxLines: state.readMore ? null : 2, 
            overflow: state.readMore ? null : TextOverflow.ellipsis,
          ),
        ),
        state.data.post.content.isNotEmpty ? state.readMore ? const SizedBox(height: 12.0) : GestureDetector(
          onTap: context.read<PostCubit>().toggleReadMore,
          behavior: HitTestBehavior.translucent,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 12.0, 12.0),
            child: Text("Read more", style: AppStyle.caption2Bold()),
          ),
        ) : const SizedBox(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Distance", style: AppStyle.caption1()),
                Row(children: [
                  Text("${distanceMap["value"]!} ", style: AppStyle.heading4()),
                  Text(distanceMap["unit"]!, style: AppStyle.heading5()),
                ]),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Time", style: AppStyle.caption1()),
                timeWidget,
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Calories", style: AppStyle.caption1()),
                Row(children: [
                  Text("${caloriesMap["value"]!} ", style: AppStyle.heading4()),
                  Text(caloriesMap["unit"]!, style: AppStyle.heading5()),
                ]),
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
        onTap: () async {
          context.read<SiteBloc>().add(NavbarHidden());
          await _goToMapPage(context, state.data.post.id);
          await Future.delayed(const Duration(milliseconds: 500))
              .then((_) => context.read<SiteBloc>().add(NavbarShown()));
        },
        child: CachedNetworkImage(
          imageUrl: state.data.post.mapUrl,
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
    final author = state.data.post.author;
    const avatarSize = 32;
    return Row(
      children: [
        GestureDetector(
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
                    " ${state.data.post.address}", 
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