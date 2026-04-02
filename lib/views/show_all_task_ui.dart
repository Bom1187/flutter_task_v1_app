import 'package:flutter/material.dart';
import 'package:flutter_task_app/model/task.dart';
import 'package:flutter_task_app/services/supabase_service.dart';
import 'package:flutter_task_app/views/add_task_ui.dart';

class ShowAllTaskUi extends StatefulWidget {
  const ShowAllTaskUi({super.key});

  @override
  State<ShowAllTaskUi> createState() => _ShowAllTaskUiState();
}

class _ShowAllTaskUiState extends State<ShowAllTaskUi> {
  // สร้าง instance/object/ตัวแทน ของ supabaseService
  final service = SupabaseService();

  // สร้างตัวแปรเก็บข้อมูลที่ได้จากการดึงมาจาก supabase
  List<Task> tasks = [];
  void loadTasks() async {
    final data = await service.getTasks();

    setState(() {
      tasks = data;
    });
  }

  @override
  void initState() {
    super.initState();
    // เรียกใช้เมธอดเพื่อดึงข้อมูล ตอนหน้าจอถูกเปิดขึ้นมา
    loadTasks();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // appbar
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Task Na Ja V1',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      // ปุ่มเปิดไปหน้าเพิ่ม task
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskUi(),
            ),
          ).then((value) {
            // เมื่อกลับมาจากหน้า AddTaskUi ให้โหลดข้อมูลใหม่เพื่อแสดงอัปเดตล่าสุด
            loadTasks();
          });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      // ตำแหน่งปุ่มเปิดไปหน้าเพิ่ม task
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // body ที่แสดง logo กับข้อมูลที่ดึงมาจาก supabase
      body: Center(
        child: Column(
          children: [
            // แสดง logo
            SizedBox(
              height: 40,
            ),
            Image.asset(
              'assets/images/logo.png',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 40,
            ),
            // ListView แสดลข้อมูลจาก task_tb จาก supabase
            Expanded(
              child: ListView.builder(
                // จำนวนรายการ
                itemCount: tasks.length,
                // หน้าตาแต่ละรายการ
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      left: 35,
                      right: 35,
                    ),
                    child: ListTile(
                      onTap: () {},
                      leading: tasks[index].task_image_url! != ''
                          ? Image.network(
                              tasks[index].task_image_url!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/logo.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                      title: Text(
                        'งาน ${tasks[index].task_name}',
                      ),
                      subtitle: Text(
                        'สถานะ: ${tasks[index].task_status == true ? 'สําเร็จ' : 'ไม่สําเร็จ'}',
                      ),
                      trailing: Icon(
                        Icons.info,
                        color: Colors.red,
                      ),
                      tileColor:
                          index % 2 == 0 ? Colors.green[50] : Colors.pink[50],
                      contentPadding: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
