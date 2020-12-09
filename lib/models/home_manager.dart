import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:storeapp/models/section.dart';

class HomeManager  extends ChangeNotifier{

  List<Section> _sections = [];
  List<Section> _editingSections = [];
  bool editing = false;
  bool loading = false;

  final Firestore firestore = Firestore.instance;

  HomeManager(){
    _loadSections();
  }

  Future<void> _loadSections() async {
    
    firestore.collection('home').orderBy('position').snapshots().listen((event) {
      _sections.clear();
      for(final DocumentSnapshot doc in event.documents) {
        _sections.add(Section.fromDocument(doc));
      }
      notifyListeners();
    });

  }

  List<Section> get sections {
    if(editing)
      return _editingSections;
    else
      return _sections;
  }

  void enterEditing() {
    editing = true;
    _editingSections = _sections.map((e) => e.clone()).toList();
    notifyListeners();
  }

  Future<void> saveEditing() async {
    bool valid = true;
    for(final section in _editingSections){
      if(!section.valid()) valid = false;
    }
    if(!valid) return;

    loading = true;
    notifyListeners();

    int position = 0;
    for(final section in _editingSections){
      await section.save(position);
      position++;
    }

    for(final section in List.from(_sections)){
      if(!_editingSections.any((element) => element.id == section.id)){
        await section.delete();
      }
    }

    editing = false;
    loading = false;
    notifyListeners();
  }

  void discardEditing() {
    editing = false;
    notifyListeners();
  }

  void addSection(Section section) {
    _editingSections.add(section);
    notifyListeners();
  }

  void removeSection(Section section){
    _editingSections.remove(section);
    notifyListeners();
  }

}