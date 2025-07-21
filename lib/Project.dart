import 'package:flutter/material.dart';
import 'dart:math';

import 'package:my_prime/add_task.dart';


class ProjectCard extends StatelessWidget {
  final String projectName;
  final int completedTasks;
  final int totalTasks;
  final VoidCallback onAddTask;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final String randomImage;

  ProjectCard({
    super.key,
    required this.projectName,
    required this.completedTasks,
    required this.totalTasks,
    required this.onAddTask,
    required this.onEdit,
    required this.onDelete,
    required this.randomImage,
  });

  final List<String> backgroundImages = [
    "assets/img/bg.png",
    "assets/img/bg2.png",
    "assets/img/bg3.png",
    "assets/img/bg4.png",
  ];



  @override
  Widget build(BuildContext context) {
    double progress = totalTasks == 0 ? 0 : completedTasks / totalTasks;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(randomImage),

          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(20),

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: Colors.white
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    projectName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  color: Colors.black.withOpacity(0.7)
                ),
                child: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') onEdit();
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('ویرایش')),
                    const PopupMenuItem(value: 'delete', child: Text('حذف')),
                  ],
                  icon: const Icon(Icons.more_vert, color: Colors.white,),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          LinearProgressIndicator(
            value: progress,
            color: Colors.deepPurple,
            backgroundColor: Colors.grey[300],
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
          ),

          const SizedBox(height: 6),

          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(30)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '$completedTasks / $totalTasks ',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),


        ],
      ),
    );
  }
}
