import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:path/path.dart' as pathFinder;
import 'package:permission_handler/permission_handler.dart';


class ImagesManager {
  List<FileSystemEntity> images = [];
  String path = 'Android/media/com.whatsapp/WhatsApp/Media/.Statuses';
  String oldPath = 'WhatsApp/Media/.Statuses';
  String storagePath = 'DCIM';
  String videoStoragePath = 'Videos';

  Future<String> getLocalPath() async
  {
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    final dir= storageInfo[0].rootDir;
    return dir;
  }

  Future<List<FileSystemEntity>> loadImages() async
  {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final root = await getLocalPath();
    Directory dir = Directory('$root/$path');
    Directory oldDir = Directory('$root/$oldPath');

    List<FileSystemEntity> _files;
    List<FileSystemEntity> _oldFiles;

    try{
      _files = dir.listSync(recursive: false, followLinks: true);
      _files.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));

      for(FileSystemEntity entity in _files) {
        String path = entity.path;
        if(path.endsWith('.png') || path.endsWith('.jpg') || path.endsWith('.jpeg'))
          images.add(entity);
      }
    }catch(e){
    }

    try{
      _oldFiles = oldDir.listSync(recursive: false, followLinks: true);
      _oldFiles.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
      for(FileSystemEntity entity in _oldFiles) {
        String path = entity.path;
        if(path.endsWith('.png') || path.endsWith('.jpg') || path.endsWith('.jpeg'))
          images.add(entity);
      }
    }catch(e){
    }

    return images;
  }

  Future<List<FileSystemEntity>> loadVideos() async
  {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final root = await getLocalPath();
    Directory dir = Directory('$root/$path');
    Directory oldDir = Directory('$root/$oldPath');

    List<FileSystemEntity> _files;
    List<FileSystemEntity> _oldFiles;

    try{
      _files = dir.listSync(recursive: false, followLinks: true);
      _files.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));

      for(FileSystemEntity entity in _files) {
        String path = entity.path;
        if(path.endsWith('.mp4') || path.endsWith('.mkv'))
          images.add(entity);
      }
    }catch(e){
    }

    try{
      _oldFiles = oldDir.listSync(recursive: false, followLinks: true);
      _oldFiles.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
      for(FileSystemEntity entity in _oldFiles) {
        String path = entity.path;
        if(path.endsWith('.mp4') || path.endsWith('.mkv'))
          images.add(entity);
      }
    }catch(e){
    }
    return images;
  }

  void saveImageToStorage(String filePath, bool isImage) async
  {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final root = await getLocalPath();
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyyMMddHHmmss');
    final String formatted = formatter.format(now);
    String filename = 'status$formatted';
    String location = isImage ? '$root/$storagePath' : '$root/$videoStoragePath';

    Directory dir = Directory('$location');

    if (!await dir.exists()){
      await dir.create(recursive: true);
    }

    final extension = pathFinder.extension(filePath); // '.dart'
    final File image =new File(filePath);


    image.copy('$location/$filename$extension');

  }


}