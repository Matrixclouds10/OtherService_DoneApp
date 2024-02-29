import 'package:weltweit/features/data/models/base/base_model.dart';
import 'package:weltweit/features/data/models/base/response_model.dart';

mixin BaseUseCase<R> {
  ResponseModel<R> onConvert(BaseModel baseModel);
}
