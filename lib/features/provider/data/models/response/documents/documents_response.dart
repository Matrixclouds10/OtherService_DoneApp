import 'document.dart';

class DocumentsResponse {
  int? code;
  String? message;
  List<Document>? documents;

  DocumentsResponse({this.code, this.message, this.documents});

  factory DocumentsResponse.fromJson(Map<String, dynamic> json) {
    return DocumentsResponse(
      code: json['code'] as int?,
      message: json['message'] as String?,
      documents: (json['documents'] as List<dynamic>?)
          ?.map((e) => Document.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'documents': documents?.map((e) => e.toJson()).toList(),
      };
}
