import "../sources/sqlite/sqlite_service.dart";

class FeedData {
  int id;
  String pid;
  bool viewed;

  FeedData(this.id, this.pid, this.viewed);

  factory FeedData.empty() {
    return FeedData(-1, "", false);
  }

  factory FeedData.fromMap(Map<String, dynamic> map) {
    return FeedData(map["id"], map["pid"], map["viewed"] == 1);
  } 

  Map<String, dynamic> toMap() {
    return {
      "pid": pid,
      "viewed": viewed ? 1 : 0,
    };
  }

  @override
  String toString() {
    return "FeedData{id: $id, pid: $pid, viewed: $viewed}";
  }
}

class FeedRepo {
  Future<List<FeedData>> fetchFeedData([bool viewed = false]) async {
    final db = await SqlService.instance.database;
    final result = await db.query(
      "feed",
      where: "viewed = ?",
      whereArgs: [viewed ? 1 : 0],
      orderBy: "id DESC",
      limit: 10,
    );
    return result.map((e) => FeedData.fromMap(e)).toList();
  }

  Future<List<FeedData>> fetchViewedPosts() async {
    final db = await SqlService.instance.database;
    final result = await db.query(
      "feed",
      where: "viewed = ?",
      whereArgs: [1],
    );
    return result.map((e) => FeedData.fromMap(e)).toList();
  }

  Future<int> count() async {
    final db = await SqlService.instance.database;
    final result = await db.query("feed");
    return result.length;
  }

  Future<void> createFeedData(List<String> postIds) async {
    if(postIds.isEmpty) return;
    final db = await SqlService.instance.database;
    final batch = db.batch();
    for (var i = postIds.length-1; i >= 0; i--) {
      final data = FeedData.empty()
      ..pid = postIds[i];
      batch.insert("feed", data.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<int> updateFeedData(FeedData data) async {
    final db = await SqlService.instance.database;
    return db.update(
      "feed", 
      data.toMap(),
      where: "id = ?",
      whereArgs: [data.id],
    );
  }

  Future<void> deleteViewedPosts(List<String> ids) async {
    if(ids.isEmpty) return;
    final db = await SqlService.instance.database;
    final batch = db.batch();
    for (var i in ids) {
      batch.delete(
        "feed",
        where: "pid = ?",
        whereArgs: [i],
      );
    }
    await batch.commit(noResult: true);
  }
}