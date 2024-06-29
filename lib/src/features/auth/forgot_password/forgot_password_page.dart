import 'package:barbershop_schedule/src/core/constants/constants.dart';
import 'package:barbershop_schedule/src/core/ui/helpers/messages.dart';
import 'package:barbershop_schedule/src/features/auth/forgot_password/forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forgotPasswordController =
        Provider.of<ForgotPasswordController>(context);

    Future<void> resetPassword() async {
      if (_formKey.currentState?.validate() == null) return;
      await forgotPasswordController.forgotPassword(_emailEC.text);

      if (context.mounted) {
        if (forgotPasswordController.errorMessage == null) {
          Messages.showInfo(
              'verifique a caixa de entrada ou spam do E-MAIL solicitado',
              context);
          Navigator.of(context).pushReplacementNamed('/auth/login');
          return;
        }
        Messages.showError(forgotPasswordController.errorMessage!, context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Esqueci a senha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AssetsImage.esquceuSenha, fit: BoxFit.cover),
                Text(
                  "Digite um E-MAIL válido para recuperar sua senha!",
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(color: ColorsConstants.primary),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailEC,
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  validator: Validatorless.multiple([
                    Validatorless.required('E-mail Obrigatório'),
                    Validatorless.email('E-mail inválido'),
                  ]),
                  decoration: const InputDecoration(
                    label: Text('E-mail'),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: resetPassword,
                  child: const Text('ENVIAR'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
