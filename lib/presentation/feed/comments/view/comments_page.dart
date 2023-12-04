import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/resources/colors.dart';
import '../../../../core/resources/style.dart';
import '../../../../domain/entities/comment.dart';
import '../../../widgets/appBar.dart';
import '../../../widgets/loading_indicator.dart';
import '../block/view/block_page.dart';
import '../cubit/comments_cubit.dart';

class CommentsPage extends StatelessWidget {
  final String _postId;
  const CommentsPage(this._postId, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommentsCubit>(
      create: (context) => CommentsCubit(_postId),
      child: CommentsView(),
    );
  }
}

class CommentsView extends StatelessWidget {
  final _txtContent = StylableTextFieldController(
    replyForStyle: AppStyle.paragraph(color: AppColor.primaryColor),
  );
  final _visibilityChange = ValueNotifier(false);

  CommentsView({super.key});

  Widget _sendBtn(BuildContext context) {
    return IconButton(
      onPressed: () {
        context
          .read<CommentsCubit>()
          .writeComment(_txtContent.text);
        _txtContent.text = "";
      },
      icon: const Icon(
        Icons.send_rounded,
        size: 32.0,
        color: AppColor.primaryColor,
      ),
    );
  }

  Widget _commentSection(BuildContext context, CommentsLoaded state) {
    const avatarSize = 40;
    final user = state.user, authorUsername = state.authorUsername;
    _txtContent.authorUsername = state.authorUsername;
    _txtContent.text = state.authorUsername == null
        ? "" 
        : "@${state.authorUsername!} ";
    
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppStyle.horizontalPadding,
          vertical: 12.0
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.secondaryColor,
          boxShadow: [
            BoxShadow(
              color: AppColor.onBackgroundColor,
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
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
                children: [
                  authorUsername == null
                      ? const SizedBox()
                      : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Replying to ", style: AppStyle.label()),
                            Text(
                              authorUsername, 
                              style: AppStyle.paragraph(height: 1, fontSize: 14)
                            ),
                            Text(" . ", style: AppStyle.label()),
                            // Icon(Icons.do)
                            GestureDetector(
                              onTap: context.read<CommentsCubit>().cancelReplyFor,
                              child: Text("Cancel", style: AppStyle.label()),
                            ),
                          ],
                        ),
                  Row(
                    children: [
                      Expanded(
                        child: _textField(
                          controller: _txtContent,
                          hintText: "Write a public comment...",
                          minLines: 1,
                          maxLines: 4,
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      ValueListenableBuilder(
                        builder: (context, value, child) {
                          return value
                              ? _sendBtn(context)
                              : const SizedBox();
                        },
                        valueListenable: _visibilityChange,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    String hintText = "",
    int minLines = 1,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      onChanged: (value) {
        _visibilityChange.value = value.isNotEmpty;

      },
      textAlignVertical: TextAlignVertical.center,
      style: AppStyle.paragraph(color: AppColor.textColor),
      controller: controller,
      cursorColor: AppColor.textColor,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppStyle.paragraph(),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              const BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
          borderSide: BorderSide(color: AppColor.controlNormalColor),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
          borderSide: BorderSide(color: AppColor.textColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppStyle.horizontalPadding,
          vertical: 12.0,
        ),
      ),
      minLines: minLines,
      maxLines: maxLines,
    );
  }

  Widget _commentList(BuildContext context, CommentsLoaded state) {
    final comments = state.commentsLv1;
    final isLoadingMore = state.isLoadingMore;
    final totalComments = state.totalComments;

    return ListView.builder(
      controller: state.scrollController,
      padding: const EdgeInsets.fromLTRB(
        AppStyle.horizontalPadding, 20.0,
        AppStyle.horizontalPadding, 0.0,
      ),
      itemCount: totalComments > comments.length ? comments.length+1 : comments.length,
      itemBuilder: (context, index) {
        if(index == comments.length) {
          return isLoadingMore 
              ? const CupertinoActivityIndicator()
              : Text(
                "Scroll down to view more comments...",
                style: AppStyle.heading_2(fontSize: 14.0, height: 1.0),
              );
        }
        final comment = comments[index];
        return CommentItem(comment, state.postId);
      },
    );
  }

  Widget _mainSection(BuildContext context, CommentsLoaded state) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 75.0),
          child: _commentList(context, state)
        ),
        _commentSection(context, state),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: CustomAppBar.get(
        title: "Comments",
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 24.0,
            color: AppColor.onBackgroundColor,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppColor.onBackgroundColor)),
        ),
        child: BlocBuilder<CommentsCubit, CommentsState>(
          builder: (context, state) {
            if(state is CommentsLoading) {
              return const AppLoadingIndicator();
            }
            if(state is CommentsLoaded) {
              return _mainSection(context, state);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class CommentItem extends StatefulWidget {
  final String postId;
  final Comment comment;
  const CommentItem(this.comment, this.postId, {super.key});

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool newComment = false;

  @override
  Widget build(BuildContext context) {
    const avatarSize = 40;
    final comment = widget.comment;

    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Row(
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
              fit: BoxFit.contain,
              isAntiAlias: true,
            ).image,
            foregroundImage: Image.network(
                    comment.author.avatarUrl,
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
                          Text(
                            comment.content,
                            style: AppStyle.paragraph(),
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
                                  .replyComment(comment)
                                  .then((value) {
                                    if(value) {
                                      // setState(() {
                                      //   newComment = true;
                                      //   print("value added: $newComment");
                                      // });
                                    }
                                  }),
                                child: Text(
                                  "Reply",
                                  style: AppStyle.label(),
                                ),
                              ),
                            ],
                          ),
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
                ),
                CommentBlock(widget.postId, comment, newComment: newComment),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StylableTextFieldController extends TextEditingController {
  String? authorUsername;
  final TextStyle _replyForStyle;

  StylableTextFieldController({
    super.text, 
    required TextStyle replyForStyle,
  }) : _replyForStyle = replyForStyle;

  TextStyle get replyForStyle => _replyForStyle;

  @override
  TextSpan buildTextSpan({
    required BuildContext context, 
    TextStyle? style, 
    required bool withComposing,
  }) {
    if(authorUsername == null) {
      return super.buildTextSpan(
        context: context,
        style: style,
        withComposing: withComposing,
      );
    }
    final textSpanChildren = <InlineSpan>[];
    final pattern = r'^@' + authorUsername!;
    final regExp = RegExp(pattern, caseSensitive: false);
    text.splitMapJoin(
      regExp,
      onMatch: (match) {
        textSpanChildren.add(TextSpan(
          text: match[0],
          style: _replyForStyle,
        ));
        return "";
      },
      onNonMatch: (text) {
        textSpanChildren.add(TextSpan(
          text: text,
          style: style,
        ));
        return "";
      },
    );
    return TextSpan(
      style: style,
      children: textSpanChildren,
    );
  }
}