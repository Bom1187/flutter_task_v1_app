import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_task_app/model/task.dart';
import 'package:flutter_task_app/services/supabase_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UpdateDeleteTaskUi extends StatefulWidget {
  // สร้างตัวแปรเพื่อรับข้อมูลของรายกรายการทที่ถูกกดจากหน้า ShowAllTaskUi
  Task? task;

  // เอาตัวแปรที่สร้างมารับค่าที่ส่งมาจากหน้า ShowAllTaskUi
  UpdateDeleteTaskUi({super.key, this.task});

  @override
  State<UpdateDeleteTaskUi> createState() => _UpdateDeleteTaskUiState();
}

class _UpdateDeleteTaskUiState extends State<UpdateDeleteTaskUi> {
  // สร้างตัวควบคุม textfield และตัวแปรที่ต้องเก็บข้อมูลตอนป้อนหรือเลือก เพื่อบันทึกไว้ใน task_tb
  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskWhereController = TextEditingController();
  TextEditingController taskPersonController = TextEditingController();
  bool taskStatus = false;
  TextEditingController taskDuedateController = TextEditingController();
  String? taskImageUrl =
      ""; // กำหนดให้ว่างคือ single quote/double quote 2 อันติดกัน

  // ตัวแปรเก็บไฟล์ที่ใช้อัพโหลด
  File? file;

