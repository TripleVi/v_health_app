import 'package:flutter/material.dart';

enum PostPrivacy {
  public, 
  friend, 
  private,
}

extension PostPrivacyExtension on PostPrivacy {
  bool get isPublic => this == PostPrivacy.public;
  bool get isFriend => this == PostPrivacy.friend;
  bool get isPrivate => this == PostPrivacy.private;

  String get stringValue {
    switch (this) {
      case PostPrivacy.public:
        return "Everyone";
      case PostPrivacy.friend:
        return "Friends";
      case PostPrivacy.private:
        return "Only me";
      default:
        return "";
    }
  }

  int get numericValue {
    switch (this) {
      case PostPrivacy.public:
        return 0;
      case PostPrivacy.friend:
        return 1;
      case PostPrivacy.private:
      default:
        return 2;
    }
  }

  String get description {
    switch (this) {
      case PostPrivacy.public:
        return "Anyone on Fitpal can view this activity";
      case PostPrivacy.friend:
        return "Your friends on Fitpal";
      case PostPrivacy.private:
        return "Only you can view it. However, it is still counted toward your challenges and progress.";
      default:
        return "";
    }
  }

  IconData get iconData {
    switch (this) {
      case PostPrivacy.public:
        return Icons.public_rounded;
      case PostPrivacy.friend:
        return Icons.people_alt_rounded;
      case PostPrivacy.private:
        return Icons.person_rounded;
      default:
        return Icons.error;
    }
  }
}

enum ReactionType {
  like,
}