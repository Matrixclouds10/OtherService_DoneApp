import 'package:equatable/equatable.dart';
import 'package:weltweit/features/data/models/response/auth/user_model.dart';

class GlobalParams extends Equatable {
  final UserModel? user;
   GlobalParams({this.user}){
    print('GlobalParams constructor');
  }

  copyWith({
    UserModel? user,
  }) {
    return GlobalParams(
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [user];
}
