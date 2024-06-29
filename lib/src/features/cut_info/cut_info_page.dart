import 'package:auto_size_text/auto_size_text.dart';
import 'package:barbershop_schedule/src/core/ui/helpers/messages.dart';
import 'package:barbershop_schedule/src/core/ui/widgets/circle_image_avatar.dart';
import 'package:barbershop_schedule/src/features/cut_info/cut_info_controller.dart';
import 'package:barbershop_schedule/src/features/cut_info/widgets/list_services.dart';

import 'package:barbershop_schedule/src/models/scheduled_services_model.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class CutInfoPage extends StatefulWidget {
  final ScheduledServicesModel scheduledServices;
  const CutInfoPage({super.key, required this.scheduledServices});

  @override
  State<CutInfoPage> createState() => _CutInfoPageState();
}

class _CutInfoPageState extends State<CutInfoPage> {
  @override
  void initState() {
    valorFinal();
    super.initState();
  }

  double _valor = 0.0;

  valorFinal() {
    for (var element in widget.scheduledServices.products) {
      _valor += element.price;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<CutInfoController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Serviço Agendado'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
              child: Column(
            children: [
              CircleImageAvatar(
                size: 60,
                image: widget.scheduledServices.employee.image,
              ),
              const SizedBox(height: 24),
              Text(
                widget.scheduledServices.employee.name,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 24),
              widget.scheduledServices.products.length > 1
                  ? ListServices(services: widget.scheduledServices.products)
                  : InfoRow(
                      name: 'Serviço: ',
                      value: widget.scheduledServices.products.first.name,
                    ),
              const SizedBox(height: 24),
              InfoRow(
                name: 'Data marcada: ',
                value: widget.scheduledServices.date,
              ),
              const SizedBox(height: 24),
              InfoRow(
                name: 'Horário: ',
                value: widget.scheduledServices.hour,
              ),
              const SizedBox(height: 24),
              InfoRow(
                name: 'Valor: ',
                value: 'R\$${_valor.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 24),
              InfoRow(
                name: 'Status: ',
                value: widget.scheduledServices.status,
              ),
              const SizedBox(height: 24),
              Offstage(
                offstage: widget.scheduledServices.status == 'cancelado' ||
                    widget.scheduledServices.status == 'concluido',
                child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Cancelar Agendamento'),
                            content: const Text(
                              'Tem certeza que deseja cancelar o agendamento?',
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Não')),
                              TextButton(
                                onPressed: () {
                                  controller.cancelService(
                                      widget.scheduledServices.id!);

                                  Messages.showSuccess(
                                      'Agendamento Cancelado', context);
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/home', (route) => false);
                                },
                                child: const Text('Sim'),
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Cancelar Agendamento')),
              )
            ],
          )),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String name;
  final String value;
  const InfoRow({
    super.key,
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.displayMedium,
          overflow: TextOverflow.ellipsis,
        ),

        Flexible(
          child: AutoSizeText(
            value,
            style: Theme.of(context).textTheme.displayMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Flexible(
        //   child: Text(
        //     value,
        //     style: Theme.of(context).textTheme.displayMedium,
        //     overflow: TextOverflow.ellipsis,
        //   ),
        // ),
      ],
    );
  }
}
