enum BroadCastType {
  socket,
  slack;

  static BroadCastType? fromString(String type) {
    switch (type.toUpperCase()) {
      case 'SOCKET':
        return BroadCastType.socket;

      case 'SLACK':
        return BroadCastType.slack;

      default:
        return null;
    }
  }
}
