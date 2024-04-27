import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

import "../../../../core/resources/style.dart";
import "../../../../core/utilities/utils.dart";
import "../../../../domain/entities/post.dart";
import "../../../site/bloc/site_bloc.dart";
import "../cubit/post_cubit.dart";

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
    return Container(
      padding: const EdgeInsets.only(top: 8.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      color: AppStyle.surfaceColor,
      child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
            // return Column(
            //   children: [
            //     const CardLoading(
            //       height: 150,
            //       borderRadius: BorderRadius.all(Radius.circular(10)),
            //       margin: EdgeInsets.only(bottom: 10),
            //     ),
            //     const CardLoading(
            //       height: 150,
            //       borderRadius: BorderRadius.all(Radius.circular(10)),
            //       margin: EdgeInsets.only(bottom: 10),
            //     ),
            //   ],
            // );
            // return const SizedBox();
          if(state is PostLoading) {
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => Navigator
              .pushNamed(context, "/detailsPage", arguments: state.post),
          child: Padding(
            padding: const EdgeInsets
                .symmetric(horizontal: AppStyle.horizontalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _headerSection(state),
                const SizedBox(height: 20.0),
                _metricsSection(state),
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
                state.likes == 1
                  ? const SizedBox() 
                  : GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context, "/likesPage", 
                      arguments: state.post.id,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                            style: AppStyle.caption1(),
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
            Padding(
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
        const SizedBox(height: 4.0),
      ],
    );
  }

  Widget _likeButton(BuildContext context, PostLoaded state) {
    return GestureDetector(
      onTap: () => context.read<PostCubit>().likePost(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
      onTap: () => Navigator.pushNamed(context, "/commentsPage", arguments: state.post.id),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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

  Row _metricsSection(PostLoaded state) {
    final record = state.post.record;
    final distanceMap = MyUtils.getFormattedDistance(record.distance);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Distance", 
              style: AppStyle.caption1(),
            ),
            Text(
              distanceMap["value"]!, 
              style: AppStyle.heading4(),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Time", 
              style: AppStyle.caption1(),
            ),
            Text(
              state.recordTime, 
              style: AppStyle.heading4(),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Calories", 
              style: AppStyle.caption1(),
            ),
            Text(
              "${record.calories}", 
              style: AppStyle.heading4(),
            ),
          ],
        )
      ],
    );
  }

  Widget _mapSection(BuildContext context, PostLoaded state) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 180.0),
      child: GestureDetector(
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

  Row _headerSection(PostLoaded state) {
    final author = state.post.author;
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
                    " ${state.address}", 
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