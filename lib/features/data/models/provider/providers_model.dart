import 'package:weltweit/features/data/models/services/service.dart';

class ProvidersModel {
  int? id;
  String? name;
  String? description;
  String? email;
  String? mobileNumber;
  String? countryCode;
  int? otpVerified;
  int? approved;
  String? lat;
  String? lng;
  String? image;
  dynamic distance;
  List<ServiceModel>? services;
  String? rateAvg;
  int? rateCount;
  bool isFavorite;
  bool isOnline;

  ProvidersModel({
    this.id,
    this.name,
    this.email,
    this.description,
    this.mobileNumber,
    this.countryCode,
    this.otpVerified,
    this.approved,
    this.lat,
    this.lng,
    this.image,
    this.distance,
    this.services,
    this.rateAvg,
    this.rateCount,
    this.isFavorite = false,
    this.isOnline = false,
  });

  factory ProvidersModel.fromJson(Map<String, dynamic> json) {
    return ProvidersModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      description: json['description'] as String?,
      mobileNumber: json['mobile_number'] as String?,
      countryCode: json['country_code'] as String?,
      otpVerified: json['otp_verified'] as int?,
      approved: json['approved'] as int?,
      lat: json['lat'] as dynamic,
      lng: json['lng'] as dynamic,
      image: json['image'] as String?,
      distance: json['distance'] as dynamic,
      services: json['services'] == null ? [] : json['services'].map<ServiceModel>((e) => ServiceModel.fromJson(e)).toList(),
      rateAvg: json['rate_avg'] as String?,
      rateCount: json['rate_count'] as int?,
      isFavorite: "${json['is_fav']}".toLowerCase() == "true",
      isOnline: "${json['is_online']}".toLowerCase() == "yes",
    );
  }
}

class ServicesModel {
  List<ServicesModelData>? data;
  Meta? meta;

  ServicesModel({this.data, this.meta});

  ServicesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ServicesModelData>[];
      json['data'].forEach((v) {
        data!.add(ServicesModelData.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class ServicesModelData {
  int? id;
  String? title;
  String? breif;
  String? image;
  bool? myService;
  int? countryId;
  String? subPercentage;

  ServicesModelData(
      {this.id,
        this.title,
        this.breif,
        this.image,
        this.myService,
        this.countryId,
        this.subPercentage});

  ServicesModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    breif = json['breif'];
    image = json['image'];
    myService = json['my_service'];
    countryId = json['country_id'];
    subPercentage = json['sub_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['breif'] = this.breif;
    data['image'] = this.image;
    data['my_service'] = this.myService;
    data['country_id'] = this.countryId;
    data['sub_percentage'] = this.subPercentage;
    return data;
  }
}

class Meta {
  Pagination? pagination;

  Meta({this.pagination});

  Meta.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Pagination {
  int? total;
  int? count;
  int? perPage;
  int? currentPage;
  int? totalPages;
  Links? links;

  Pagination(
      {this.total,
        this.count,
        this.perPage,
        this.currentPage,
        this.totalPages,
        this.links});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    count = json['count'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    totalPages = json['total_pages'];
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['count'] = this.count;
    data['per_page'] = this.perPage;
    data['current_page'] = this.currentPage;
    data['total_pages'] = this.totalPages;
    if (this.links != null) {
      data['links'] = this.links!.toJson();
    }
    return data;
  }
}

class Links {
  String? next;

  Links({this.next});

  Links.fromJson(Map<String, dynamic> json) {
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['next'] = this.next;
    return data;
  }
}

