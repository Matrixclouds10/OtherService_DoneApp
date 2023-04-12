extension NonNullString on String? {
  String get orEmpty => this ?? "";
}

extension NonNullInt on int? {
  int get orZero => this ?? 0;
}

extension NonNullDouble on double? {
  double get orZero => this ?? 0.0;
}

extension NonNullbool on bool? {
  bool get orFalse => this ?? false;
}

extension NonNullList on List? {
  List get orEmpty => this ?? [];
}
