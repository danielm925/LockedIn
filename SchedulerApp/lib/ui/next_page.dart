import 'package:flutter/material.dart';
import 'theme.dart';
import '../ui/widgets/input_field.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../controllers/task_controller.dart';
import 'package:get/get.dart';

class MySecondPage extends StatefulWidget {
  const MySecondPage({super.key});

  @override
  State<MySecondPage> createState() => _MySecondPageState();
}

class _MySecondPageState extends State<MySecondPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String time = DateFormat("hh:mm a").format(DateTime.now()).toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Event",
                  style: headingStyle,
                ),
                MyInputField(title: "Name", hint: "", controller: _nameController,),
                MyInputField(title: "Description", hint: "", controller: _descriptionController,),
                Row(
                  children: [
                    Expanded(
                      child: MyInputField(title: "Date",
                          hint: DateFormat.yMd().format(_selectedDate),
                          widget: IconButton(
                            icon: const Icon(Icons.calendar_today_outlined),
                            onPressed: (){
                              _getDateFromUser();
                            },
                          )
                      ),
                    ),
                    const SizedBox(width: 12,),
                    Expanded(
                      child: MyInputField(
                        title: "Time",
                        hint: time,
                        widget: IconButton(
                          onPressed: (){
                            _getTimeFromUser(true);
                          },
                          icon: const Icon(
                            Icons.access_alarm,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          )
        ),
    );
  }

  _validateData(){
    if(_nameController.text.isNotEmpty && _descriptionController.text.isNotEmpty){
      _addTaskToDb();
      Navigator.pop(context);
    }else if(_nameController.text.isEmpty || _descriptionController.text.isEmpty){
      _showAlertDialog(context);
    }
  }

  _showAlertDialog(BuildContext context)
  {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: ()
      {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Please enter all fields!"),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context){
        return alert;
      },
    );
  }

  _addTaskToDb() async{
    await _taskController.addTask(
        task:Task(
          name: _nameController.text,
          description: _descriptionController.text,
          date: DateFormat.yMd().format(_selectedDate),
          time: time,
          isCompleted: 0,
        )
    );
  }

  _appBar(){
    return AppBar(
      elevation: 0,
      leading: GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.white),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          iconSize: 27,
          onPressed: () {
            _validateData();
          },
        ),
        const SizedBox(width: 10,),
      ],
    );
  }

  _getDateFromUser() async{
    DateTime? datePicker = await showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2099));

    if(datePicker != null){
      setState(() {
        _selectedDate = datePicker;
      });
    }
    else{
    }
  }

  _getTimeFromUser(bool isStartTime) async{
    var pickedTime = await _showTimePicker();
    String formattedTime = pickedTime.format(context);
    if(pickedTime == null){
    }else if(isStartTime == true){
      setState(() {
        time = formattedTime;
      });
    }
  }

  _showTimePicker(){
    return showTimePicker(context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime: TimeOfDay(
          hour: int.parse(time.split(":")[0]),
          minute: int.parse(time.split(":")[1].split(" ")[0])
        )
    );
  }
}