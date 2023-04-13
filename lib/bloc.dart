import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/features/bloc.dart';

class GenerateMultiBloc extends StatelessWidget {
  final Widget child;

  const GenerateMultiBloc({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///TODO add bloc
    return MultiBlocProvider(
      providers: [...kServicesProviders],
      child: child,
    );
  }
}
