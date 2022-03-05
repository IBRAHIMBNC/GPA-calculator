import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:getx_practice/models/semester.dart';
import 'package:getx_practice/screens/addSemester_screen.dart';
import 'package:getx_practice/widgets/CGPA.dart';

class HomeScreen extends StatelessWidget {
  RxInt counter = 0.obs;
  RxList<Semester> semesterList = RxList([]);
  HomeScreen({Key? key}) : super(key: key);
  Rx<double> cgpa = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    final semPro = Provider.of<Semesters>(context);

    return Scaffold(
      backgroundColor: Colors.blue[900],
      // appBar: AppBar(
      //   title: Text('GPA Calculator'),
      // ),
      body: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: 10,
          right: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('GPA Calculator',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            Obx(() => CGPA(gpa: semPro.cgpa.value)),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 15),
                decoration: const BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                child: FutureBuilder(
                    future: semPro.fetchData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      semesterList.value = semPro.semesters;

                      return Obx(() {
                        if (semesterList.isEmpty) {
                          return const Center(
                            child: Text(
                              'No semester Added yet',
                              style: TextStyle(fontSize: 18),
                            ),
                          );
                        }
                        return ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                      onTap: () {
                                        Get.to(
                                            () => AddSemesterScreen(
                                                semesterIns:
                                                    semesterList[index]),
                                            transition: Transition.rightToLeft);
                                      },
                                      leading: CircleAvatar(
                                        radius: 22,
                                        child: Text(semesterList[index]
                                            .gpa
                                            .toStringAsFixed(2)),
                                      ),
                                      title: Text(semesterList[index].name),
                                      trailing: IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: Text('Delete Semester'),
                                                content: const Text(
                                                    'Are you sure you want to delete this semester?'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        semesterList
                                                            .removeAt(index);
                                                        Provider.of<Semesters>(
                                                                context,
                                                                listen: false)
                                                            .deleteSemester(
                                                                index);
                                                        Get.back();
                                                      },
                                                      child: Text('Yes')),
                                                  TextButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child: Text('No'))
                                                ],
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          )),
                                    ),
                                  ),
                                ),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                            itemCount: semesterList.length);
                      });
                    }),
              ),
            ),
            Container(
              height: 30,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Created by Ibrahim Nisar',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
        onPressed: () {
          showDialog(
              context: context,
              builder: (ctx) {
                String name = '';

                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: Text('Semester Name'),
                  content: TextField(
                    autofocus: true,
                    decoration: InputDecoration(hintText: 'Name'),
                    onChanged: (val) {
                      name = val;
                    },
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          if (name.trim().isEmpty) {
                            Get.back();
                          } else {
                            Get.back();
                            Get.to(() => AddSemesterScreen(
                                semesterIns: Semester(
                                    gpa: 0.0, name: name, subjects: [])));
                          }
                        },
                        child: Text('Confirm')),
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('Cancel'))
                  ],
                );
              });
        },
      ),
    );
  }
}
