import 'package:flutter/material.dart';
import 'package:where_u_drink/feature/component/CustomElevatedButton.dart';
import 'package:where_u_drink/feature/component/CustomGestureDetector.dart';
import 'package:where_u_drink/feature/component/CustomTextField.dart';

class Connection extends StatelessWidget {
  const Connection({super.key});

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

        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [

                  Text(
                    'Connexion',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineMedium,
                  ),

                  const SizedBox(height: 16),

                  CustomTextField(
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(Icons.email),
                    label: 'Email',
                  ),

                  const SizedBox(height: 12),

                  CustomTextField(
                    obscureText: true,
                    prefixIcon: Icon(Icons.lock),
                    label: 'Mot de passe',
                  ),

                  const SizedBox(height: 12),

                  _forgetPassword(),

                  const SizedBox(height: 4),

                  CustomElevatedButton(text: 'Se connecter', onPressed: () {}),

                  const SizedBox(height: 16),

                  _orDivider(),

                  _otherConnections(),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget _forgetPassword() =>
    Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () {},
        child: const Text('Mot de passe oublié ?'),
      ),
    );

Widget _orDivider() =>
    Row(
      children: const [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('ou'),
        ),
        Expanded(child: Divider()),
      ],
    );

Widget _otherConnections() =>
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomGestureDetector(
          onTap: () {},
          radius: 22,
          backgroundColor: Colors.white,
          icon: Icons.g_mobiledata,
          iconColor: Colors.red,
        ),

        const SizedBox(width: 16),

        CustomGestureDetector(
          onTap: () {},
          radius: 22,
          backgroundColor: Colors.white,
          icon: Icons.apple,
          iconColor: Colors.black,
        ),
      ],
    );
