import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../../core/resources/colors.dart';
import '../../../../../../core/resources/style.dart';
import '../../../../../../domain/entities/comment.dart';
import '../../cubit/comments_cubit.dart';
import '../cubit/block_cubit.dart';

class CommentBlock extends StatelessWidget {
  final String _postId;
  final Comment _parent;
  final bool newComment;

  CommentBlock(this._postId, this._parent, {super.key, this.newComment = false}) {
    print("CommentBlock: $newComment");
  }

  Widget _viewMoreBtn(BuildContext context, int remaining) {
    return GestureDetector(
      onTap: () {
        context.read<BlockCubit>().viewMoreComments();
      },
      child: Row(
        children: [
          SizedBox(
            width: 28.0,
            child: Divider(
              height: 1.0,
              thickness: 1.0,
              color: AppColor.onBackgroundColor,
              endIndent: 4.0,
            ),
          ),
          Expanded(
            child: Text(
              "View more $remaining ${remaining == 1 ? "comment" : "comments"}"
            ),
          ),
        ],
      ),
    );
  }

  Widget _hideBtn(BuildContext context, int total) {
    return GestureDetector(
      onTap: () {
        context.read<BlockCubit>().hideAllComments();
      },
      child: Row(
        children: [
          SizedBox(
            width: 28.0,
            child: Divider(
              height: 1.0,
              thickness: 1.0,
              color: AppColor.onBackgroundColor,
              endIndent: 4.0,
            ),
          ),
          Expanded(
            child: Text(
              "Hide ${total == 1 ? "comment" : "comments"}"
            ),
          ),
        ],
      ),
    );
  }

  ListView _commentList(BlockLoaded state) {
    const avatarSize = 40;
    final user = state.user;
    final comments = state.comments;
    final totalComments = state.totalComments;
    final isLoadingMore = state.isLoadingMore;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: comments.length + 1,
      itemBuilder: (context, index) {
        if(index == comments.length) {
          final remaining = totalComments - comments.length;
          if(remaining > 0) {
            return isLoadingMore
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
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
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
              foregroundImage: user.avatarUrl == null
                  ? null
                  : Image.network(
                      user.avatarUrl,
                      cacheWidth: avatarSize,
                      cacheHeight: avatarSize,
                      filterQuality: FilterQuality.high,
                      isAntiAlias: true,
                      fit: BoxFit.contain,
                    ).image,
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
                        style: AppStyle.paragraph(
                          color: AppColor.textColor,
                          height: 1.0,
                        ),
                      ),
                      Text(
                        timeago.format(comment.createdDate, locale: "en"),
                        style: AppStyle.paragraph(
                          color: AppColor.textColor,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        // TextSpan(
                        //   text: comment.authorUsername == null
                        //       ? null
                        //       : "@${comment.authorUsername} ", 
                        //   style: AppStyle.paragraph(color: AppColor.primaryColor), 
                        // ),
                        TextSpan(
                          text: comment.content,
                          style: AppStyle.paragraph(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0,),
                  Row(
                    children: [
                      Text(
                        "22 likes",
                        style: AppStyle.label(),
                      ),
                      const SizedBox(width: 12.0),
                      GestureDetector(
                        onTap: () => context
                          .read<CommentsCubit>()
                          .replyComment(comment) //? ancestor (lv1)
                          .then((value) {
                            if(value) {
                              context.read<BlockCubit>().onCommentAdded();
                            }
                          }),
                        child: Text(
                          "Reply",
                          style: AppStyle.label(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  // CommentBlock(_postId, comment),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                
              },
              iconSize: 20.0,
              color: AppColor.primaryColor,
              icon: const Icon(Icons.thumb_up),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BlockCubit>(
      create: (context) => BlockCubit(_postId, _parent, newComment),
      child: BlocBuilder<BlockCubit, BlockState>(
        builder: (context, state) {
          if(state is BlockLoading) {
            return Container(
              margin: const EdgeInsets.only(top: 20.0),
              padding: const EdgeInsets.only(left: 40.0),
              child: const CupertinoActivityIndicator()
            );
          }
          if(state is BlockLoaded) {
            return state.totalComments == 0 
                ? const SizedBox() 
                : Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    child: _commentList(state),
                  );
          }
          return const SizedBox();
        },
      ),
    );
  }
}