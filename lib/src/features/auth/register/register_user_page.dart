import 'package:barbershop_schedule/src/core/ui/helpers/messages.dart';
import 'package:barbershop_schedule/src/core/ui/helpers/unfocus__helper.dart';
import 'package:barbershop_schedule/src/features/auth/register/register_controller.dart';
import 'package:barbershop_schedule/src/models/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class RegisterUserPage extends StatefulWidget {
  const RegisterUserPage({super.key});

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  final _dateFormat = DateFormat('dd/MM/yyyy');
  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _dateEC = TextEditingController();
  final _emailEC = TextEditingController();
  final _phoneEC = TextEditingController();
  final _passwordEC = TextEditingController();

  @override
  void dispose() {
    _nameEC.dispose();
    _emailEC.dispose();
    _passwordEC.dispose();
    _dateEC.dispose();
    _phoneEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registerController = Provider.of<RegisterController>(context);

    Future<void> register() async {
      final client = AuthModel(
        name: _nameEC.text.trim(),
        email: _emailEC.text.trim(),
        phone: _phoneEC.text,
        password: _passwordEC.text,
        dateOfBirth: _dateEC.text,
      );
      await registerController.register(client);

      if (context.mounted) {
        if (registerController.errorMessage != null) {
          Messages.showError(registerController.errorMessage!, context);
        } else {
          Navigator.of(context).pushNamed('/home');
          Messages.showSuccess('Cadastro realizado com sucesso', context);
        }
      }
    }

    Future<void> datePicker() async {
      final date = await showDatePicker(
        context: context,
        locale: const Locale('pt', 'BR'),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
      );

      if (date != null) {
        _dateEC.text = _dateFormat.format(date);
        return;
      }
      _dateEC.clear();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar conta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  controller: _nameEC,
                  validator: Validatorless.required('Nome Obrigatório'),
                  decoration: const InputDecoration(
                    label: Text('Nome'),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  controller: _dateEC,
                  validator:
                      Validatorless.required('Data Obrigatória (DD/MM/AAAA)'),
                  keyboardType: TextInputType.datetime,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    MaskTextInputFormatter(
                      mask: '##/##/####',
                      filter: {
                        "#": RegExp(r'[0-9]'),
                      },
                    )
                  ],
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: datePicker,
                        icon: const Icon(Icons.calendar_today)),
                    label: const Text('Data de Nascimento'),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  controller: _phoneEC,
                  keyboardType: TextInputType.phone,
                  validator: Validatorless.required('celular Obrigatório'),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    MaskTextInputFormatter(
                      mask: '(##) #####-####',
                      filter: {
                        "#": RegExp(r'[0-9]'),
                      },
                    )
                  ],
                  decoration: const InputDecoration(
                    label: Text('celular'),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  controller: _emailEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('E-mail Obrigatório'),
                    Validatorless.email('E-mail inválido'),
                  ]),
                  decoration: const InputDecoration(
                    label: Text('E-mail'),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  controller: _passwordEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('Senha Obrigatória'),
                    Validatorless.min(6, 'Senha muito curta'),
                  ]),
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text('Senha'),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  validator: Validatorless.multiple([
                    Validatorless.required('confirma Senha Obrigatória'),
                    Validatorless.min(6, 'mínimo de 6 caracteres para a senha'),
                    Validatorless.compare(_passwordEC, 'senhas não conferem')
                  ]),
                  onTapOutside: (_) => unfocus(context),
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text('Confirmar senha'),
                  ),
                ),
                const SizedBox(height: 24),
                Consumer<RegisterController>(
                    builder: (context, controller, child) {
                  return ElevatedButton(
                    onPressed: () async {
                      switch (_formKey.currentState?.validate()) {
                        case null || false:
                          Messages.showError('Formulário inválido', context);

                        case true:
                          await register();
                      }
                    },
                    child: controller.loading
                        ? const CircularProgressIndicator()
                        : const Text('Cadastrar'),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
