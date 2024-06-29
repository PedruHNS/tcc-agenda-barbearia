import 'package:barbershop_schedule/src/core/ui/widgets/circle_image_avatar.dart';

import 'package:barbershop_schedule/src/models/scheduled_services_model.dart';
import 'package:flutter/material.dart';

class ScheduledServicesCard extends StatelessWidget {
  final ScheduledServicesModel scheduledServices;
  const ScheduledServicesCard({super.key, required this.scheduledServices});

  Color get _color {
    switch (scheduledServices.status) {
      case 'agendado':
        return Colors.green;
      case 'cancelado':
        return Colors.red;
      case 'concluido':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/info', arguments: scheduledServices);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        elevation: 12,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            leading: CircleImageAvatar(
              size: 30,
              image: scheduledServices.employee.image,
            ),
            title: Text(
              scheduledServices.status,
              style: TextStyle(
                color: _color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Data: ${scheduledServices.date}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Horário: ${scheduledServices.hour}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Barbeiro: ${scheduledServices.employee.name}',
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ),
      ),
    );
  }
}
