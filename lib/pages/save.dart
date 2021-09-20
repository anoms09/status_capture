import 'dart:io';
import 'package:flutter/material.dart';
import 'package:status_capture/pages/VideoItems.dart';
import 'package:status_capture/services/loadimages.dart';
import 'package:video_player/video_player.dart';

class Save extends StatefulWidget {
  const Save({Key? key}) : super(key: key);

  @override
  _SaveState createState() => _SaveState();
}

class _SaveState extends State<Save> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Map data = {};
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context)?.settings?.arguments as Map;
    bool isImage = data['isImage'];
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Status Capture',
          style: TextStyle(
            letterSpacing: 0.0,
          ),
        ),
        backgroundColor: Colors.green[800],
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.green[800],
              height: 60.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: FlatButton.icon(
                      onPressed: () {
                         ImagesManager manager = new ImagesManager();
                         manager.saveImageToStorage(data['path'], data['isImage']);
                         setState(() {
                           _visible = true;
                         });
                         Future.delayed(Duration(seconds: 2), () {
                           Navigator.pushReplacementNamed(context, '/home', arguments: {
                           });
                         });

                        },
                      icon: Icon(
                        Icons.save,
                        size: 50.0,
                        color: Colors.white,
                      ), label: Text(''),
                    ),
                  ),
                ],

              ),
            ),
            AnimatedOpacity(
              // If the widget is visible, animate to 0.0 (invisible).
              // If the widget is hidden, animate to 1.0 (fully visible).
              opacity: _visible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              // The green box must be a child of the AnimatedOpacity widget.
              child: Container(
                width: 200.0,
                height: 40.0,
                child: Text(
                  'File Saved',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: _visible ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              child: isImage ? Image.file( File(data['path']),
                fit : BoxFit.fitHeight,
              ) : VideoItems(
                videoPlayerController: VideoPlayerController.file(File(data['path'])),
                looping: true,
                showControls: true,
                autoplay: true,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
