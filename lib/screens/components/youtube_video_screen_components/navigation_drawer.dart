import 'package:flutter/material.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  Color selectedFontColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            ExpansionTile(
              title: Text("Kategori İşlemleri",
                  style: TextStyle(color: selectedFontColor)),
              backgroundColor: Colors.blue,
              collapsedBackgroundColor: Colors.black,
              childrenPadding: EdgeInsets.only(left: 10, top: 10),
              onExpansionChanged: (state) {
                switch (state) {
                  case true:
                    {
                      selectedFontColor = Colors.black;
                      setState(() {});
                      break;
                    }
                  case false:
                    {
                      selectedFontColor = Colors.white;
                      setState(() {});
                      break;
                    }
                }
              },
              children: [
                Container(
                  child: ListTile(
                    title: Text("Kategori Ekle"),
                    trailing: IconButton(
                      tooltip: "Kategori Ekle",
                      icon: Icon(Icons.open_in_new_outlined),
                      onPressed: goToCategoryAdd,
                    ),
                    leading: Icon(Icons.add_to_photos_rounded),
                  ),
                ),
                Container(
                  child: ListTile(
                    title: Text("Kategorileri Listele"),
                    trailing: IconButton(
                      tooltip: "Kategori Listele",
                      icon: Icon(Icons.open_in_new_outlined),
                      onPressed: goToCategoryList,
                    ),
                    leading: Icon(Icons.view_list),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void goToCategoryAdd() {
    Navigator.pushNamed(context, "/addCategory");
  }

  void goToCategoryList() {
    Navigator.pushNamed(context, "/categories");
  }
}
