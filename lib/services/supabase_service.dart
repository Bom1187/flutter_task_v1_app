// ไฟลนี้ใช้สำหรับสร้างการทำงานต่างๆกับ supabase

// CRUD กับ Table->Database(PostgreSQL)->Supabase
// ipload/delete file กับ Bucket->Storage->Supabase

import 'package:flutter_task_app/model/task.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // สร้าง instance/object/ตัวแทน ของ supabase
  final supabase = Supabase.instance.client;

  // สร้างคำสั่ง/เมธอดการทำงานต่างๆกับ supabase 
  // เมธอดดึงข้ิมูลงานทั้งหมดจาก task_tb และ return ค่าที่ได้จากการดึงไปใช้งาน
  Future<List<Task>> getTasks() async{
    // ดึงข้อมูลงานทั้งหมดจาก task_tb 
    final data = await supabase.from('task_tb').select('*');

    // return ค่าข้อมูลที่ได้จากการดึงไปใช้งาน
    return data.map((task) => Task.fromJson(task)).toList();
  }

  // เมธอดอัปโหลดไฟล์ไปยัง task_bk 

  // เมธอดลบไฟล์ที่อัปโหลดไปยัง task_bk

  // เมธอดอัปโหลดรูปไปยัง task_tb

  // เมธอดแก้ไขข้อมูลใน task_tb

  // เมธอดลบข้อมูลใน task_tb
}