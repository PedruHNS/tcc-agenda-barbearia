import 'package:barbershop_schedule/src/features/home/home_controller.dart';
import 'package:barbershop_schedule/src/features/home/widgets/employee_card.dart';

import 'package:barbershop_schedule/src/features/home/widgets/header.dart';
import 'package:barbershop_schedule/src/features/home/widgets/scheduled_services_card.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    final homeController = context.read<HomeController>();
    homeController.getServiceHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeController = context.read<HomeController>();

    void logout() async {
      await homeController.logout();
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/auth/login');
      }
    }

    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: homeController.loading == false
              ? CustomScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Consumer<HomeController>(
                        builder: (_, homeController, __) => Header(
                          onPressed: logout,
                          isOpenbarberShop: homeController.barbershopStatus,
                          nameBarberShop: homeController.barbershopName,
                        ),
                      ),
                    ),
                    const SliverAppBar(
                      pinned: true,
                      toolbarHeight: 0,
                      bottom: TabBar(
                        tabs: [
                          Tab(text: 'Barbeiros'),
                          Tab(text: 'Cortes agendados'),
                        ],
                      ),
                    ),
                    SliverFillRemaining(
                      child: TabBarView(
                        children: [
                          homeController.loading
                              ? const Center(child: CircularProgressIndicator())
                              : Consumer<HomeController>(
                                  builder: (_, homeController, __) {
                                    return ListView.builder(
                                      itemCount:
                                          homeController.employees.length,
                                      itemBuilder: (context, index) {
                                        return EmployeeCard(
                                          employee:
                                              homeController.employees[index],
                                        );
                                      },
                                    );
                                  },
                                ),
                          Consumer<HomeController>(
                            builder: (_, value, __) {
                              return ListView.builder(
                                itemCount: homeController.services.length,
                                itemBuilder: (context, index) {
                                  return ScheduledServicesCard(
                                      scheduledServices:
                                          homeController.services[index]);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
