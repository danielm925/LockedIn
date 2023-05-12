import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/task.dart';
import '../theme.dart';

class TaskTile extends StatelessWidget {
  final Task? task;
  const TaskTile(this.task);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        //  width: SizeConfig.screenWidth * 0.78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getBGClr(0),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 0),
                    Text(
                      "${task!.time}",
                      style: GoogleFonts.lato(
                        textStyle:
                        const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  task?.name??"",
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16,),
                Text(
                  task?.description??"",
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            width: 0.5,
            color: Colors.grey[200]!.withOpacity(0),
          ),
          RotatedBox(
            quarterTurns: 0,
            child: Icon(task!.isCompleted == 1 ? Icons.check_box_outlined : Icons.check_box_outline_blank,
              size: 30,
              color: Colors.white),
          ),
        ]),
      ),
    );
  }

  _getBGClr(int no) {
    switch (no) {
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return yellowClr;
      default:
        return bluishClr;
    }
  }
}