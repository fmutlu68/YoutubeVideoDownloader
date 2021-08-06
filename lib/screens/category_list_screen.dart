import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_app_2/blocs/concrete/database/sqflite/db_sqflite_category_bloc.dart';
import 'package:flutter_bloc_app_2/blocs/concrete/database/sqflite/db_sqflite_youtube_video_bloc.dart';
import 'package:flutter_bloc_app_2/models/concrete/category.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CategoryListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kategori Listesi Ekranı"),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 25),
        child: buildListViewFutureBuilder(),
      ),
    );
  }

  Widget buildListViewFutureBuilder() {
    return FutureBuilder<List<Category>>(
      initialData: [],
      future: loadCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return buildCategoryListViewItems(snapshot, context);
        }
      },
    );
  }

  Future<List<Category>> loadCategories() async {
    List<Category> categories = await dbSqfliteCategoryBloc.getAll();
    for (Category category in categories) {
      category.countHasVideo =
          (await dbSqfliteYoutubeVideoBloc.getAllByCategory(category.id))
              .length;
    }
    for (Category category in categories) {
      category.countHasDownloadedVideo =
          (await dbSqfliteYoutubeVideoBloc.getAllByCategory(category.id))
              .where((video) => video.isVideoDownloaded == true)
              .length;
    }
    for (Category category in categories) {
      category.countHasDownloadedAudio =
          (await dbSqfliteYoutubeVideoBloc.getAllByCategory(category.id))
              .where((video) => video.isAudioDownloaded == true)
              .length;
    }
    return categories;
  }

  ListView buildCategoryListViewItems(
      AsyncSnapshot<List<Category>> snapshot, context) {
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (context, index) {
        return Slidable(
          actionPane: SlidableScrollActionPane(),
          secondaryActions: [
            IconSlideAction(
              color: Colors.red,
              foregroundColor: Colors.black,
              icon: Icons.delete,
              caption: "Seçili Katgoriyi Sil",
              onTap: () {
                dbSqfliteCategoryBloc
                    .delete(snapshot.data[index])
                    .then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                    duration: Duration(seconds: 5),
                    content: Text(value),
                  ));
                });
              },
            ),
          ],
          child: Card(
            color: Colors.deepPurple,
            child: buildCategoryTile(snapshot.data[index], context),
          ),
        );
      },
    );
  }

  buildCategoryTile(Category category, context) {
    return ExpansionTile(
      leading: CircleAvatar(
        child: Text(
          category.id.toString(),
        ),
      ),
      title: Text(category.categoryName),
      subtitle: Text(category.directoryPath),
      children: [
        ListTile(
          tileColor: Colors.blueGrey,
          title: Text(category.categoryName),
          subtitle: Text("Kategori Adı"),
        ),
        ListTile(
          tileColor: Colors.blueGrey,
          title: Text(category.directoryPath),
          subtitle: Text("Kategori Klasörünün Konumu"),
          trailing: IconButton(
            icon: Icon(Icons.copy_rounded),
            tooltip: "Klasörün Konumunu Kopyala",
            onPressed: () {
              FlutterClipboard.controlC(category.directoryPath).then((value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  new SnackBar(
                    duration: Duration(seconds: 4),
                    content: Text("Konum Kopyalandı."),
                  ),
                );
              });
            },
          ),
        ),
        ListTile(
          tileColor: Colors.blueGrey,
          title: Text(category.parentId == null
              ? "Yok"
              : "${category.parentId} Nolu Kategori"),
          subtitle: Text("Kategorinin Üst Kategorisi"),
        ),
        ListTile(
          tileColor: Colors.blueGrey,
          title: Text(category.countHasVideo.toString()),
          subtitle: Text("Kategoriye Kaydedilmiş Video Sayısı"),
        ),
        ListTile(
          tileColor: Colors.blueGrey,
          title: Text(category.countHasDownloadedVideo.toString()),
          subtitle: Text("Kategoriye Ait İndirilmiş Video Dosyası Sayısı"),
        ),
        ListTile(
          tileColor: Colors.blueGrey,
          title: Text(category.countHasDownloadedAudio.toString()),
          subtitle: Text("Kategoriye Ait İndirilmiş Sadece Ses Dosyası Sayısı"),
        ),
      ],
    );
  }
}
