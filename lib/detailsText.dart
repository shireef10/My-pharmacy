import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class detailsText extends StatelessWidget {
  String webLink;

  detailsText(this.webLink);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: webLink,
      ),
    );
  }
}
