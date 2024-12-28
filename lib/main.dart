import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_getx/Models/notesmodel.dart';
import 'package:my_getx/controllers/databasecontroller.dart';
import 'package:my_getx/data/local/db_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: MyAppDash(),
    );
  }
}

class MyAppDash extends StatefulWidget {
  @override
  State<MyAppDash> createState() => _MyAppDashState();
}

class _MyAppDashState extends State<MyAppDash> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TextEditingController updateTitleController = TextEditingController();
  TextEditingController updateDescriptionController = TextEditingController();
  List<NotesModel> allNotes = [];

  final Databasecontroller databaseController = Get.put(Databasecontroller());

  DBHelper? mainDB;

  @override
  void initState() {
    super.initState();
    // mainDB = DBHelper.getInstance;
    getInitialNotes();
  }

  getInitialNotes() async {
    databaseController.fetchNotes();
    log("GetInitial Fuction is Called ");
  }

  @override
  Widget build(BuildContext context) {
    log("build Contactax called");
    return Scaffold(
      appBar: AppBar(
        title: Text("App#1"),
      ),
      body: Obx(() => databaseController.notes.isNotEmpty
          ? ListView.builder(
              itemCount: databaseController.notes.length,
              itemBuilder: (_, index) {
                log("Only GETX  List View is called");
                return ListTile(
                  leading: Text.rich(
                    TextSpan(
                        text:
                            "Sn:${databaseController.notes[index].s_n.toString() }\n",
                        children: [
                          TextSpan(text: "In:${index.toString()}"),
                        ]),
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        databaseController.deleteNotes(
                            rowindex: databaseController.notes[index].s_n!);
                        /*  mainDB!.deleteNotes(
                        rowIndex: databaseController.notes[index].s_n!);*/
                      },
                      icon: Icon(Icons.delete)),
                  title: Text(databaseController.notes[index].title),
                  subtitle: Text(databaseController.notes[index].description),
                  onLongPress: () {
                    updateTitleController.text =
                        databaseController.notes[index].title;
                    updateDescriptionController.text =
                        databaseController.notes[index].description;
                    showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            child: Column(children: [
                              Text(
                                "Notes data",
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: updateTitleController,
                                decoration: InputDecoration(
                                    label: Text("Enter your title"),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(21),
                                    )),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: updateDescriptionController,
                                decoration: InputDecoration(
                                    label: Text("update your Description"),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(21),
                                    )),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  OutlinedButton(
                                      onPressed: () {
                                        updateNotesInDB(
                                            updateIndex: databaseController.notes[index].s_n!);
                                        Navigator.pop(context);
                                      },
                                      child: Text("update")),
                                  OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("cancel")),
                                ],
                              )
                            ]),
                          );
                        });
                  },
                );
              })
          : Text("No notes found")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (_) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  child: Column(children: [
                    Text(
                      "New Notes data",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                          label: Text("Enter your title"),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                          label: Text("Enter your Description"),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                            onPressed: () {
                              addNotesInDB();
                              Navigator.pop(context);
                            },
                            child: Text("add")),
                        OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("cancel")),
                      ],
                    )
                  ]),
                );
              });

          // mainDB!.addNote(title: "kumar", desc: "baman");
          // getInitialNotes();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void addNotesInDB() async {
    var formTitle = titleController.text.toString();
    var formDescription = descriptionController.text.toString();

    databaseController.addnotes(NotesModel(
        title: formTitle, description: formDescription)); // using GetX

    /* bool check = await mainDB!.addNote(
        newNote: NotesModel(title: formTitle, description: formDescription));

    String msg;

    getInitialNotes();

    if (!check) {
      msg = "note addtion is failed";
    } else {
      msg = "note added Successfully";
      getInitialNotes();
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    */
  }

  ////updation function

  void updateNotesInDB({required int updateIndex}) async {
    // Fetch the updated values from the controllers
    var updateFormTitle = updateTitleController.text.trim();
    var updateFormDescription = updateDescriptionController.text.trim();

    // Update the note in the database
    await databaseController.notesUpdate(
        rowindex: updateIndex,
        notesModel: NotesModel(
            title: updateFormTitle, description: updateFormDescription));

    Get.snackbar("Update!" , " records has updated");

    // Prepare a message based on the success/failure of the update
    /* String msg;
    if (check < 0) {
      msg = "Note update failed";
    } else {
      msg = "Note updated successfully";
      // Reload the notes after a successful update
      getInitialNotes();
    }

    // Show a snackbar with the appropriate message
    if (context.mounted) {
      // Ensure context is still valid
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }*/
  }
}
