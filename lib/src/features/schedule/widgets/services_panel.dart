import 'package:barbershop_schedule/src/models/product.dart';
import 'package:flutter/material.dart';

import 'package:barbershop_schedule/src/core/constants/constants.dart';

class ServicePanel extends StatelessWidget {
  final List<ProductModel> services;
  final ValueChanged<ProductModel> onServicesSelected;
  const ServicePanel({
    super.key,
    required this.onServicesSelected,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    var lastSelection = ValueNotifier<ProductModel?>(null);
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecione o serviço desejado',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var service in services)
                ValueListenableBuilder(
                  valueListenable: lastSelection,
                  builder: (context, value, child) {
                    return ButtonDay(
                      onServiceSelected: (serviceSelected) {
                        if (lastSelection.value != null) {
                          lastSelection.value = null;
                        }
                        lastSelection.value = serviceSelected;
                        onServicesSelected(serviceSelected);
                      },
                      product: service,
                      serviceSelected: lastSelection.value,
                    );
                  },
                ),
            ],
          )
        ],
      ),
    );
  }
}

class ButtonDay extends StatefulWidget {
  final ValueChanged<ProductModel> onServiceSelected;

  final ProductModel product;

  final ProductModel? serviceSelected;

  const ButtonDay({
    super.key,
    required this.onServiceSelected,
    required this.product,
    this.serviceSelected,
  });

  @override
  State<ButtonDay> createState() => _ButtonDayState();
}

class _ButtonDayState extends State<ButtonDay> {
  final _selected = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final ButtonDay(
      :product,
      :serviceSelected,
      :onServiceSelected,
    ) = widget;

    if (serviceSelected != null && serviceSelected == product) {
      _selected.value = true;
    } else {
      _selected.value = false;
    }

    return ValueListenableBuilder(
        valueListenable: _selected,
        builder: (context, selectedValue, _) {
          final textColor = selectedValue ? Colors.white : ColorsConstants.grey;
          var backgroundButton =
              selectedValue ? ColorsConstants.primary : Colors.white;
          final borderColor =
              selectedValue ? ColorsConstants.primary : ColorsConstants.grey;
          return Padding(
            padding: const EdgeInsets.all(5),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                selectedValue = !selectedValue;

                onServiceSelected(product);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 56,
                decoration: BoxDecoration(
                  color: backgroundButton,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: borderColor,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'R\$ ${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
