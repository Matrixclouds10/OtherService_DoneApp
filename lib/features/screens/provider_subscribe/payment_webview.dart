import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/services/local/storage_keys.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/widgets/app_snackbar.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

class PaymentWebview extends StatefulWidget {
  final int packageId;
  const PaymentWebview({required this.packageId, super.key});

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
        title: CustomText(LocaleKeys.payment, size: 22),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        elevation: 1,
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: Uri.parse(
                      'https://newdon.dev01.matrix-clouds.com/api/service-provider/paymob-iframe?subscription_id=${widget.packageId}&payment_type=wallet',
                    ),
                    headers: {
                    'Authorization': 'Bearer ${prefs.get(PrefKeys.token)}',
                  },
                  ),
                  initialUserScripts: UnmodifiableListView<UserScript>([]),
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (onWebViewController) {
                    webViewController = onWebViewController;
                  },
                  onLoadStart: (ctl, uri) async {
                    //get url from uri
                    if (uri.toString().contains('success')) {
                      loading = false;
                      setState(() {});
                      try {
                        AppSnackbar.show(context: context, message: "Success");

                        // }
                      } catch (status) {
                        AppSnackbar.show(context: context, message: "$status");
                      }
                    } else if (uri.toString().contains('cancel')) {
                      loading = false;
                      setState(() {});
                      AppSnackbar.show(context: context, message: "Cancel");
                    }
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
    );
  }
}
