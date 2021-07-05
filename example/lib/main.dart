import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:m3u8_downloader/m3u8_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _downloader = M3u8Downloader();
  ReceivePort _port = ReceivePort();

  // 未加密的url地址
  String url = "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8";

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  void initAsync() async {
    WidgetsFlutterBinding.ensureInitialized();

    String saveDir = await _findSavePath();
    _downloader.initialize(
        saveDir: saveDir,
        debugMode: false,
        onSelect: () {
          print('下载成功点击');
          return null;
        });
    // 注册监听器
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      // 监听数据请求
      print(data);
    });
  }

  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<String> _findSavePath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    String saveDir = directory.path + '/vPlayDownload';
    Directory root = Directory(saveDir);
    if (!root.existsSync()) {
      await root.create();
    }
    print(saveDir);
    return saveDir;
  }

  static progressCallback(dynamic args) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    args["status"] = 1;
    send.send(args);
  }

  static successCallback(dynamic args) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send({
      "status": 2,
      "url": args["url"],
      "filePath": args["filePath"],
      "dir": args["dir"]
    });
  }

  static errorCallback(dynamic args) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send({"status": 3, "url": args["url"]});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
                child: Text("Start Download"),
                onPressed: () {
                  _checkPermission().then((hasGranted) async {
                    if (hasGranted) {
                      _downloader.download(
                          url: url,
                          name: "下载未加密m3u8",
                          progressCallback: progressCallback,
                          successCallback: successCallback,
                          errorCallback: errorCallback);
                    }
                  });
                }),
            ElevatedButton(
                child: Text("Stop Download"),
                onPressed: () {
                  _downloader.cancel(url);
                }),
            ElevatedButton(
              child: Text("Get File Status"),
              onPressed: () async {
                var res = await _downloader.getSavePath(url);
                print(res);
                File mp4 = File(res['mp4']);
                if (mp4.existsSync()) {
                  OpenFile.open(res['mp4']);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
