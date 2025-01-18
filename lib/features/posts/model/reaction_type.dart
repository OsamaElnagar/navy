import 'package:flutter/material.dart';

enum ReactionType {
  like,
  love,
  haha,
  wow,
  sad,
  angry;

  String get emoji {
    switch (this) {
      case ReactionType.like:
        return '👍';
      case ReactionType.love:
        return '❤️';
      case ReactionType.haha:
        return '😂';
      case ReactionType.wow:
        return '😮';
      case ReactionType.sad:
        return '😢';
      case ReactionType.angry:
        return '😠';
    }
  }

  String get label {
    switch (this) {
      case ReactionType.like:
        return 'Like';
      case ReactionType.love:
        return 'Love';
      case ReactionType.haha:
        return 'Haha';
      case ReactionType.wow:
        return 'Wow';
      case ReactionType.sad:
        return 'Sad';
      case ReactionType.angry:
        return 'Angry';
    }
  }

  IconData get icon {
    switch (this) {
      case ReactionType.like:
        return Icons.thumb_up;
      case ReactionType.love:
        return Icons.favorite;
      case ReactionType.haha:
        return Icons.sentiment_very_satisfied;
      case ReactionType.wow:
        return Icons.sentiment_satisfied;
      case ReactionType.sad:
        return Icons.sentiment_dissatisfied;
      case ReactionType.angry:
        return Icons.sentiment_very_dissatisfied;
    }
  }

  Color get color {
    switch (this) {
      case ReactionType.like:
        return Colors.blue;
      case ReactionType.love:
        return Colors.red;
      case ReactionType.haha:
        return Colors.amber;
      case ReactionType.wow:
        return Colors.amber;
      case ReactionType.sad:
        return Colors.deepPurple;
      case ReactionType.angry:
        return Colors.orange;
    }
  }

  String get name => toString().split('.').last;
}
