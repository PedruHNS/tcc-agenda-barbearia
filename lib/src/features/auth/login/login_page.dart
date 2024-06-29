import 'package:barbershop_schedule/src/core/constants/constants.dart';
import 'package:barbershop_schedule/src/core/ui/helpers/messages.dart';
import 'package:barbershop_schedule/src/features/auth/login/login_controller.dart';
// import 'package:barbershop_schedule/src/core/ui/helpers/unfocus__helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  var obscureText = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    obscureText.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginController = Provider.of<LoginController>(context);

    Future<void> login() async {
      await loginController.login(
        _emailEC.text.trim(),
        _passwordEC.text,
      );

      if (context.mounted) {
        if (loginController.userCredential != null) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home', (route) => false);
          Messages.showSuccess('Seja bem vindo!', context);
        } else {
          Messages.showError(loginController.errorMessage!, context);
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Form(
        key: _formKey,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AssetsImage.background2),
                fit: BoxFit.cover,
                opacity: 0.3),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AssetsImage.logoBarbearia),
                          TextFormField(
                            validator: Validatorless.multiple([
                              Validatorless.required('E-mail obrigatório'),
                              Validatorless.email('E-mail inválido')
                            ]),
                            onTapOutside: (_) =>
                                FocusScope.of(context).unfocus(),
                            controller: _emailEC,
                            decoration: const InputDecoration(
                              label: Text('E-mail'),
                              hintText: 'E-mail',
                            ),
                          ),
                          const SizedBox(height: 24),
                          ValueListenableBuilder(
                            valueListenable: obscureText,
                            builder: (_, value, child) {
                              return TextFormField(
                                validator: Validatorless.multiple([
                                  Validatorless.required('Senha obrigatória'),
                                  Validatorless.min(6, 'senha incorreta')
                                ]),
                                onTapOutside: (event) =>
                                    FocusScope.of(context).unfocus(),
                                controller: _passwordEC,
                                obscureText: value,
                                decoration: InputDecoration(
                                  label: const Text('senha'),
                                  hintText: 'senha',
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      obscureText.value = !obscureText.value;
                                    },
                                    icon: Icon(
                                      obscureText.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed('/auth/forgot_password');
                              },
                              child: const Text(
                                'Esqueceu a senha?',
                                style:
                                    TextStyle(color: ColorsConstants.primary),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Consumer<LoginController>(
                            builder: (context, controller, child) {
                              return ElevatedButton(
                                onPressed: () async {
                                  switch (_formKey.currentState?.validate()) {
                                    case true:
                                      await login();

                                    case false || null:
                                      Messages.showError(
                                        'Erro ao realizar login',
                                        context,
                                      );
                                      return;
                                  }
                                },
                                child: controller.loading
                                    ? const CircularProgressIndicator()
                                    : const Text('ACESSAR'),
                              );
                            },
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/auth/register/user');
                          },
                          child: const Text(
                            'Criar conta',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
