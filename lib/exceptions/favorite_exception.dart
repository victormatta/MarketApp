class FavoriteException implements Exception {
  final String msg;
  final int statusCode;

  FavoriteException({required this.msg, required this.statusCode});

  @override
  String toString() {
    // TODO: implement toString
    return msg;
  }
}
