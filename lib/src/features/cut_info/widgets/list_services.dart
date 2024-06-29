import 'package:auto_size_text/auto_size_text.dart';
import 'package:barbershop_schedule/src/core/constants/constants.dart';

import 'package:barbershop_schedule/src/models/product.dart';
import 'package:flutter/material.dart';

class ListServices extends StatelessWidget {
  final List<ProductModel> services;

  const ListServices({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: ColorsConstants.primary.withOpacity(0.6),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 8,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Serviços: ',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(children: [
                for (var service in services)
                  InfoRow(name: service.name, value: 'R\$${service.price}'),
              ]),
            ),
          ],
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
        Flexible(
          child: AutoSizeText(
            name,
            style: Theme.of(context).textTheme.displayMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.displayMedium,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
