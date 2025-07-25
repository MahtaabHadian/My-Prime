import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_prime/data/database.dart';
import 'package:my_prime/project_deatils.dart';
import 'package:my_prime/models/Project.dart';
import 'package:my_prime/models/Task.dart';
import 'base/colors.dart';
import 'guide_screen.dart';

class HomePage extends StatefulWidget {
  final String name;
  final String selectedImage;
  final Box myBox;
  const HomePage({super.key, required this.name, required this.selectedImage, required this.myBox});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box _myBox;
  ProjData pdb = ProjData();
  bool isLoading = true;
  late Box<Task> taskBox;

  final List<String> backgroundImages = [
    "assets/img/bg.png",
    "assets/img/bg2.png",
    "assets/img/bg3.png",
    "assets/img/bg4.png",
  ];

  @override
  void initState() {
    Future<void> migrateTasks() async {
      final taskBox = Hive.box<Task>('tasks_box');
      for (var project in pdb.projects) {
        final tasks = project['tasks'] as List? ?? [];
        for (var task in tasks) {
          await taskBox.add(Task(
            title: task['taskName'],
            projectName: project['projectName'],
            isDone: task['isDone'],
            date: 'Unknown',
            priority: 2,
          ));
        }
        project['tasks'] = [];
      }
      pdb.updateData();
    }
    super.initState();
    _myBox = widget.myBox;
    pdb.setBox(_myBox);

    if (_myBox.get("projects") == null) {
      pdb.createInitialData();
    } else {
      pdb.loadData();
    }

    _initHive();
  }

  Future<void> _initHive() async {
    try {
      taskBox = Hive.box<Task>('tasks_box');
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showAddProjectDialog(BuildContext context) {
    final TextEditingController _projectNameController = TextEditingController();
    final random = Random();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: BgColor,
          title: Center(
            child: Text(
              'افزودن پروژه جدید',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Primary,
                fontSize: 22,
              ),
            ),
          ),
          content: TextField(
            controller: _projectNameController,
            decoration: InputDecoration(
              hintText: 'نام پروژه',
              filled: true,
              fillColor: TextFieldColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
            maxLength: 25,
            inputFormatters: [
              LengthLimitingTextInputFormatter(30),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('لغو', style: TextStyle(color: Colors.grey[700])),
                ),
                ElevatedButton(
                  onPressed: () {
                    String projectName = _projectNameController.text.trim();
                    if (projectName.isNotEmpty) {
                      final randomImage = backgroundImages[random.nextInt(backgroundImages.length)];
                      setState(() {
                        pdb.addProject({
                          'projectName': projectName,
                          'randomImage': randomImage,
                        });
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text('افزودن', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: BgColor,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(14),
        child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80),
            boxShadow: [
              BoxShadow(
                color: Primary.withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 2,
                offset: Offset(0, 20),
              ),
            ],
          ),
          child: FloatingActionButton(
            elevation: 0,
            backgroundColor: Primary,
            child: Icon(Icons.add, size: 37, color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onPressed: () {
              showAddProjectDialog(context);
            },
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ValueListenableBuilder(
        valueListenable: taskBox.listenable(),
        builder: (context, Box<Task> box, _) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(300),
                                child: Image.asset(widget.selectedImage),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.name,
                                  style: TextStyle(
                                    color: Primary,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 19,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Secend,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child: Text(
                                      "نسخه رایگان",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const GuideScreen()),
                            );
                          },

                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Primary, width: 2),
                            ),
                            child: Icon(Icons.question_mark_rounded, size: 33, color: Primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    pdb.projects.isEmpty
                        ? Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Column(
                        children: [
                          Image.asset("assets/img/homepage.png"),
                          const SizedBox(height: 15),
                          Text(
                            "هنوز پروژه ای ثبت نکردی!",
                            style: TextStyle(
                              color: Primary,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: pdb.projects.length,
                      itemBuilder: (context, index) {
                        final project = pdb.projects[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProjectDetailsScreen(
                                  projectName: project['projectName'],
                                  projectImage: project['randomImage'],
                                  onEdit: () {
                                    TextEditingController editController =
                                    TextEditingController(text: project['projectName']);
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: BgColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          title: Text(
                                            'ویرایش نام پروژه',
                                            style: TextStyle(color: Primary),
                                          ),
                                          content: TextField(
                                            controller: editController,
                                            decoration: InputDecoration(
                                              hintText: 'نام جدید پروژه',
                                              filled: true,
                                              fillColor: TextFieldColor,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(15),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text(
                                                'لغو',
                                                style: TextStyle(color: Colors.grey[600]),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  pdb.projects[index]['projectName'] =
                                                      editController.text.trim();
                                                  pdb.updateData();
                                                });
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Primary,
                                              ),
                                              child: const Text(
                                                'ذخیره',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  onDelete: () {
                                    setState(() {
                                      final tasks = taskBox.values
                                          .where((task) => task.projectName == project['projectName'])
                                          .toList();
                                      for (var task in tasks) {
                                        taskBox.delete(task.key);
                                      }
                                      pdb.projects.removeAt(index);
                                      pdb.updateData();
                                    });
                                  },
                                ),
                              ),
                            ),
                            child: ProjectCard(
                              projectName: project['projectName'],
                              randomImage: project['randomImage'],
                              onAddTask: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProjectDetailsScreen(
                                      projectName: project['projectName'],
                                      projectImage: project['randomImage'],
                                      onEdit: () {},
                                      onDelete: () {},
                                    ),
                                  ),
                                );
                              },
                              onEdit: () {
                                TextEditingController editController =
                                TextEditingController(text: project['projectName']);
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: BgColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      title: Text(
                                        'ویرایش نام پروژه',
                                        style: TextStyle(color: Primary),
                                      ),
                                      content: TextField(
                                        controller: editController,
                                        decoration: InputDecoration(
                                          hintText: 'نام جدید پروژه',
                                          filled: true,
                                          fillColor: TextFieldColor,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text(
                                            'لغو',
                                            style: TextStyle(color: Colors.grey[600]),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              pdb.projects[index]['projectName'] =
                                                  editController.text.trim();
                                              pdb.updateData();
                                            });
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Primary,
                                          ),
                                          child: const Text(
                                            'ذخیره',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              onDelete: () {
                                setState(() {
                                  final tasks = taskBox.values
                                      .where((task) => task.projectName == project['projectName'])
                                      .toList();
                                  for (var task in tasks) {
                                    taskBox.delete(task.key);
                                  }
                                  pdb.projects.removeAt(index);
                                  pdb.updateData();
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {

    super.dispose();
  }
}