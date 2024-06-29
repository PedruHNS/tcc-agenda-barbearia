import 'package:flutter/material.dart';

import 'package:barbershop_schedule/src/core/constants/constants.dart';

class Header extends StatelessWidget {
  final Function()? onPressed;
  final bool isOpenbarberShop;
  final String nameBarberShop;

  const Header({
    super.key,
    required this.onPressed,
    required this.isOpenbarberShop,
    required this.nameBarberShop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 5),
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
        color: Colors.black,
        image: DecorationImage(
          image: AssetImage(
            isOpenbarberShop ? AssetsImage.background1 : AssetsImage.fechado,
          ),
          fit: BoxFit.cover,
          opacity: 0.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 40,
                backgroundImage: AssetImage(AssetsImage.logoBarbearia),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: Text(
                  nameBarberShop,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(color: ColorsConstants.primary),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: onPressed,
                icon: const Icon(Icons.exit_to_app,
                    color: Colors.white, size: 32),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            isOpenbarberShop
                ? 'Agende seu horário agora!'
                : 'Barbearia fechada',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
  }
}
