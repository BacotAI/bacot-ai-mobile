class TranscribeResponseModel {
  final String text;

  TranscribeResponseModel({required this.text});

  factory TranscribeResponseModel.fromJson(Map<String, dynamic> json) {
    return TranscribeResponseModel(text: json['text'] as String);
  }
}
