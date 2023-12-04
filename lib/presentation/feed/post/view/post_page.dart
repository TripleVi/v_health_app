import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/colors.dart';
import '../../../../core/resources/style.dart';
import '../../../../core/utilities/utils.dart';
import '../../../../domain/entities/post.dart';
import '../../../widgets/loading_indicator.dart';
import '../../comments/view/comments_page.dart';
import '../../details/view/details_page.dart';
import '../../map/view/map_page.dart';
import '../cubit/post_cubit.dart';
import '../../likes/view/likes_page.dart';

class PostPage extends StatelessWidget {
  final Post _post;
  const PostPage(this._post, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (context) => PostCubit(_post),
      child: PostView(_post.id),
    );
  }
}

class PostView extends StatelessWidget {
  final String _postId;

  const PostView(this._postId, {super.key});

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
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 10.0, 
                  color: AppColor.onBackgroundColor,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(_postId),
                    ),
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
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) 
                                => LikesPage(state.post.id)),
                          );
                        },
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
                                color: AppColor.primaryColor,
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                "${state.likes}", 
                                style: AppStyle.paragraph(height: 1.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => CommentsPage(state.post.id)),
                          );
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${state.comments} ", 
                                style: AppStyle.paragraph(height: 1.0),
                              ),
                              Text("comments", style: AppStyle.paragraph(height: 1.0)),
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
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: AppColor.onBackgroundColor)),
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
      onTap: () => context.read<PostCubit>().handleLikePost(),
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
                  color: AppColor.primaryColor,
                )
                : Icon(
                  Icons.thumb_up_outlined, 
                  size: 28.0, 
                  color: AppColor.onBackgroundColor,
                ),
            const SizedBox(width: 8.0),
            Text(
              "Like", 
              style: state.isLiked
                  ? AppStyle.paragraph(color: AppColor.primaryColor, height: 1.0)
                  : AppStyle.paragraph(height: 1.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _commentButton(BuildContext context, PostLoaded state) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => CommentsPage(state.post.id)),
      ),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mode_comment_outlined, 
              size: 28.0, 
              color: AppColor.onBackgroundColor,
            ),
            const SizedBox(width: 8.0),
            Text(" comments", style: AppStyle.paragraph(height: 1.0)),
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
              style: AppStyle.paragraph(fontSize: 14, height: 1.0),
            ),
            const SizedBox(height: 4.0),
            Text(
              distanceMap["value"]!, 
              style: AppStyle.heading_1(height: 1.0),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "Time", 
              style: AppStyle.paragraph(fontSize: 14, height: 1.0),
            ),
            const SizedBox(height: 4.0),
            Text(
              state.recordTime, 
              style: AppStyle.heading_1(height: 1.0),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "Calories", 
              style: AppStyle.paragraph(fontSize: 14, height: 1.0),
            ),
            const SizedBox(height: 4.0),
            Text(
              "${record.calories}", 
              style: AppStyle.heading_1(height: 1.0),
            ),
          ],
        )
      ],
    );
  }

  Widget _mapSection(BuildContext context, PostLoaded state) {
    final post = state.post;
    return GestureDetector(
      onTap: () async {
        // final state = mainContainerKey.currentState!;
        // state.hideBottomNavBar();
        // Navigator.push(context, MaterialPageRoute(
        //   builder: (context) => MapPage(post.id, post.user!.username),
        // )).then((_) {
        //   state.showBottomNavBar();
        // });
      },
      child: AspectRatio(
        aspectRatio: 2 / 1,
        child: Image.network(
          post.mapUrl,
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
    final user = state.post.user;
    const avatarSize = 40;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            
          },
          child: CircleAvatar(
            radius: avatarSize/2,
            backgroundColor: AppColor.backgroundColor,
            backgroundImage: Image.asset(
              "assets/images/avatar.jpg",
              cacheWidth: avatarSize,
              cacheHeight: avatarSize,
              filterQuality: FilterQuality.high,
              isAntiAlias: true,
              fit: BoxFit.contain,
            ).image,
            foregroundImage: Image.network(
              user.avatarUrl,
              cacheWidth: avatarSize,
              cacheHeight: avatarSize,
              filterQuality: FilterQuality.high,
              isAntiAlias: true,
              fit: BoxFit.contain,
            ).image,
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
                  user.username, 
                  style: AppStyle.heading_2(height: 1.0),
                ),
              ),
              const SizedBox(height: 2.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${state.txtDate} ",
                    style: AppStyle.paragraph(fontSize: 14.0, height: 1.0),
                  ),
                  Text(
                    ".",
                    style: AppStyle.paragraph(fontSize: 22.0, height: 0.3),
                  ),
                  Text(
                    " ${state.address}", 
                    style: AppStyle.paragraph(fontSize: 14.0, height: 1.0),
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
          color: AppColor.onBackgroundColor,
        ),
      ],
    );
  }
}