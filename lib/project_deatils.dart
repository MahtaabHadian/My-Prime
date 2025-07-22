import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_prime/colors.dart';
import 'Task.dart';
import 'add_task.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final String projectName;
  final String projectImage;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  late Box<Task> taskBox;


  ProjectDetailsScreen({
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

  int get completedTasks =>
      tasks
          .where((task) => task.isDone)
          .length;

  int get totalTasks => tasks.length;


  void _addTask(Task task) async {
    final box = await Hive.openBox<Task>('tasks_${widget.projectName}');
    await box.add(task);
    setState(() {
      tasks.add(task);
      lastAddedTask = task;
    });
  }


  void _toggleTaskDone(Task task) async {
    final index = tasks.indexOf(task);
    if (index != -1) {
      final box = await Hive.openBox<Task>('tasks_${widget.projectName}');
      task.isDone = !task.isDone;
      await box.putAt(index, task);
      setState(() {});
    }
  }


  void _deleteTask(Task task) async {
    final box = await Hive.openBox<Task>('tasks_${widget.projectName}');
    final index = tasks.indexOf(task);
    if (index != -1) {
      await box.deleteAt(index);
      setState(() {
        tasks.removeAt(index);
      });
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
    if (imageName == "assets/img/bg2.png") return Color(0xffddb977);
    if (imageName == "assets/img/bg3.png") return Colors.orangeAccent;
    if (imageName == "assets/img/bg4.png") return Colors.deepPurple;
    return Primary;
  }

  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    final box = await Hive.openBox<Task>('tasks_${widget.projectName}');
    setState(() {
      tasks = box.values.toList();
    });
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
            borderRadius: BorderRadius.circular(90),
            color: Colors.black.withOpacity(0.7),
          ),
          child: IconButton(
            icon: const Icon(
                Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),


      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                image: DecorationImage(
                  image: AssetImage(widget.projectImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 3, vertical: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Text(
                          widget.projectName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: LinearProgressIndicator(
                value: progress,
                color: _getButtonColor(widget.projectImage),
                backgroundColor: Colors.grey[400],
                minHeight: 10,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                '$completedTasks از $totalTasks تسک انجام شده',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (tasks.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Text(
                  'هنوز هیچ تسکی اضافه نشده!',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: sortedTasks.length,
                itemBuilder: (context, index) {
                  final task = sortedTasks[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Dismissible(
                        key: ValueKey(task.title + index.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                          color: Colors.redAccent,
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => _deleteTask(task),
                        child: CheckboxListTile(
                          checkColor: Colors.white,
                          activeColor: _getButtonColor(widget.projectImage),
                          value: task.isDone,
                          onChanged: (_) => _toggleTaskDone(task),
                          title: Row(
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                    color: task.isDone ? Colors.grey : Colors
                                        .black,
                                    decoration: task.isDone ? TextDecoration
                                        .lineThrough : null,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: task.isDone
                                        ? Colors.grey
                                        : _getPriorityColor(task.priority)
                                        .withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Text(task.date, style: TextStyle(
                                      fontSize: 15
                                  ),),
                                ),
                              )
                            ],
                          ),
                          secondary: CircleAvatar(
                            backgroundColor: _getPriorityColor(task.priority),
                            radius: 8,
                          ),
                        ),
                      ),
                      if (task == lastAddedTask)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Center(
                            child: Column(

                              children: [
                                Image.asset("assets/img/arrow.png", height: 80,
                                  width: 220,),
                                Text(
                                  'برای حذف کردن تسک رو به سمت راست بکش',
                                  style: TextStyle(color: Color(0xffdabd7c),
                                      fontWeight: FontWeight.w700),
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
        padding: const EdgeInsets.all(14),
        child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80),
            boxShadow: [
              BoxShadow(
                color: _getButtonColor(widget.projectImage).withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 2,
                offset: Offset(0, 20),
              ),
            ],
          ),
          child: FloatingActionButton(
            elevation: 0,
            backgroundColor: _getButtonColor(widget.projectImage),
            child: Icon(Icons.add, size: 37, color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddTask()),
              );
              if (result != null && result is Map<String, dynamic>) {
                final newTask = Task.fromMap(result);
                _addTask(newTask);
              }
            },
          ),
        ),
      ),
    );
  }

}