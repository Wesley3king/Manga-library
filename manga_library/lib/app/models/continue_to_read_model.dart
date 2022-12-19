class ContinueToReadModel {
  ContinueToReadModel({
    required this.id,
    required this.chapter,
  });
  late final String id;
  late final String chapter;
  
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