class ReaderChapter {
  ReaderChapter(
      {required this.index,
      required this.id,
      this.prevId,
      this.nextId});
  late final int index;
  late final String id;
  String? prevId;
  String? nextId;

  ReaderChapter.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    id = json['id'];
    prevId = json['prevId'];
    nextId = json['nextId'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['index'] = index;
    data['id'] = id;
    data['prevId'] = prevId;
    data['nextId'] = nextId;
    return data;
  }
}
