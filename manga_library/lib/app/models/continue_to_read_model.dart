class ContinueToReadModel {
  ContinueToReadModel({
    required this.id,
    required this.chapter,
    required this.isStart
  });
  late String id;
  late String chapter;
  late bool isStart;

  // ContinueToReadModel.fromJson(Map<String, dynamic> json){
  //   id = json['id'];
  //   chapter = json['chapter'];
  // }

  // Map<String, dynamic> toJson() {
  //   final data = <String, dynamic>{};
  //   data['id'] = id;
  //   data['chapter'] = chapter;
  //   return data;
  // }
}
