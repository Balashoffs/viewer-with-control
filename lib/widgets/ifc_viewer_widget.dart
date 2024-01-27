import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class IfcViewerWidget extends StatefulWidget {
  @override
  _IfcViewerWidgetState createState() =>
      _IfcViewerWidgetState();
}

class _IfcViewerWidgetState extends State<IfcViewerWidget> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
    allowContentAccess: true,
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    javaScriptEnabled: true,
    safeBrowsingEnabled: false,
  );

  late ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              id: 1,
              title: "Special",
              action: () async {
                print("Menu item Special clicked!");
                print(await webViewController?.getSelectedText());
                await webViewController?.clearFocus();
              })
        ],
        settings: ContextMenuSettings(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
          print("onCreateContextMenu");
          print(hitTestResult.extra);
          print(await webViewController?.getSelectedText());
        },
        onHideContextMenu: () {
          print("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = contextMenuItemClicked.id;
          print("onContextMenuActionItemClicked: " +
              id.toString() +
              " " +
              contextMenuItemClicked.title);
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(url: WebUri('http://localhost:8080/')),
          initialUserScripts: UnmodifiableListView<UserScript>([]),
          initialSettings: settings,
          contextMenu: contextMenu,
          onWebViewCreated: (controller) async {
            webViewController = controller;
          },
          onLoadStart: (controller, url) async {
            setState(() {
              this.url = url.toString();
              urlController.text = this.url;
            });
          },
          onPermissionRequest: (controller, request) async {
            return PermissionResponse(
                resources: request.resources,
                action: PermissionResponseAction.GRANT);
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            var uri = navigationAction.request.url!;

            if (![
              "http",
              "https",
              "file",
              "chrome",
              "data",
              "javascript",
              "about"
            ].contains(uri.scheme)) {
              if (await canLaunchUrl(uri)) {
                // Launch the App
                await launchUrl(
                  uri,
                );
                // and cancel the request
                return NavigationActionPolicy.CANCEL;
              }
            }

            return NavigationActionPolicy.ALLOW;
          },
          onLoadStop: (controller, url) async {
            setState(() {
              this.url = url.toString();
              urlController.text = this.url;
            });
          },
          onReceivedError: (controller, request, error) {},
          onProgressChanged: (controller, progress) {
            if (progress == 100) {}
            setState(() {
              this.progress = progress / 100;
              urlController.text = this.url;
            });
          },
          onUpdateVisitedHistory: (controller, url, isReload) {
            setState(() {
              this.url = url.toString();
              urlController.text = this.url;
            });
          },
          onConsoleMessage: (controller, consoleMessage) {
            print(consoleMessage);
          },
        ),
        progress < 1.0 ? LinearProgressIndicator(value: progress) : Container(),
      ],
    );
  }
}
