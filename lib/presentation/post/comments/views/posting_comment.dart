import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/resources/style.dart';
import '../../../../domain/entities/comment.dart';

class PostingCommentItem extends StatelessWidget {
  final Comment comment;
  
  const PostingCommentItem(this.comment, {super.key});

  @override
  Widget build(BuildContext context) {
    const avatarSize = 40;
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
                Text(
                  "${comment.author.username} ",
                  style: AppStyle.caption2Bold(
                    color: AppStyle.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  comment.content,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 10,
                  style: AppStyle.bodyText(fontSize: 13.0),
                ),
                const SizedBox(height: 8.0),
                Text(
                  "Posting",
                  style: AppStyle.caption2(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}