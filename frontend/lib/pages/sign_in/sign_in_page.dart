import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sign_in_controller.dart';

class SignInPage extends StatelessWidget {
  final SignInController control = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 1),
              Image.asset(
                'assets/images/LogoProveedify.png',
                height: 120,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: control.userController,
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  labelStyle: TextStyle(color: color.onSurface),
                  filled: true,
                  fillColor: color.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() => TextField(
                    controller: control.passwordController,
                    obscureText: control.isPasswordHidden.value,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(color: color.onSurface),
                      filled: true,
                      fillColor: color.surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          control.isPasswordHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: color.primary,
                        ),
                        onPressed: control.togglePasswordVisibility,
                      ),
                    ),
                  )),
              const SizedBox(height: 32),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () => control.login(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'INICIAR SESIÓN',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color.onPrimaryContainer,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
