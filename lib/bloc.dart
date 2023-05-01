import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/injection.dart';
import 'package:weltweit/features/bloc.dart';
import 'package:weltweit/features/logic/about/about_cubit.dart';
import 'package:weltweit/features/logic/chat/chat_cubit.dart';
import 'package:weltweit/features/logic/contact_us/contact_us_cubit.dart';
import 'package:weltweit/features/logic/policy/policy_cubit.dart';
import 'package:weltweit/features/provider/bloc.dart';
class GenerateMultiBloc extends StatelessWidget {
  final Widget child;

  const GenerateMultiBloc({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///TODO add bloc
    return MultiBlocProvider(
      providers: [
        ...kServicesProviders,
        ...kProviderBloc,
        BlocProvider<ChatCubit>(create: (BuildContext context) => ChatCubit(getIt(), getIt())),
        BlocProvider<AboutCubit>(create: (BuildContext context) => AboutCubit(getIt())),
        BlocProvider<PolicyCubit>(create: (BuildContext context) => PolicyCubit(getIt())),
        BlocProvider<ContactUsCubit>(create: (BuildContext context) => ContactUsCubit(getIt())),
      ],
      child: child,
    );
  }
}
