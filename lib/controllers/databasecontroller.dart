import 'package:get/get.dart';
import 'package:my_getx/Models/notesmodel.dart';
import 'package:my_getx/data/local/db_helper.dart';

class Databasecontroller extends GetxController {
  var notes = <NotesModel>[]
      .obs; // obs is used for syncing or observing like changenotifier in provider
  final DBHelper dbHelper = Get.put(DBHelper.getInstance);

  Future<void> addnotes(NotesModel notesModel) async {
    await dbHelper.addNote(newNote: notesModel); //additing data in Database
    notes.add(notesModel); //additing data in notes veriable

    List<NotesModel> data = await dbHelper.getAllNotes();

    notes.assignAll(data);
  }

  Future<void> fetchNotes() async {
    await dbHelper.getDb();
    List<NotesModel> data = await dbHelper.getAllNotes();

    notes.assignAll(data);
  }

  Future<void> deleteNotes({required int rowindex}) async {
    await dbHelper.deleteNotes(rowIndex: rowindex);

    List<NotesModel> data = await dbHelper.getAllNotes();

    notes.assignAll(data);
  }

  Future<void> notesUpdate(
      {required int rowindex, required NotesModel notesModel}) async {
    await dbHelper.updateNotes(rowIndex: rowindex, newNote: notesModel);
    List<NotesModel> data = await dbHelper.getAllNotes();

    notes.assignAll(data);
  }
}
