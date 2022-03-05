import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:getx_practice/models/subject.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Semester {
  final String name;
  double gpa;
  List<Subject> subjects;

  Semester({required this.name, required this.gpa, required this.subjects});

  factory Semester.fromPrefs(Map<String, dynamic> map) {
    List<dynamic> subList = map['subjects'];
    List<Subject> newList = subList
        .map((sub) => Subject(
            creditHrs: sub['creditHrs'],
            name: sub['name'],
            id: sub['id'],
            gpa: sub['gpa']))
        .cast<Subject>()
        .toList();
    return Semester(name: map['name'], gpa: map['gpa'], subjects: newList);
  }
}

class Semesters with ChangeNotifier {
  List<Semester> _semesters = [];
  Rx<double> cgpa = 0.0.obs;

  void calCgpa() {
    double gpas = 0.0;
    for (var sem in _semesters) {
      gpas += sem.gpa;
    }
    if (_semesters.isEmpty) {
      cgpa.value = 0.0;
    } else {
      cgpa.value = gpas / _semesters.length;
    }
  }

  List<Semester> get semesters {
    return [..._semesters];
  }

  Future<void> addSemester(Semester sem) async {
    _semesters.add(sem);
    addToPrefes();
  }

  void upadteSemester(Semester sem) {
    int index = _semesters.indexWhere((s) => s.name == sem.name);
    _semesters[index] = sem;
    addToPrefes();
  }

  void deleteSemester(int index) {
    _semesters.removeAt(index);
    addToPrefes();
  }

  Future<void> fetchData() async {
    final sharedPrefs = await SharedPreferences.getInstance();

    if (sharedPrefs.containsKey('userData')) {
      final savedData = json.decode(sharedPrefs.getString('userData')!)
          as Map<String, dynamic>;
      final List<dynamic> extractedList = savedData['semestersData'];
      final temp = [];
      for (var sem in extractedList) {
        temp.add(Semester.fromPrefs(sem));
      }
      _semesters = [...temp];
    }
    calCgpa();
  }

  addToPrefes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = json.encode({
      'semestersData': [
        ..._semesters
            .map((sem) => {
                  'name': sem.name,
                  'gpa': sem.gpa,
                  'subjects': [
                    ...sem.subjects
                        .map((sub) => {
                              'id': sub.id,
                              'name': sub.name,
                              'gpa': sub.gpa,
                              'creditHrs': sub.creditHrs,
                            })
                        .toList()
                  ]
                })
            .toList()
      ]
    });
    prefs.setString('userData', jsonData);
  }
}
