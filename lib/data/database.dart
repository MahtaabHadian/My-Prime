import 'package:hive/hive.dart';

class ProjData {
  late Box myBox;

  List<Map<String, dynamic>> projects = [];

  ProjData();

  void setBox(Box box) {
    myBox = box;
  }

  void createInitialData() {
    projects = [
      {
        'projectName': 'پروژه نمونه',
        'done': 0,
        'total': 0,
        'randomImage': 'assets/img/bg.png',
        'tasks': [],
      }
    ];
    updateData();
  }

  void loadData() {
    var rawData = myBox.get("projects");
    if (rawData != null) {
      projects = List<Map<String, dynamic>>.from(
        (rawData as List).map(
              (item) => Map<String, dynamic>.from(item),
        ),
      );
    } else {
      projects = [];
    }
  }



  void updateData() {
    myBox.put('projects', projects);
  }

  void addProject(Map<String, dynamic> project) {
    projects.add(project);
    updateData();
  }
}
