import 'package:flutter/material.dart';
import 'package:where_u_drink/feature/connection/ui/screen/connection.dart';

void main() {
  runApp(const MainInstance());
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
        home: Scaffold(
          body: Stack(
              children: [
                SafeArea(
                    child: Connection()
                )
              ]
          ),
        )
    );
  }
}
