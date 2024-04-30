import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:timeago/timeago.dart" as timeago;

import "../../../../../../core/resources/style.dart";
import "../../../../../../domain/entities/comment.dart";
import "../../cubit/comments_cubit.dart";
import "../../views/posting_comment.dart";
import "../cubit/block_cubit.dart";

class CommentBlock extends StatelessWidget {
  final String postId;
  final Comment comment;

  const CommentBlock(this.postId, this.comment, {super.key});
  
  @override
  Widget build(BuildContext context) {
    const avatarSize = 40;
    return BlocProvider<BlockCubit>(
      create: (context) => BlockCubit(postId, comment),
      child: BlocConsumer<BlockCubit, BlockState>(
        listener: (context, state) {
          if(state is BlockLoaded && state.snackMsg != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppStyle.backgroundColor,
              showCloseIcon: true,
              closeIconColor: AppStyle.secondaryIconColor,
              content: Text(
                state.snackMsg!,
                style: AppStyle.bodyText(),
              ),
            ));
          }
        },
        builder: (context, state) {
          return Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: avatarSize/2,
                  backgroundColor: AppStyle.surfaceColor,
                  backgroundImage: Image.asset(
                    "assets/images/avatar.jpg",
                    cacheWidth: avatarSize,
                    cacheHeight: avatarSize,
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.contain,
                    isAntiAlias: true,
                  ).image,
                  foregroundImage: CachedNetworkImageProvider(
                    comment.author.avatarUrl, 
                    maxWidth: avatarSize, 
                    maxHeight: avatarSize,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${comment.author.username} ",
                                      style: AppStyle.caption2Bold(
                                        color: AppStyle.primaryTextColor,
                                      ),
                                    ),
                                    Text(
                                      timeago.format(comment.createdDate, locale: "en"),
                                      style: AppStyle.caption2(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  comment.content,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 10,
                                  style: AppStyle.bodyText(fontSize: 13.0),
                                ),
                                GestureDetector(
                                  onTap: () => onReplyToTapped(context),
                                  behavior: HitTestBehavior.translucent,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
                                    child: Text(
                                      "Reply",
                                      style: AppStyle.caption2(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            iconSize: 20.0,
                            color: AppStyle.secondaryIconColor,
                            icon: const Icon(Icons.thumb_up),
                          ),
                        ],
                      ),
                      buildChildComments(state),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  Future<void> onReplyToTapped(BuildContext context) async {
    final stream = await context.read<CommentsCubit>().replyToComment(comment);
    stream.listen((params) async {
      await context.read<BlockCubit>().onCommentPosting(params);
    });
  }

  Widget buildChildComments(BlockState state) {
    if(state is BlockLoaded && state.totalComments > 0 ) {
      return Container(
        margin: const EdgeInsets.only(top: 20.0),
        child: _commentList(state),
      );
    }
    return const SizedBox();
  }

  Widget _viewMoreBtn(BuildContext context, int remaining) {
    return GestureDetector(
      onTap: context.read<BlockCubit>().viewMoreReplies,
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            const SizedBox(
              width: 28.0,
              child: Divider(
                height: 1.0,
                thickness: 1.0,
                color: AppStyle.neutralColor400,
                endIndent: 4.0,
              ),
            ),
            Expanded(
              child: Text(
                "View more $remaining ${remaining == 1 ? "reply" : "replies"}",
                style: AppStyle.caption2(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hideBtn(BuildContext context, int total) {
    return GestureDetector(
      onTap: context.read<BlockCubit>().hideAllReplies,
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            const SizedBox(
              width: 28.0,
              child: Divider(
                height: 1.0,
                thickness: 1.0,
                color: AppStyle.secondaryTextColor,
                endIndent: 4.0,
              ),
            ),
            Expanded(
              child: Text(
                "Hide ${total == 1 ? "reply" : "replies"}",
                style: AppStyle.caption2(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView _commentList(BlockLoaded state) {
    final comments = state.comments;
    final totalComments = state.totalComments;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: comments.length + 1,
      itemBuilder: (context, index) {
        if(index == comments.length) {
          final remaining = totalComments - comments.length;
          if(remaining > 0) {
            return state.isLoadingMore
                ? Container(
                    padding: const EdgeInsets.only(left: 40.0),
                    alignment: AlignmentDirectional.centerStart,
                    child: const CupertinoActivityIndicator(),
                  ) 
                : _viewMoreBtn(context, remaining);
          }
          return _hideBtn(context, totalComments);
        }
        final comment = comments[index];
        if(index >= comments.length - state.posting) {
          if(index == comments.length - 1) {
            return PostingCommentItem(comment, key: state.key!);
          }
          return PostingCommentItem(comment);
        }
        return _buildReplyItem(context, comment);
      },
    );
  }

  Widget _buildReplyItem(BuildContext context, Comment comment) {
    const avatarSize = 40;
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
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
              comment.author.avatarUrl, 
              maxWidth: avatarSize, 
              maxHeight: avatarSize,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "${comment.author.username} ",
                      style: AppStyle.caption2Bold(color: AppStyle.primaryTextColor),
                    ),
                    Text(
                      timeago.format(comment.createdDate, locale: "en"),
                      style: AppStyle.caption2(),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 10,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "@${comment.author.username} ", 
                        style: AppStyle.bodyText(
                          fontSize: 13.0, 
                          color: AppStyle.primaryColor,
                        ), 
                      ),
                      TextSpan(
                        text: comment.content,
                        style: AppStyle.bodyText(fontSize: 13.0),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => onReplyToTapped(context),
                  behavior: HitTestBehavior.translucent,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
                    child: Text("Reply", style: AppStyle.caption2()),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            iconSize: 20.0,
            color: AppStyle.secondaryIconColor,
            icon: const Icon(Icons.thumb_up),
          ),
        ],
      ),
    );
  }
}