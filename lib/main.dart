import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:where_u_drink/features/connection/presentation/screens/connection_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MainInstance()));
}

class MainInstance extends StatelessWidget {
  const MainInstance({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhereUDrink',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black54),
      ),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: SafeArea(
          child: ConnectionScreen(),
        )
      ),
    );
  }
}
