class BaseResponse<T> {
  int? code;
  String? message;
  T? data;
  T? data2;
  Meta? meta;

  BaseResponse({
    this.code,
    this.message,
    this.data,
    this.data2,
    this.meta,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      code: json['code'],
      message: json['message'],
      data: json['data'],
      data2: json['data2'],
      meta: (json['data'] != null && json['data'] is Map && json['data']['meta'] != null) ? Meta.fromJson(json['data']['meta']) : null,
    );
  }

  copyWith({
    int? code,
    String? message,
    T? data,
    T? data2,
    Meta? meta,
  }) {
    return BaseResponse(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
      data2: data2 ?? this.data2,
      meta: meta ?? this.meta,
    );
  }
}

class Meta {
  Meta({
    required this.pagination,
  });

  Pagination pagination;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        pagination: Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination.toJson(),
      };
}

class Pagination {
  Pagination({
    required this.total,
    required this.count,
    required this.perPage,
    required this.currentPage,
    required this.totalPages,
  });

  int total;
  int count;
  int perPage;
  int currentPage;
  int totalPages;

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json["total"],
        count: json["count"],
        perPage: json["per_page"],
        currentPage: json["current_page"],
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "count": count,
        "per_page": perPage,
        "current_page": currentPage,
        "total_pages": totalPages,
      };
}
