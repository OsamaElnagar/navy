enum FriendshipState {
  notFriend,
  pendingSent,
  pendingReceived,
  accepted;

  String get buttonText {
    switch (this) {
      case FriendshipState.notFriend:
        return 'Send Friend Request';
      case FriendshipState.pendingSent:
        return 'Cancel Request';
      case FriendshipState.pendingReceived:
        return 'Accept Request';
      case FriendshipState.accepted:
        return 'Unfriend';
    }
  }
}
