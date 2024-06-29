import 'package:barbershop_schedule/src/core/ui/helpers/messages.dart';
import 'package:barbershop_schedule/src/core/ui/widgets/circle_image_avatar.dart';
import 'package:barbershop_schedule/src/features/schedule/schedule_controller.dart';
import 'package:barbershop_schedule/src/features/schedule/widgets/hour_panel.dart';

import 'package:barbershop_schedule/src/features/schedule/widgets/schedule_calendar.dart';
import 'package:barbershop_schedule/src/features/schedule/widgets/services_panel.dart';
import 'package:barbershop_schedule/src/models/employee_model.dart';
import 'package:barbershop_schedule/src/models/product.dart';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:validatorless/validatorless.dart';

class SchedulePage extends StatefulWidget {
  final EmployeeModel employee;
  const SchedulePage({super.key, required this.employee});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final _dateFormat = DateFormat('dd/MM/yyyy');

  final _dateEC = TextEditingController();
  final _hourEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _obscureDate = ValueNotifier(false);
  final _obscureHour = ValueNotifier(false);
  final _obscureProduct = ValueNotifier(false);
  final _obscureButton = ValueNotifier(false);
  late ProductModel selectedProduct;

  @override
  void dispose() {
    _dateEC.dispose();
    _hourEC.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final controller = context.read<ScheduleController>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.getproducts();
      await controller.getBarberInfos();
    });

    super.initState();
  }

  List<int> _convertHour(List<String> hourString) {
    return hourString.map((hour) {
      var hourParts = hour.split(':');
      return int.parse(hourParts[0]);
    }).toList();
  }

  Future<void> openWhatsApp(String phone) async {
    String phoneNumber = '+55$phone'
        .replaceAll(' ', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('-', '');

    final Uri url = Uri.parse('https://wa.me/$phoneNumber');

    if (!await launchUrl(url)) {
      if (mounted) {
        Messages.showError('Não foi possível abrir o WhatsApp', context);
      }
    } else {
      await launchUrl(url);
    }
  }

  Future<void> _registerInSchedule() async {
    final EmployeeModel(:id) = widget.employee;
    final controller = context.read<ScheduleController>();

    if (id != null) {
      await controller.markOnTheCalendar(
        date: _dateEC.text,
        hour: _hourEC.text,
        employeeId: id,
        product: selectedProduct,
      );
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ScheduleController>();
    final EmployeeModel(:id, :name, :image, :phone) = widget.employee;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar um horário'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Center(
                child: Column(children: [
              CircleImageAvatar(size: 60, image: image),
              const SizedBox(height: 24),
              Text(
                name,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  await openWhatsApp(phone);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      phone,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      MdiIcons.whatsapp,
                      size: 32,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  TextFormField(
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    controller: _dateEC,
                    readOnly: true,
                    onTap: () {
                      _obscureDate.value = !_obscureDate.value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'clique aqui e seleciona uma data',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: Validatorless.required('Campo obrigatório'),
                  ),
                  ValueListenableBuilder(
                      valueListenable: _obscureDate,
                      builder: (context, value, child) {
                        return Offstage(
                          offstage: !value,
                          child: Column(
                            children: [
                              const SizedBox(height: 24),
                              Consumer<ScheduleController>(
                                builder: (_, value, __) {
                                  if (value.barbershop != null) {
                                    return ScheduleCalendar(
                                      workDays: value.barbershop!.openDays,
                                      cancelPressed: () {
                                        _dateEC.clear();
                                        _obscureDate.value = false;
                                        _obscureHour.value = false;
                                        _obscureProduct.value = false;
                                        _obscureButton.value = false;
                                      },
                                      okPressed: (DateTime date) {
                                        _dateEC.text = _dateFormat.format(date);
                                        _obscureDate.value = false;
                                        if (_dateEC.text.isNotEmpty) {
                                          _obscureHour.value = true;
                                        }
                                        controller.getUnavailableHours(
                                            employeeId: id!,
                                            date: _dateEC.text);
                                      },
                                    );
                                  }
                                  return const CircularProgressIndicator();
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                  const SizedBox(height: 24),
                  ValueListenableBuilder(
                    valueListenable: _obscureHour,
                    builder: (context, value, child) => Offstage(
                      offstage: !value,
                      child: Consumer<ScheduleController>(
                        builder: (_, controller, __) {
                          if (controller.barbershop != null) {
                            final hour =
                                _convertHour(controller.barbershop!.openHours);
                            return HoursPanel(
                              startTime: hour.first,
                              endTime: hour.last,
                              onHourSelected: (hour) {
                                _hourEC.text = '$hour:00';
                                if (_hourEC.text.isNotEmpty) {
                                  _obscureProduct.value = true;
                                }
                              },
                              enabledhours: hour,
                              disabledHours: controller.unavailableHours,
                            );
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ValueListenableBuilder(
                    valueListenable: _obscureProduct,
                    builder: (_, value, child) {
                      return Offstage(
                        offstage: !value,
                        child: Consumer<ScheduleController>(
                          builder: (_, scheduleController, __) {
                            return ServicePanel(
                              services: scheduleController.products,
                              onServicesSelected: (value) {
                                selectedProduct = value;
                                _obscureButton.value = true;
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  ValueListenableBuilder(
                    valueListenable: _obscureButton,
                    builder: (_, value, child) {
                      return Offstage(
                        offstage: !value,
                        child: ElevatedButton(
                          onPressed: () async {
                            switch (_formKey.currentState?.validate()) {
                              case null || false:
                                Messages.showError(
                                    'Formulário inválido', context);
                                break;
                              case true:
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        title: const Text('Confirmação'),
                                        content: const Text(
                                            'Deseja realmente agendar um horário?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('CANCELAR'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              await _registerInSchedule();
                                              if (context.mounted) {
                                                controller.errorMessage != null
                                                    ? Messages.showError(
                                                        controller
                                                            .errorMessage!,
                                                        context)
                                                    : Messages.showSuccess(
                                                        'Agendamento realizado com sucesso',
                                                        context);
                                              }
                                            },
                                            child: const Text('AGENDAR'),
                                          ),
                                        ],
                                      );
                                    });

                                break;
                            }
                          },
                          child: const Text('AGENDAR'),
                        ),
                      );
                    },
                  )
                ],
              ),
            ])),
          ),
        ),
      ),
    );
  }
}
