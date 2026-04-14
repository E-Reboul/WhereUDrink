import 'package:flutter/material.dart';
import 'package:where_u_drink/features/connection/presentation/widgets/connection/auth_card.dart';

class ConnectionScreen extends StatelessWidget {
  const ConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        
        Positioned.fill(
          child: Image.asset('assets/images/background.jpg', fit: BoxFit.cover),
        ),

        Positioned.fill(
          child: Container(color: Colors.black.withValues(alpha: 0.45)),
        ),

        const AuthCard(),
      ]
    );
  }
}
