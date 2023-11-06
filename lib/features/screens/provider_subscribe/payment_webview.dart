import 'dart:collection';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
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
                Expanded(
                  child: Stack(
                    children: [
                      InAppWebView(
                        initialUrlRequest: URLRequest(
                          url: Uri.parse(widget.url),
                          // headers: {
                          //   'Authorization': 'Bearer ${prefs.get(PrefKeys.token)}',
                          // },
                        ),
                        initialUserScripts:
                            UnmodifiableListView<UserScript>([]),
                        initialOptions: options,
                        pullToRefreshController: pullToRefreshController,
                        onWebViewCreated: (onWebViewController) {
                          webViewController = onWebViewController;
                        },
                        // onLoadResource: (uri,loadRes){
                        //   String? url=(loadRes.url).toString();
                        //   if (url.contains('alrajhi-verify-response')) {
                        //     if (url.contains('status=1')) {
                        //       Fluttertoast.showToast(
                        //           msg: 'تم الدفع بنجاح',
                        //           backgroundColor: Colors.green);
                        //     } else if (url.contains('status=2')) {
                        //       Fluttertoast.showToast(
                        //           msg: 'لم يتم الدفع حاول مرة أخري',
                        //           backgroundColor: Colors.red);
                        //     }
                        //   }
                        //
                        // },
                        onLoadStart: (ctl, uri) async {
                          //get url params
                          String url = uri.toString();
                          if (url.contains('alrajhi-verify-response')) {
                            if (url.contains('status=1')) {
                              Fluttertoast.showToast(
                                  msg: 'تم الدفع بنجاح',
                                  backgroundColor: Colors.green);
                            } else if (url.contains('status=2')) {
                              Navigator.pop(context);
                              Fluttertoast.showToast(
                                  msg: 'لم يتم الدفع حاول مرة أخري',
                                  backgroundColor: Colors.red);
                            }
                          } else if (url.contains('paymobsolutions')) {}
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
