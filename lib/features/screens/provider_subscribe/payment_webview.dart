import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../core/routing/navigation_services.dart';
import '../../../presentation/component/custom_app_bar.dart';
import '../../core/routing/routes_provider.dart';

class PaymentScreen extends StatefulWidget {
  final String? url;

  const PaymentScreen({Key? key, this.url}) : super(key: key);

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  double value = 0.0;
  PullToRefreshController? pullToRefreshController;
  MyInAppBrowser browser = MyInAppBrowser();

  @override
  void initState() {
    super.initState();
    browser.setController(browser.controller);

    _initData();
  }

  void _initData() async {
    if (Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

      bool swAvailable = await AndroidWebViewFeature.isFeatureSupported(
          AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
      bool swInterceptAvailable =
          await AndroidWebViewFeature.isFeatureSupported(
              AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

      if (swAvailable && swInterceptAvailable) {
        AndroidServiceWorkerController serviceWorkerController =
            AndroidServiceWorkerController.instance();
        await serviceWorkerController
            .setServiceWorkerClient(AndroidServiceWorkerClient(
          shouldInterceptRequest: (request) async {
            return null;
          },
        ));
      }
    }

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(color: Colors.black),
      onRefresh: () async {
        if (Platform.isAndroid) {
          browser.webViewController.reload();
        } else if (Platform.isIOS) {
          browser.webViewController.loadUrl(
              urlRequest:
                  URLRequest(url: await browser.webViewController.getUrl()));
        }
      },
    );
    browser.pullToRefreshController = pullToRefreshController;

    await browser.openUrlRequest(
      urlRequest: URLRequest(url: Uri.parse(widget.url ?? '')),
      options: InAppBrowserClassOptions(
        crossPlatform:
            InAppBrowserOptions(hideUrlBar: true, hideToolbarTop: true),
        inAppWebViewGroupOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
              useShouldOverrideUrlLoading: true, useOnLoadResource: true),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'صفحة الدفع',
      ),

    );
  }
}

class MyInAppBrowser extends InAppBrowser {

  bool _canRedirect = true;
  InAppWebViewController? controller;

  void setController(controller) {
    this.controller = controller;
  }

  @override
  Future onBrowserCreated() async {
    if (kDebugMode) {
      print("\n\nBrowser Created!\n\n");
    }
  }

  @override
  Future onLoadStart(url) async {
    if (kDebugMode) {
      print("\n\nmy url is  Started: $url\n\n");
    }
    _redirect(url.toString());
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("\n\nStopped: $url\n\n");
    }
    _redirect(url.toString());
  }

  @override
  Future<void> onLoadError(url, code, message) async {
    if (await webViewController.canGoBack()) {
      await webViewController.clearCache();
      await webViewController.goBack();
    }
    if (kDebugMode) {
      print("Can't load [$url] Error: $message");
    }
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
  }

  @override
  void onExit() {
    if (kDebugMode) {
      print("\n\nBrowser closed!\n\n");
      if (NavigationService.canGoBack()) {
        NavigationService.goBack();
      }
    }
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(
      navigationAction) async {
    if (kDebugMode) {
      print("\n my url is Override ${navigationAction.request.url}\n");
    }
    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onLoadResource(resource) {}

  @override
  void onConsoleMessage(consoleMessage) {
    if (kDebugMode) {
      print("""
    console output:
      message: ${consoleMessage.message}
      messageLevel: ${consoleMessage.messageLevel.toValue()}
   """);
    }
  }

  void _redirect(String url) {
    print('my url is $url');
    if (_canRedirect) {
      bool isSuccess =
          url.contains('alrajhi-verify-response') && url.contains('status=1');
      bool isFailed = (url.contains('alrajhi-verify-response') &&
              url.contains('status=2')) ||
          (url.contains('https://doneapp.org/payment-verify') &&
              url.contains('success=false'));
      bool isCancel = url.contains('alrajhi-verify-response') &&
          url.contains('status=cancel');
      if (isSuccess || isFailed || isCancel) {
        _canRedirect = false;

        close();

        if (NavigationService.canGoBack()) {
          NavigationService.goBack();
        }
        Future.delayed(Duration(seconds: 2));
        if (isSuccess) {
          print('success');
          NavigationService.push(RoutesProvider.providerHomeScreen);
          Fluttertoast.showToast(
              msg: 'تم الدفع بنجاح',
              backgroundColor: Colors.green,
              gravity: ToastGravity.BOTTOM);
        } else if (isFailed) {
          print('failed');
          NavigationService.goBack();
          Fluttertoast.showToast(
              msg: 'فشل الدفع',
              backgroundColor: Colors.red,
              gravity: ToastGravity.BOTTOM,
              textColor: Colors.black);
        }
      }
    } else {
      if (NavigationService.canGoBack()) {
        NavigationService.goBack();
      }
    }
  }
}
