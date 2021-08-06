import 'package:flutter/material.dart';
import 'package:flutter_bloc_app_2/blocs/concrete/database/sqflite/db_sqflite_youtube_video_bloc.dart';
import 'package:flutter_bloc_app_2/models/concrete/youtube_video.dart';
import 'package:flutter_bloc_app_2/screens/components/youtube_video_screen_components/navigation_drawer.dart';
import 'package:flutter_bloc_app_2/screens/youtube_video_downloader_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:open_file/open_file.dart';

class YoutubeVideoListScreen extends StatefulWidget {
  @override
  _YoutubeVideoListScreenState createState() => _YoutubeVideoListScreenState();
}

class _YoutubeVideoListScreenState extends State<YoutubeVideoListScreen> {
  Future<List<YoutubeVideo>> _initialData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Videolar Listelendi."),
      ),
      floatingActionButton: buildGoToAddVideoScreenButton(context),
      body: buildVideoList(),
    );
  }

  buildVideoList() {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: FutureBuilder(
        initialData: _initialData,
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              snapshot.data == null) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Veriler Çekiliyor. Lütfen Bekleyiniz..."),
                CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                ),
              ],
            ));
          } else {
            return snapshot.data.length > 0
                ? buildVideoListItems(snapshot.data)
                : Center(child: Text("Herhangi Bir Video Bulunamadı."));
          }
        },
      ),
    );
  }

  buildVideoListItems(var videos) {
    return ListView.builder(
      itemCount: videos.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 8, left: 8, bottom: 15),
          child: buildSlidableWidget(videos, index),
        );
      },
    );
  }

  Slidable buildSlidableWidget(list, int index) {
    return Slidable(
      secondaryActions: [
        IconSlideAction(
          onTap: () async {
            await goToSelectedYoutubeVideoScreen(
                list[index].isVideoDownloaded,
                list[index].isAudioDownloaded,
                list[index],
                DownloaderState.Audio);
          },
          color: Colors.blue,
          icon: list[index].audioIsDownloadedIcon,
          foregroundColor: Colors.black,
          iconWidget: Text(
              list[index].audioIsDownloadedIcon == Icons.ondemand_video_outlined
                  ? "Sesini Dinle"
                  : "Sesini İndir",
              style: TextStyle(color: Colors.black)),
        ),
        IconSlideAction(
          onTap: () async {
            await goToSelectedYoutubeVideoScreen(
                list[index].isVideoDownloaded,
                list[index].isAudioDownloaded,
                list[index],
                DownloaderState.Video);
          },
          color: Colors.blue,
          icon: list[index].videoIsDownloadedIcon,
          foregroundColor: Colors.black,
          iconWidget: Text(
              list[index].videoIsDownloadedIcon == Icons.ondemand_video_outlined
                  ? "Videoyu İzle"
                  : "Videoyu İndir",
              style: TextStyle(color: Colors.black)),
        )
      ],
      actions: [
        IconSlideAction(
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            dbSqfliteYoutubeVideoBloc.delete(list[index]).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                content: Text(value),
              ));
              getData();
            });
          },
          foregroundColor: Colors.black,
          caption: "Sil",
        ),
      ],
      actionPane: SlidableScrollActionPane(),
      child: ListTile(
        trailing: Icon(list[index].videoIsDownloadedIcon),
        subtitle: Text(
            "Video İndirildi Mi: ${list[index].isVideoDownloaded == true ? "Evet" : "Hayır"}\nSes Dosyası İndirildi Mi: ${list[index].isAudioDownloaded == true ? "Evet" : "Hayır"}",
            style: TextStyle(color: Colors.black)),
        tileColor: Colors.orange,
        title: Text(list[index].name, style: TextStyle(color: Colors.black)),
      ),
    );
  }

  buildGoToAddVideoScreenButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        goToAddVideoScreen(context);
      },
    );
  }

  goToAddVideoScreen(BuildContext context) async {
    await Navigator.pushNamed(context, "/addVideo");
    getData();
  }

  Future<List<YoutubeVideo>> getData() async {
    _initialData = dbSqfliteYoutubeVideoBloc.getAll();
    setState(() {});
    return _initialData == null
        ? await dbSqfliteYoutubeVideoBloc.getAll()
        : _initialData;
  }

  goToSelectedYoutubeVideoScreen(bool isVideoDownloaded, bool isAudioDownloaded,
      YoutubeVideo video, DownloaderState downloaderState) {
    if (downloaderState == DownloaderState.Video) {
      if (isVideoDownloaded == false) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (cont) =>
                new YoutubeVideoDownloaderScreen(video, downloaderState),
          ),
        ).then((value) {
          getData();
        });
      } else {
        OpenFile.open(
          video.videoPath,
        );
      }
    } else {
      if (isAudioDownloaded == false) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (cont) =>
                new YoutubeVideoDownloaderScreen(video, downloaderState),
          ),
        ).then((value) {
          getData();
        });
      } else {
        OpenFile.open(
          video.musicPath,
        );
      }
    }
  }
}
