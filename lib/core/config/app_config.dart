import 'package:flutter_dotenv/flutter_dotenv.dart';

class Appconfig {
  static final String mode = dotenv.env["MODE"] ?? "dev";
  static final String supabaseUrl = dotenv.env["SUPABASE_URL"] ?? "";
  static final String supabaseKey = dotenv.env["SUPABASE_KEY"] ?? "";
}