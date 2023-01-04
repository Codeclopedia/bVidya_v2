import '/core/ui_core.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  final String url;
  final String title;
  const WebViewScreen({super.key, required this.url, required this.title});

  // late WebViewController webViewController;

  WebViewController initializeController(url) => WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },

        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        // onNavigationRequest: (NavigationRequest request) {
        //   if (request.url.startsWith('https://www.youtube.com/')) {
        //     return NavigationDecision.prevent;
        //   }
        //   return NavigationDecision.navigate;
        // },
      ),
    )
    ..loadRequest(Uri.parse(url));

  @override
  Widget build(BuildContext context) {
    WebViewController webViewController = initializeController(url);
    return WillPopScope(
      onWillPop: () async {
        if (await webViewController.canGoBack()) {
          await webViewController.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(title),
        ),
        body: WebViewWidget(controller: webViewController),
      ),
    );
  }
}
