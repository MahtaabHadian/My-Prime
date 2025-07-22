import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'colors.dart';
import 'Task.dart';
import 'add_task.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final String projectName;
  final String projectImage;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProjectDetailsScreen({
    super.key,
    required this.projectName,
    required this.projectImage,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  List<Task> tasks = [];
  Task? lastAddedTask;
  late Box<Task> taskBox;

  int get completedTasks => tasks.where((task) => task.isDone).length;
  int get totalTasks => tasks.length;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    try {
      taskBox = await Hive.openBox<Task>('tasks_box');
      print('ProjectDetails: Hive box opened: tasks_box');
      await _loadTasks();
    } catch (e) {
      print('ProjectDetails: Error opening Hive box: $e');
    }
  }

  Future<void> _loadTasks() async {
    try {
      setState(() {
        tasks = taskBox.values.where((task) => task.projectName == widget.projectName).toList();
        print('ProjectDetails: Loaded tasks for ${widget.projectName}: ${tasks.length}');
      });
    } catch (e) {
      print('ProjectDetails: Error loading tasks: $e');
    }
  }

  Future<void> _addTask(Task task) async {
    try {
      await taskBox.add(task);
      print('ProjectDetails: Task added to Hive: ${task.title}, key: ${task.key}');
      setState(() {
        tasks = taskBox.values.where((task) => task.projectName == widget.projectName).toList();
        lastAddedTask = task;
        print('ProjectDetails: Updated tasks list: ${tasks.length}');
      });
    } catch (e) {
      print('ProjectDetails: Error adding task to Hive: $e');
    }
  }

  Future<void> _toggleTaskDone(Task task) async {
    try {
      print('ProjectDetails: Attempting to toggle task: ${task.title}, current isDone: ${task.isDone}, key: ${task.key}');
      if (task.key == null) {
        print('ProjectDetails: Task key is null, cannot toggle');
        return;
      }
      task.isDone = !task.isDone;
      await taskBox.put(task.key, task);
      print('ProjectDetails: Task updated in Hive: ${task.title}, new isDone: ${task.isDone}');
      setState(() {
        tasks = taskBox.values.where((task) => task.projectName == widget.projectName).toList();
        print('ProjectDetails: Updated tasks list after toggle: ${tasks.length}');
      });
    } catch (e) {
      print('ProjectDetails: Error toggling task: $e');
    }
  }

  Future<void> _deleteTask(Task task) async {
    try {
      if (task.key == null) {
        print('ProjectDetails: Task key is null, cannot delete');
        return;
      }
      await taskBox.delete(task.key);
      print('ProjectDetails: Task deleted from Hive: ${task.title}');
      setState(() {
        tasks = taskBox.values.where((task) => task.projectName == widget.projectName).toList();
        print('ProjectDetails: Updated tasks list after delete: ${tasks.length}');
      });
    } catch (e) {
      print('ProjectDetails: Error deleting task: $e');
    }
  }

  Color _getPriorityColor(int index) {
    switch (index) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getButtonColor(String imageName) {
    if (imageName == "assets/img/bg.png") return Colors.pinkAccent;
    if (imageName == "assets/img/bg2.png") return const Color(0xffddb977);
    if (imageName == "assets/img/bg3.png") return Colors.orangeAccent;
    if (imageName == "assets/img/bg4.png") return Colors.deepPurple;
    return Primary;
  }

  @override
  Widget build(BuildContext context) {
    double progress = totalTasks == 0 ? 0 : completedTasks / totalTasks;
    List<Task> sortedTasks = [
      ...tasks.where((t) => !t.isDone),
      ...tasks.where((t) => t.isDone),
    ];

    return Scaffold(
      backgroundColor: BgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.black.withOpacity(0.7),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () {
              print('ProjectDetails: Back button pressed');
              Navigator.pop(context);
            },
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                image: DecorationImage(
                  image: AssetImage(widget.projectImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Text(
                          widget.projectName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LinearProgressIndicator(
                value: progress,
                color: _getButtonColor(widget.projectImage),
                backgroundColor: Colors.grey[300],
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '$completedTasks از $totalTasks تسک انجام شده',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 15),
            if (tasks.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'هنوز هیچ تسکی اضافه نشده!',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sortedTasks.length,
                itemBuilder: (context, index) {
                  final task = sortedTasks[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Dismissible(
                        key: ValueKey('${task.title}_${task.key}'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 15),
                          color: Colors.redAccent,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => _deleteTask(task),
                        child: CheckboxListTile(
                          checkColor: Colors.white,
                          activeColor: _getButtonColor(widget.projectImage),
                          value: task.isDone,
                          onChanged: (value) {
                            print('ProjectDetails: Checkbox tapped for task: ${task.title}');
                            _toggleTaskDone(task);
                          },
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  task.title,
                                  style: TextStyle(
                                    color: task.isDone ? Colors.grey : Colors.black,
                                    decoration: task.isDone ? TextDecoration.lineThrough : null,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: task.isDone
                                      ? Colors.grey
                                      : _getPriorityColor(task.priority).withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    task.date,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          secondary: CircleAvatar(
                            backgroundColor: _getPriorityColor(task.priority),
                            radius: 6,
                          ),
                        ),
                      ),
                      if (task == lastAddedTask)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/img/arrow.png",
                                  height: 60,
                                  width: 200,
                                ),
                                const Text(
                                  'برای حذف کردن تسک رو به سمت راست بکش',
                                  style: TextStyle(
                                    color: Color(0xffdabd7c),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: _getButtonColor(widget.projectImage).withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 1,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: FloatingActionButton(
            elevation: 0,
            backgroundColor: _getButtonColor(widget.projectImage),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onPressed: () async {
              print('ProjectDetails: Opening AddTask screen');
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddTask(projectName: widget.projectName),
                ),
              );
              if (result != null && result is Map<String, dynamic>) {
                print('ProjectDetails: Received task: $result');
                final newTask = Task.fromMap(result);
                await _addTask(newTask);
              } else {
                print('ProjectDetails: No task received or invalid data');
              }
            },
            child: const Icon(Icons.add, size: 30, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    print('ProjectDetails: Closing Hive box');
    taskBox.close();
    super.dispose();
  }
}