  // เปิดกล้องถ่ายภาพ
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);

    if (picked != null) {
      setState(() {
        file = File(picked.path);
      });
    }
  }

  // เปิดปฏิทินเลือกวันที่ และกำหนดวันที่
  DateTime? selectedDate;

  // เปิดปฏิทิน
  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    // เอาค่าวันที่เลือกจากปกิทินไปกำหนดให้กับ taskDuedatecontroller
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        taskDuedateController.text =
            DateFormat('yyyy-MM-dd').format(selectedDate!);
      });
    }
  }

  // เมธอดอัปโหลดไฟล์และบันทึกแแก้ไขข้อมูลจากกดปุ่มบันทึกแก้ไข
  Future<void> update() async {
    // varidate ว่าผู้ใช้กรอกข้อมูลต่างๆครบมั้ย ถ้ายังขึ้นแจ้งเตือน
    if (taskNameController.text.isEmpty ||
        taskWhereController.text.isEmpty ||
        taskPersonController.text.isEmpty ||
        taskDuedateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('กรุณากรอกข้อมูลให้ครบ'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // สร้าง instance/object/ตัวแทนของ supabease service เพื่อใช้งานเมธอดต่างๆ ที่สร้างไว้ใน SupabaseService
    final service = SupabaseService();

    // ตรวจสอบว่ามีการถ่าย/เลือกรูปมั้ย ถ้ามีก็อัปโหลดไฟล์ไปยัง tasl_bk
    // แล้วเอา URL ของไฟล์ที่อัปโหลดเก็บในตัวแปรเพื่อใช้บันทึกใน task_tb
    if (file != null) {
      // ต้องตรวจสอบก่อนว่าเดิมทีแบ้วมีรูปอยู่หรือไม่ ถ้ามีให้ลบออกจาก storage ก่อน
      if (widget.task!.task_image_url != null) {
        // หากพิสูจน์เป็นจริงว่ามีรูปเดิมอยู่ให้ลบทิ้ง
        await service.deleteFile(widget.task!.task_image_url!);
      }

      // หาก file ไม่เท่ากับ null แปลว่าได้มีการถ่ายภาพ/เลือกรูป
      // อัปโหลดไฟล์ไปยัง task_bk
      taskImageUrl = await service.uploadFile(file!);
    }

    // บันทึกข้อมูลง task_tb
    // แพ็กข้อมูล
    final task = Task(
      task_name: taskNameController.text,
      task_where: taskWhereController.text,
      task_person: int.parse(taskPersonController.text),
      task_status: taskStatus,
      task_duedate: taskDuedateController.text,
      task_image_url: taskImageUrl,
    );

    // เรียกใช้เมธอด insetTask ใน SupabaseService เพื่อบันทึกข้อมูลลงไปใน supabase
    await service.updateTask(widget.task!.id!, task);

    // แจ้งผลการทำงาน (แสดงเป็น snackbar หรือ alertdialog)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('บันทึกข้อมูลแก้ไขสำเร็จ'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // เมธอดลบข้อมูล
  Future<void> delete() async {
    // แสดง pop up ถามผู้ใช้ก่อนเพื่อยืนยันการลบข้อมูล
    await showDialog<void>(
        context: context,
        barrierDismissible: false, //เป็นการ disable การใช้งานปุ่ม < ใน android
        builder: (context) => AlertDialog(
              // หน้าตาของ pop up
              title: Text('ยืนยันการลบข้อมูล'),
              content: Text('คุณต้องการลบข้อมูลหรือไม่?'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('ยกเลิก'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // ลบรูปออกจาก storage กรณีมีรูป
                    // สร้าง instance/object/ตัวแทนของ supabease service เพื่อใช้งานเมธอดต่างๆ ที่สร้างไว้ใน SupabaseService
                    final service = SupabaseService();

                    // ลบรูปออกจาก supabase ถ้ามีรูป
                    if (widget.task!.task_image_url != '') {
                      // หากพิสูจน์เป็นจริงว่ามีรูปเดิมอยู่ให้ลบทิ้ง
                      await service.deleteFile(widget.task!.task_image_url!);
                    }

                    // ลบข้อมูลออกจาก database
                    await service.deleteTask(widget.task!.id!);

                    // แสดงข้อความแจ้งผลการทำงาน
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('ลบข้อมูลสำเร็จ'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );

                    // ปิด dialog
                    Navigator.pop(context);
                  },
                  child: Text('ตกลง'),
                ),
              ],
            ));
  }

  @override
  void initState() {
    super.initState();
    taskNameController.text = widget.task!.task_name!;
    taskWhereController.text = widget.task!.task_where!;
    taskPersonController.text = widget.task!.task_person!.toString();
    taskStatus = widget.task!.task_status!;
    taskDuedateController.text = widget.task!.task_duedate!;
    taskImageUrl = widget.task!.task_image_url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Task Na Ja V1 (Update Delete)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 30,
            left: 45,
            right: 45,
            bottom: 50,
          ),
          child: Center(
            child: Column(
              children: [
                // ส่วนแสดงรูปและรูปกล้องเพื่อเปิดกล้อง
                // file == null เดิมจากหน้า add task
                file != null
                    ? InkWell(
                        onTap: () {
                          pickImage();
                        },
                        child: Image.file(
                          file!,
                          width: 150,
                          height: 150,
                        ),
                      )
                    : taskImageUrl == ''
                        ? InkWell(
                            onTap: () {
                              pickImage();
                            },
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 150,
                              height: 150,
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              pickImage();
                            },
                            child: Image.network(
                              taskImageUrl!,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ทำอะไร',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                // ป้อนทำอะไร
                TextField(
                  controller: taskNameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      hintText: 'เช่น ซักผ้า, ซ่อมหลอดไฟ'),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ทำที่ไหน',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                // ป้อนทำที่ไหน
                TextField(
                  controller: taskWhereController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      hintText: 'เช่น บ้าน, ที่ทำงาน'),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ทำกี่คน',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                // ป้อนทำกี่คน
                TextField(
                  controller: taskPersonController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      hintText: 'เช่น 2, 5'),
                ),
                SizedBox(height: 20),
                // เลือกทำเสร็จรึยัง
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ทำเสร็จรึยัง',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          taskStatus = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            taskStatus == true ? Colors.green : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        fixedSize: Size(
                          MediaQuery.of(context).size.width * 0.35,
                          50,
                        ),
                      ),
                      child: Text(
                        'เสร็จแล้ว',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          taskStatus = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            taskStatus == false ? Colors.green : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        fixedSize: Size(
                          MediaQuery.of(context).size.width * 0.35,
                          50,
                        ),
                      ),
                      child: Text(
                        'ยังไม่เสร็จ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // เลือกทำเสร็จเมื่อไหร่
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'เสร็จเมื่อไหร่',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TextField(
                  controller: taskDuedateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: 'เช่น 2025-01-01',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () {
                    pickDate();
                  },
                ),
                SizedBox(height: 20),
                // ปุ่มบันทึก
                ElevatedButton(
                  onPressed: () {
                    update();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      50,
                    ),
                  ),
                  child: Text(
                    'บันทึกแก้ไข',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // ปุ่มยกเลิก
                ElevatedButton(
                  onPressed: () {
                    // ลบข้อมูล
                    delete().then((value) {
                      // กลับไปหน้าหลัก
                      Navigator.pop(context);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      50,
                    ),
                  ),
                  child: Text(
                    'ลบ',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
