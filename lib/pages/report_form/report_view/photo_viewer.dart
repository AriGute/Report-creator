import 'package:B.E.E/pages/shared/loading.dart';
import 'package:B.E.E/services/database.dart';
import 'package:flutter/material.dart';

class PhotoViewer extends StatefulWidget {
  final String reportUid;
  PhotoViewer(this.reportUid);
  @override
  _PhotoViewerState createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  final DatabaseService db = DatabaseService();
  List<Widget> imgList = [Loading()];

  void getPhotos() async {
    List<String> list = await db.getPhotos(widget.reportUid);
    imgList = [];
    list.forEach((url) {
      imgList.add(Image(image: NetworkImage(url)));
      imgList.add(Divider(
        color: Colors.grey,
      ));
    });
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Photo viewer:",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red[500],
        ),
        body: ListView(children: [Column(children: imgList)]));
  }
}
