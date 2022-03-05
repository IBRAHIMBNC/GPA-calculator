import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_practice/models/semester.dart';
import 'package:getx_practice/models/subject.dart';
import 'package:getx_practice/screens/homeScreen.dart';
import 'package:provider/provider.dart';

class AddSemesterScreen extends StatefulWidget {
  final Semester semesterIns;
  AddSemesterScreen({Key? key, required this.semesterIns}) : super(key: key);

  @override
  State<AddSemesterScreen> createState() => _AddSemesterScreenState();
}

class _AddSemesterScreenState extends State<AddSemesterScreen> {
  RxList<Subject> subjects = RxList([]);
  final _gpaCon = TextEditingController();

  Rx<double> gpa = 0.0.obs;

  Rx<int> hours = 2.obs;

  String subjectName = '';
  @override
  void initState() {
    subjects.value = [...widget.semesterIns.subjects];
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispo
    _gpaCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final semester = Provider.of<Semesters>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                if (widget.semesterIns.subjects.isNotEmpty) {
                  print(widget.semesterIns.subjects);
                  widget.semesterIns.subjects = subjects;
                  widget.semesterIns.gpa = semesterGpa();
                  semester.upadteSemester(widget.semesterIns);
                } else {
                  widget.semesterIns.subjects = subjects;
                  widget.semesterIns.gpa = semesterGpa();
                  semester.addSemester(widget.semesterIns);
                }
                Get.offAll(() => HomeScreen(),
                    transition: Transition.rightToLeft);
              },
              icon: const Icon(Icons.save))
        ],
        backgroundColor: Colors.blue[900],
        title: Text(widget.semesterIns.name),
        centerTitle: true,
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          height: size.height,
          width: double.infinity,
          child: Obx(
            () => subjects.isEmpty
                ? const Center(
                    child: Text(
                    'No subjects',
                    style: TextStyle(fontSize: 20),
                  ))
                : ListView.separated(
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(subjects[index].gpa.toString()),
                          ),
                          title: Text(subjects[index].name),
                          trailing: IconButton(
                              onPressed: () {
                                subjects.removeAt(index);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 5,
                        ),
                    itemCount: subjects.length),
          )),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue[900],
        onPressed: () => addSubject(),
        label: const Text('Add Subject'),
      ),
    );
  }

  double semesterGpa() {
    int hrs = 0;
    double gradePoints = 0.0;
    double semGpa;

    for (var sub in subjects) {
      gradePoints += sub.creditHrs * sub.gpa;
      hrs += sub.creditHrs;
    }
    if (hrs == 0) return 0.0;
    semGpa = gradePoints / hrs;
    return semGpa;
  }

  // void addSubject() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (ctx) {
  //       return Container(
  //         padding: const EdgeInsets.all(10),
  //         child: Column(
  //           children: [
  //             const SizedBox(
  //               height: 10,
  //             ),
  //             TextField(
  //                 onChanged: (val) {
  //                   subjectName = val;
  //                 },
  //                 decoration: const InputDecoration(
  //                     border: OutlineInputBorder(), label: Text('Subject'))),
  //             const SizedBox(
  //               height: 10,
  //             ),
  //             TextFormField(
  //                 controller: _gpaCon,
  //                 autovalidateMode: AutovalidateMode.always,
  //                 keyboardType: TextInputType.number,
  //                 validator: (val) {
  //                   if (val!.isEmpty) {
  //                     return 'Enter grade';
  //                   } else if (double.parse(val) < 0.0 ||
  //                       double.parse(val) > 4.0) {
  //                     return 'Enter correct GPA';
  //                   }
  //                 },
  //                 decoration: const InputDecoration(
  //                     border: OutlineInputBorder(), label: Text('GPA'))),
  //             const SizedBox(
  //               height: 10,
  //             ),

  //             // Obx(
  //             //   () => Card(
  //             //     elevation: 4,
  //             //     child: Padding(
  //             //       padding: const EdgeInsets.all(8.0),
  //             //       child: DropdownButton(
  //             //         menuMaxHeight: 300,
  //             //         hint: const Text('Select GPA'),
  //             //         underline: const SizedBox(),
  //             //         isExpanded: true,
  //             //         value: gpa.value,
  //             //         onChanged: (newValue) {
  //             //           gpa.value = newValue as double;
  //             //         },
  //             //         items: [
  //             //           0.0,
  //             //           2.0,
  //             //           2.1,
  //             //           2.2,
  //             //           2.3,
  //             //           2.4,
  //             //           2.5,
  //             //           2.6,
  //             //           2.7,
  //             //           2.8,
  //             //           2.9,
  //             //           3.0,
  //             //           3.1,
  //             //           3.2,
  //             //           3.3,
  //             //           3.4,
  //             //           3.5,
  //             //           3.6,
  //             //           3.7,
  //             //           3.8,
  //             //           3.9,
  //             //           4.0
  //             //         ].map((item) {
  //             //           return DropdownMenuItem(
  //             //               value: item, child: Text(item.toString()));
  //             //         }).toList(),
  //             //       ),
  //             //     ),
  //             //   ),
  //             // ),
  //             Obx(
  //               () => Card(
  //                 elevation: 4,
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: DropdownButton(
  //                     underline: const SizedBox(),
  //                     isExpanded: true,
  //                     value: hours.value,
  //                     onChanged: (newValue) {
  //                       hours.value = newValue as int;
  //                     },
  //                     items: [2, 3, 4].map((item) {
  //                       return DropdownMenuItem(
  //                           value: item, child: Text(item.toString()));
  //                     }).toList(),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 10,
  //             ),
  //             ElevatedButton(
  //                 onPressed: () {
  //                   if (subjectName.trim().isEmpty) {
  //                     ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //                     Get.back();
  //                     ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
  //                         backgroundColor: Colors.red,
  //                         content: Text('Subject name must not be empty')));

  //                     return;
  //                   }
  //                   handleSave();
  //                   Get.back();
  //                 },
  //                 child: const Text('Save'))
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  void handleSave() {
    subjects.add(Subject(
        creditHrs: hours.value,
        name: subjectName,
        id: DateTime.now().toString(),
        gpa: double.parse(_gpaCon.text)));
    print(widget.semesterIns.subjects);
    subjectName = '';
    gpa.value = 0.0;
    hours.value = 2;
  }

  void addSubject() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Semester'),
        content: Container(
          height: 300,
          padding: const EdgeInsets.all(0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextField(
                    onChanged: (val) {
                      subjectName = val;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), label: Text('Subject'))),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: _gpaCon,
                    autovalidateMode: AutovalidateMode.always,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Enter grade';
                      } else if (double.parse(val) < 0.0 ||
                          double.parse(val) > 4.0) {
                        return 'Enter correct GPA';
                      }
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), label: Text('GPA'))),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton(
                        underline: const SizedBox(),
                        isExpanded: true,
                        value: hours.value,
                        onChanged: (newValue) {
                          hours.value = newValue as int;
                        },
                        items: [2, 3, 4].map((item) {
                          return DropdownMenuItem(
                              value: item, child: Text(item.toString()));
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (subjectName.trim().isEmpty) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        Get.back();
                        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Subject name must not be empty')));

                        return;
                      }
                      handleSave();
                      Get.back();
                    },
                    child: const Text('Save'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
