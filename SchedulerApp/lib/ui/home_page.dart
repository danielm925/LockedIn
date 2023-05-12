import 'package:flutter/material.dart';
import '../services/notification_services.dart';
import '../services/theme_services.dart';
import '../ui/theme.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:google_fonts/google_fonts.dart';
import 'next_page.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../ui/widgets/task_tile.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());

  @override
  void initState(){
    super.initState();
    Noti.initialize(flutterLocalNotificationsPlugin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(height: 10,),
          _showTasks(),
        ],
      )
    );
  }

  _showTasks(){
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              Task task = _taskController.taskList[index];
              if(task.date==DateFormat.yMd().format(_selectedDate)){
                DateTime date = DateFormat.jm().parse(task.time.toString());
                var myTime = DateFormat("HH:mm").format(date);
                Noti.scheduledNotification(
                  int.parse(myTime.toString().split(":")[0]),
                  int.parse(myTime.toString().split(":")[1]),
                  task,
                  flutterLocalNotificationsPlugin
                );
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap:(){
                                  _showBottomSheet(context, task);
                                },
                                child: TaskTile(task)
                            )
                          ],
                        ),
                      ),
                    ));
              }
              else{
                return Container();
              }
            }
            );
      }),
    );
  }

  _showBottomSheet(BuildContext context, Task task){
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted==1?
        MediaQuery.of(context).size.height*0.24:
        MediaQuery.of(context).size.height*0.32,
        color: darkGreyClr,
        child: Column(
          children: [
            const Spacer(),
            task.isCompleted==1?Container()
                : _bottomSheetButton(label: "Completed",
                onTap:(){
                  _taskController.markTaskCompleted(task.id!);
                  Get.back();
                },
                clr: primaryClr,
                context: context,
            ),
            const SizedBox(height: 20),
            _bottomSheetButton(label: "Delete",
              onTap:(){
                _taskController.delete(task);
                Get.back();
              },
              clr: Colors.red[300]!,
              context: context,
            ),
            task.isCompleted==1?const SizedBox(height: 50):const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  _bottomSheetButton({
    required String label, required Function()? onTap, required Color clr, bool isClose=false, required BuildContext context
  })
  {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical:4),
        height: 55,
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose==true?Colors.red:clr
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose==true?Colors.red:clr,
        ),
        child: Center(
          child: Text(
              label,
              style: isClose?titleStyle:titleStyle.copyWith(color:Colors.white),
          ),
        ),
      ),
    );
  }

  _addDateBar(){
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey
            )
        ),
        onDateChange: (date){Container(
          margin: const EdgeInsets.only(top: 20, left: 20),
          child: DatePicker(
            DateTime.now(),
            height: 100,
            width: 80,
            initialSelectedDate: DateTime.now(),
            selectionColor: primaryClr,
            selectedTextColor: Colors.white,
            dateTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey
              ),
            ),
            dayTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey
              ),
            ),
            monthTextStyle: GoogleFonts.lato(
                textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey
                )
            ),
            onDateChange: (date){
              setState(() {
                _selectedDate = date;
              });
            },
          ),
        );
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  _addTaskBar(){
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Today",
                        style: headingStyle
                    ),
                    Text(DateFormat.yMMMd().format(DateTime.now()),
                      style: subHeadingStyle,
                    ),
                  ],
                )
          ],
        )
    );
  }

  final get = ThemeService();
  _appBar(){
    return AppBar(
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          iconSize: 27,
          onPressed: () async{
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MySecondPage()),
            );
            _taskController.getTasks();
          },
        ),
        const SizedBox(width: 10,),
      ],
    );
  }
}

// Container(
// width: 100,
// height: 50,
// color: Colors.green,
// margin: const EdgeInsets.only(bottom: 10),
// child: Text(
// _taskController.taskList[index].name.toString()
// ),
// );