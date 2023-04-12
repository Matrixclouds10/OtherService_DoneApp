part of 'otp_cubit.dart';

class OtpState {
  ///Variables
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  OtpState();

  OtpState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return OtpState().._isLoading = isLoading ?? _isLoading;
  }
}
