import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/style.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/loading_indicator.dart';
import '../block/view/block_page.dart';
import '../cubit/comments_cubit.dart';
import 'posting_comment.dart';

class CommentsPage extends StatelessWidget {
  const CommentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final postId = ModalRoute.of(context)!.settings.arguments as String;
    return BlocProvider<CommentsCubit>(
      create: (context) => CommentsCubit(postId),
      child: CommentsView(),
    );
  }
}

class CommentsView extends StatelessWidget {
  final _txtContent = StylableTextFieldController(
    replyForStyle: AppStyle.bodyText(color: AppStyle.primaryColor),
  );
  final _visibilityChange = ValueNotifier(false);

  CommentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.surfaceColor,
      appBar: CustomAppBar.get(
        title: "Comments",
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 24.0,
            color: AppStyle.neutralColor400,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppStyle.neutralColor400)),
        ),
        child: BlocConsumer<CommentsCubit, CommentsState>(
          listener: (context, state) {
            if(state is CommentsLoaded && state.snackMsg != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  state.snackMsg!,
                  style: AppStyle.bodyText(color: Colors.white),
                ),
              ));
            }
          },
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
        color: AppStyle.primaryColor,
      ),
    );
  }

  Widget _commentSection(BuildContext context, CommentsLoaded state) {
    const avatarSize = 40;
    final replyToUsername = state.replyTo?.author.username;
    _txtContent.replyToUsername = replyToUsername;
    _txtContent.text = replyToUsername == null
        ? "" 
        : "@$replyToUsername ";
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppStyle.horizontalPadding,
          vertical: 12.0,
        ),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppStyle.surfaceColor,
          boxShadow: [
            BoxShadow(
              color: AppStyle.neutralColor400,
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
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
                state.user.avatarUrl, 
                maxWidth: avatarSize, 
                maxHeight: avatarSize,
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  replyToUsername == null
                      ? const SizedBox()
                      : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Replying to ", style: AppStyle.caption2()),
                            Text(
                              replyToUsername, 
                              style: AppStyle.bodyText(height: 1, fontSize: 14.0)
                            ),
                            Text(" . ", style: AppStyle.caption2()),
                            GestureDetector(
                              onTap: context.read<CommentsCubit>().cancelReplyTo,
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text("Cancel", style: AppStyle.caption2()),
                              ),
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
      style: AppStyle.bodyText(),
      controller: controller,
      cursorColor: AppStyle.primaryTextColor,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppStyle.bodyText(),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              const BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
          // borderSide: BorderSide(color: AppStyle.controlNormalColor),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
          borderSide: BorderSide(color: AppStyle.primaryTextColor),
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

  // Widget _commentList(CommentsLoaded state) {
  //   final comments = state.comments;
  //   final totalItems = state.totalComments > comments.length 
  //       ? comments.length+1 
  //       : comments.length;
  //   return Scrollbar(
  //     controller: state.scrollController,
  //     child: ListView.builder(
  //       controller: state.scrollController,
  //       padding: const EdgeInsets.fromLTRB(
  //         AppStyle.horizontalPadding, 20.0,
  //         AppStyle.horizontalPadding, 0.0,
  //       ),
  //       itemCount: totalItems,
  //       itemBuilder: (context, index) {
  //         if(index == comments.length) {
  //           // if(state.scrollController.position.hasContentDimensions 
  //           // && state.scrollController.position.maxScrollExtent > 0.0) {
  //           //   return const SizedBox();
  //           // }
  //           if(state.isLoadingMore) {
  //             return const CupertinoActivityIndicator();
  //           }
  //           return const SizedBox();
  //         }
  //         final comment = comments[index];
  //         if(index < state.posting) {
  //           return PostingCommentItem(comment);
  //         }
  //         return CommentBlock(state.postId, comment);
  //       },
  //     ),
  //   );
  // }

  Widget _commentList(CommentsLoaded state) {
    final comments = state.comments;
    final totalItems = state.totalComments > comments.length 
        ? comments.length+1 
        : comments.length;
    final widgets = List.generate(totalItems, (index) {
      if(index == comments.length) {
        return state.isLoadingMore 
            ? const CupertinoActivityIndicator()
            : const SizedBox();
      }
      final comment = comments[index];
      if(index < state.posting) {
        return PostingCommentItem(comment);
      }
      return CommentBlock(state.postId, comment);
    });
    return Scrollbar(
      controller: state.scrollController,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppStyle.horizontalPadding, 20.0,
          AppStyle.horizontalPadding, 28.0,
        ),
        controller: state.scrollController,
        child: Column(
          children: widgets,
        ),
      ),
    );
  }

  Widget _mainSection(BuildContext context, CommentsLoaded state) {
    return Stack(
      children: [
        state.comments.isNotEmpty 
            ? Container(
              margin: const EdgeInsets.only(bottom: 75.0),
              child: _commentList(state),
            )
            : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("No comments yet", style: AppStyle.heading2()),
                  const SizedBox(height: 12.0),
                  Text(
                    "Say something to start the conversation.", 
                    style: AppStyle.bodyText(),
                  ),
                  const SizedBox(height: 120.0),
                ],
              ),
            ),
        _commentSection(context, state),
      ],
    );
  }
}

class StylableTextFieldController extends TextEditingController {
  String? replyToUsername;
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
    if(replyToUsername == null) {
      return super.buildTextSpan(
        context: context,
        style: style,
        withComposing: withComposing,
      );
    }
    final textSpanChildren = <InlineSpan>[];
    final pattern = r'^@' + replyToUsername!;
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