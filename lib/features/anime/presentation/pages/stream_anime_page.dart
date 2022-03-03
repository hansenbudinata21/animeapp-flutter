import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../core/widgets/circular_loading.dart';

class StreamAnimePage extends StatefulWidget {
  final String url;
  const StreamAnimePage({Key? key, required this.url}) : super(key: key);

  @override
  State<StreamAnimePage> createState() => _StreamAnimePageState();
}

class _StreamAnimePageState extends State<StreamAnimePage> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  bool showLoading = true;

  @override
  void initState() {
    WebView.platform = AndroidWebView();
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            body: SizedBox(
              height: 1.sh,
              width: 1.sw,
              child: RotatedBox(
                quarterTurns: 1,
                child: WebView(
                  initialUrl: widget.url,
                  javascriptMode: JavascriptMode.unrestricted,
                  navigationDelegate: (NavigationRequest request) {
                    return NavigationDecision.prevent;
                  },
                  onPageFinished: (_) async {
                    WebViewController controller = await (_controller.future);
                    await controller.runJavascript("document.getElementById('list-server-more').style.display = 'none'");
                    await controller.runJavascript("jwplayer('myVideo').setFullscreen(true);");
                    setState(() {
                      showLoading = false;
                    });
                  },
                  onWebViewCreated: (WebViewController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
            ),
          ),
        ),
        showLoading
            ? Container(
                height: 1.sh,
                width: 1.sw,
                color: AppColor.black,
                child: CircularLoading(size: 70.w),
              )
            : Container(),
      ],
    );
  }
}
