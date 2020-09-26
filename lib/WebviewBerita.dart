import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/models/BeritaArguments.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewBerita extends StatefulWidget {
  @override
  _WebviewBeritaState createState() => _WebviewBeritaState();
}

class _WebviewBeritaState extends State<WebviewBerita> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {

    final BeritaArguments args = ModalRoute.of(context).settings.arguments;
    final String Url = args.url;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: WebView(
        initialUrl: Url,
        javaScriptMode: JavaScriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}