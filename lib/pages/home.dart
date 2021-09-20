import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:status_capture/pages/VideoItems.dart';
import 'dart:io';
import 'package:status_capture/services/loadimages.dart';
import 'package:video_player/video_player.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<FileSystemEntity> images = [];
  bool isVideo = false;


  void loadImages() async{
    ImagesManager manager = new ImagesManager();
    final getImages =await manager.loadImages();
    setState(() {
      images = getImages;
      isVideo = false;
    });
  }

  void loadVideos() async{
    ImagesManager manager = new ImagesManager();
    final getImages =await manager.loadVideos();

    setState(() {
      images = getImages;
      isVideo = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Widget displayImage(index){
    return Container(
        child: FlatButton(
          onPressed: () {
            dynamic result = Navigator.pushNamed(context, '/save', arguments:
            {
              'path' : images[index].path,
              'isImage' : true
            });
            },
          child: Image.file(
              File(images[index].path)
          ),
        )
    );
  }

  Widget displayVideo(index){
    return Container(
      child: FlatButton(
        onPressed: () {
          dynamic result = Navigator.pushNamed(context, '/save', arguments:
          {
            'path' : images[index].path,
            'isImage' : false
          });
        },
        child: VideoItems(
          videoPlayerController: VideoPlayerController.file(File(images[index].path)),
          looping: false,
          autoplay: false,
          showControls: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
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
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        loadImages();
                      },
                      icon: Icon(
                        Icons.camera_alt,
                        size: 50.0,
                        color: Colors.white,
                      ), label: Text(''),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: FlatButton.icon(
                      onPressed: () {
                        loadVideos();
                      },
                      icon: Icon(
                        Icons.videocam_sharp,
                        size: 50.0,
                        color: Colors.white,
                      ), label: Text(''),
                    ),
                  ),
                ],
              ),
            ),
            GridView.builder(
              itemCount: images.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index)
              {
                if(isVideo){
                    return displayVideo(index);
                }
                else
                  return displayImage(index);
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}