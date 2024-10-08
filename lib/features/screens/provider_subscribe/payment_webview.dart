import 'dart:collection';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/utils/echo.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/screens/provider_layout/layout_cubit.dart';
import 'package:weltweit/features/widgets/app_snackbar.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

class PaymentWebview extends StatefulWidget {
  final int? packageId;
  final String url;

  const PaymentWebview({this.packageId, required this.url, super.key});

  @override
  State<PaymentWebview> createState() => _PaymentWebviewState();
}

class _PaymentWebviewState extends State<PaymentWebview> {
  double progress = 0.0;
  String url ='';
  bool loading = false;
  late PullToRefreshController pullToRefreshController;
  InAppWebViewController? webViewController;
  AppPrefs prefs = getIt<AppPrefs>();
  @override
  void initState() {

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
    super.initState();
  }

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(useHybridComposition: true),
      ios: IOSInAppWebViewOptions(allowsInlineMediaPlayback: true));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(LocaleKeys.payment.tr(), size: 22),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        elevation: 1,
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // CustomText(widget.url).footer().onTap(() {
                //   //copy
                //   Clipboard.setData(ClipboardData(text: widget.url));
                // }),
                Expanded(
                  child: Stack(
                    children: [
                      InAppWebView(
                        initialUrlRequest: URLRequest(
                          // url: Uri.parse('https://newdon.dev01.matrix-clouds.com/apple-payment/07f4654a30f138ff66484bfb7cbb32-h5bnwLx42Re8N7uAYycV-868-7/7'),
                          url: Uri.parse(widget.url.replaceFirst('http://', 'https://')),
                          // headers: {
                          //   'Authorization': 'Bearer ${prefs.get(PrefKeys.token)}',
                          // },
                        ),
                        initialUserScripts: UnmodifiableListView<UserScript>([]),
                        initialOptions: options,
                        pullToRefreshController: pullToRefreshController,
                        onWebViewCreated: (onWebViewController) {
                          webViewController = onWebViewController;
                        },
                        onLoadStart: (ctl, uri) async {
                          //get url params
                          String url = uri.toString();
                          kEcho(url);

                          if (url.contains('success=true')) {
                            context.read<LayoutProviderCubit>().setCurrentIndex(0);
                            while (NavigationService.canGoBack()) {
                              NavigationService.goBack();
                            }
                            String message = LocaleKeys.successfullySubscribed.tr();
                            AppSnackbar.show(context: context, message: message);
                          }
                          if (url.contains('success=false')) {
                            context.read<LayoutProviderCubit>().setCurrentIndex(0);
                            while (NavigationService.canGoBack()) {
                              NavigationService.goBack();
                            }
                            String message = LocaleKeys.somethingWentWrong.tr();
                            AppSnackbar.show(context: context, message: message);
                          }

                          // //get url from uri
                          // if (uri.toString().contains('success')) {
                          //   loading = false;
                          //   setState(() {});
                          // } else if (uri.toString().contains('cancel')) {
                          //   loading = false;
                          //   setState(() {});
                          //   AppSnackbar.show(context: context, message: "Cancel");
                          // }
                        },
                        androidOnPermissionRequest: (controller, origin, resources) async {
                          return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
                        },
                        shouldOverrideUrlLoading: (controller, navigationAction) async {
                          return NavigationActionPolicy.ALLOW;
                        },
                        onLoadStop: (ctrl, url) async {
                          pullToRefreshController.endRefreshing();
                        },
                        onLoadError: (ctrl, url, code, message) {
                          pullToRefreshController.endRefreshing();
                        },
                        onProgressChanged: (ctrl, prgs) {
                          if (progress == 100) {
                            pullToRefreshController.endRefreshing();
                          }
                          progress = (prgs / 100).toDouble();
                          setState(() {});
                        },
                        onUpdateVisitedHistory: (controller, url, androidIsReload) {},
                        onConsoleMessage: (controller, consoleMessage) {
                          print(consoleMessage);
                        },
                      ),
                      progress < 1.0 ? LinearProgressIndicator(value: progress) : Container(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
