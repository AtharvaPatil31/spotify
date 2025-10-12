import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> initSupabase() async {
  await Supabase.initialize(
    url: 'https://dboypqndmexqknddthge.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRib3lwcW5kbWV4cWtuZGR0aGdlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAxODQ2MjEsImV4cCI6MjA3NTc2MDYyMX0.ZGD50odYs25N4Q0TFZXJerKTNvGZ0g7SEtU8I1dFBT0',
  );
}
