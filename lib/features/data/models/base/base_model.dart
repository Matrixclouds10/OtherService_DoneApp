class BaseModel<E> {
  bool status;
  String code;
  dynamic message;
  E? responseData;
  E? response;

  BaseModel(
      {required this.status,
      required this.code,
      required this.message,
      this.responseData,
      this.response});

  factory BaseModel.fromJson(Map<String, dynamic> json) => BaseModel(
        status: ((json['code'] ?? '200').toString() == '200') ||
            ((json['code'] ?? '201').toString() == '201'),
        code: (json['code'] ?? '200').toString(),
        message: json['message'] ?? "Error",
        responseData: json['data'],
        // response: json['item']?['data']
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = status;
    data['message'] = message;
    data['code'] = code;
    data['data'] = responseData ?? {};
    return data;
  }
}
