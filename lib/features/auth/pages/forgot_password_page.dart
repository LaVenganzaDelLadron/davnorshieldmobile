import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: () => context.pop())),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Forgot Password flow placeholder'),
        ),
      ),
    );
  }
}
