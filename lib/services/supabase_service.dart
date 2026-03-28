// ไฟลนี้ใช้สำหรับสร้างการทำงานต่างๆกับ supabase

// CRUD กับ Table->Database(PostgreSQL)->Supabase
// ipload/delete file กับ Bucket->Storage->Supabase

import 'dart:io';

import 'package:flutter_task_app/model/task.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // สร้าง instance/object/ตัวแทน ของ supabase
  final supabase = Supabase.instance.client;

  // สร้างคำสั่ง/เมธอดการทำงานต่างๆกับ supabase
  // เมธอดดึงข้ิมูลงานทั้งหมดจาก task_tb และ return ค่าที่ได้จากการดึงไปใช้งาน
  Future<List<Task>> getTasks() async {
    // ดึงข้อมูลงานทั้งหมดจาก task_tb
    final data = await supabase.from('task_tb').select('*');

    // return ค่าข้อมูลที่ได้จากการดึงไปใช้งาน
    return data.map((task) => Task.fromJson(task)).toList();
  }

  // เมธอดอัปโหลดไฟล์ไปยัง task_bk และ return ที่อยู่รูปภาพที่ได้จาการอัปโหลดไปใช้งาน
  Future<String?> uploadFile(File file) async {
    // สร้างชื่อไฟล์ใหม่ให้ไฟล์เพื่อไม่ให้ซ้ำกัน
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}-${file.path.split('/').last}';

    // อัพโหลดไปยัง task_bk
    await supabase.storage.from('task_bk').upload(fileName, file);

    // return ที่อยู่รูปภาพที่ได้จาการอัปโหลดไปใช้งาน
    return supabase.storage.from('task_bk').getPublicUrl(fileName);
  }

  // เมธอดเพื่มข้อมูลไปยัง task_tb
  Future insetTask(Task task) async {
    // เพิ่มไปยัง task_tb
    await supabase.from('task_tb').insert(task.toJson());
  }

  // เมธอดลบไฟล์ที่อัปโหลดไปยัง task_bk

  // เมธอดแก้ไขข้อมูลใน task_tb

  // เมธอดลบข้อมูลใน task_tb
}
