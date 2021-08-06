import 'package:flutter/material.dart';
import 'package:flutter_bloc_app_2/blocs/concrete/database/sqflite/db_sqflite_category_bloc.dart';
import 'package:flutter_bloc_app_2/models/concrete/category.dart';

class AddCategoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final form_key = GlobalKey<FormState>();
  bool isParent = false;
  Category category = new Category();
  List<DropdownMenuItem<int>> items = new List<DropdownMenuItem<int>>();
  @override
  void initState() {
    getDropDownItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kategori Ekleme Ekranı"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: form_key,
          child: isParent
              ? Column(
                  children: [
                    getNameField(),
                    SizedBox(
                      height: 30,
                    ),
                    getCheckBoxListTile(),
                    SizedBox(
                      height: 30,
                    ),
                    getCategoriesDropdownButton(),
                    SizedBox(
                      height: 30,
                    ),
                    getSubmitButton(),
                  ],
                )
              : Column(
                  children: [
                    getNameField(),
                    SizedBox(
                      height: 30,
                    ),
                    getCheckBoxListTile(),
                    SizedBox(
                      height: 30,
                    ),
                    getSubmitButton(),
                  ],
                ),
        ),
      ),
    );
  }

  CheckboxListTile getCheckBoxListTile() {
    return CheckboxListTile(
      secondary: Icon(Icons.help),
      value: isParent,
      onChanged: (value) {
        setState(() {
          isParent = value;
        });
      },
      title: Text("Üst Kategorisi Var Mı?"),
      activeColor: Colors.green,
    );
  }

  TextFormField getNameField() {
    return TextFormField(
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      decoration: InputDecoration(
          errorStyle: TextStyle(color: Colors.blue, fontSize: 22),
          hintText: "Kategori İsmi",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          fillColor: Colors.grey,
          filled: true),
      validator: (text) {
        if (text.length == 0) {
          return "Bir Kategori Adı Girilmelidir";
        }
      },
      onSaved: (text) {
        setState(() {
          category.categoryName = text;
        });
      },
    );
  }

  getCategoriesDropdownButton() {
    return DropdownButton<int>(
      value: category.parentId,
      hint: Text(
        "Bİr Üst Kategori Seçin",
      ),
      dropdownColor: Colors.blue,
      onChanged: (value) {
        setState(() {
          category.parentId = value;
        });
      },
      items: items,
    );
  }

  getDropDownItems() async {
    List<Category> result = await dbSqfliteCategoryBloc.getAll();
    setState(() {
      items = result.map((element) {
        return new DropdownMenuItem(
          child: Text(element.categoryName),
          value: element.id,
        );
      }).toList();
    });
  }

  getSubmitButton() {
    return RaisedButton.icon(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        onPressed: () {
          if (form_key.currentState.validate()) {
            form_key.currentState.save();
            dbSqfliteCategoryBloc.add(category).then((value) {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  actions: [
                    OutlinedButton(
                      child: Text("Tamam"),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                  title: Text(value),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
              );
            });
            Navigator.pop(context);
          }
        },
        icon: Icon(Icons.save),
        label: Text("     Kaydet     "));
  }
}
