class BaseModel<T extends IToJson> extends IToJson {
  T? data;
  ErrorModel? error;

  BaseModel({this.data, this.error});

  factory BaseModel.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) builder) => BaseModel(
    data: json["data"] is Map<String, dynamic> ? builder(json["data"]) : null,
    error: json["error"] is Map<String, dynamic> ? ErrorModel.fromJson(json["error"]) : null,
  );

  @override
  Map<String, dynamic> toJson({bool includeNullValue = false}) => {
    "data": data?.toJson(includeNullValue: includeNullValue),
    "error": error?.toJson(includeNullValue: includeNullValue),
  };
}

class ErrorModel extends IToJson {
  int? statusCode;
  String? error;
  String? message;
  String? stacktrace;

  ErrorModel({this.statusCode, this.error, this.message, this.stacktrace});

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
    statusCode: json["statusCode"] as int?,
    error: json["error"] as String?,
    message: json["message"] as String?,
    stacktrace: json["stacktrace"] as String?,
  );

  @override
  Map<String, dynamic> toJson({bool includeNullValue = false}) => {
    "statusCode": statusCode,
    "error": error,
    "message": message,
    "stacktrace": stacktrace,
  }..removeWhere((key, value) => includeNullValue ? false : value == null);
}

class PagingModel<T extends IToJson> extends IToJson {
  List<T>? data;
  int? pageIndex;
  int? pageSize;
  int? elements;
  int? totalPages;
  int? totalElements;

  PagingModel({this.data, this.pageIndex, this.pageSize, this.elements, this.totalPages, this.totalElements});

  factory PagingModel.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) builder) => PagingModel(
    data: (json["data"] as List?)?.map((e) => builder(e as Map<String, dynamic>)).toList(),
    pageIndex: json["pageIndex"] as int?,
    pageSize: json["pageSize"] as int?,
    elements: json["elements"] as int?,
    totalPages: json["totalPages"] as int?,
    totalElements: json["totalElements"] as int?,
  );

  @override
  Map<String, dynamic> toJson({bool includeNullValue = false}) => {
    "data": data?.map((e) => e.toJson(includeNullValue: includeNullValue)),
    "pageIndex": pageIndex,
    "pageSize": pageSize,
    "elements": elements,
    "totalPages": totalPages,
    "totalElements": totalElements,
  };
}

abstract class IToJson {
  Map<String, dynamic> toJson({bool includeNullValue = false});
}
