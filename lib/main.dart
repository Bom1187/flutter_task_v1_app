import 'package:flutter/material.dart';
import 'package:flutter_task_app/views/splash_screen_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // ตั้งค่าการทำงาน supabase ที่จะทำงานด้วย
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hujdvvkbfrjtefqjjnba.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh1amR2dmtiZnJqdGVmcWpqbmJhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM5MDI1MDIsImV4cCI6MjA4OTQ3ODUwMn0.HUbUBQqsB_2TaWDFLvolZrLMwlGyglLDwOjcnfAAHuk',
  );
  // ----------------------------------
  runApp(FlutterTaskV1App());

}

class FlutterTaskV1App extends StatefulWidget {
  const FlutterTaskV1App({super.key});

  @override
  State<FlutterTaskV1App> createState() => _FlutterTaskV1AppState();
}

class _FlutterTaskV1AppState extends State<FlutterTaskV1App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenUi(),
      theme: ThemeData(
        textTheme: GoogleFonts.promptTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
    );
  }
}
