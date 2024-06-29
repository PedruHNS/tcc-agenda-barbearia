import 'package:barbershop_schedule/src/core/constants/constants.dart';
import 'package:barbershop_schedule/src/core/ui/helpers/messages.dart';
import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';

class ScheduleCalendar extends StatefulWidget {
  final List<String> workDays;
  final VoidCallback cancelPressed;
  final ValueChanged<DateTime> okPressed;
  const ScheduleCalendar({
    super.key,
    required this.cancelPressed,
    required this.okPressed,
    required this.workDays,
  });

  @override
  State<ScheduleCalendar> createState() => _ScheduleCalendarState();
}

class _ScheduleCalendarState extends State<ScheduleCalendar> {
  DateTime? selectedDay;
  late List<int> weekDaysEnable;

  int convertWeekDay(String weekDay) {
    return switch (weekDay.trim()) {
      "Segunda" => DateTime.monday,
      "Terça" => DateTime.tuesday,
      "Quarta" => DateTime.wednesday,
      "Quinta" => DateTime.thursday,
      "Sexta" => DateTime.friday,
      "Sábado" => DateTime.saturday,
      "Domingo" => DateTime.sunday,
      _ => 0,
    };
  }

  @override
  void initState() {
    weekDaysEnable = widget.workDays.map(convertWeekDay).toList();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ScheduleCalendar oldWidget) {
    weekDaysEnable = widget.workDays.map(convertWeekDay).toList();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 247, 232, 232),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          TableCalendar(
            enabledDayPredicate: (day) {
              return weekDaysEnable.contains(day.weekday);
            },
            availableGestures: AvailableGestures.none,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            focusedDay: selectedDay == null ? DateTime.now() : selectedDay!,
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 7)),
            calendarFormat: CalendarFormat.week,
            pageJumpingEnabled: true,
            locale: 'pt_BR',
            selectedDayPredicate: (day) {
              return isSameDay(selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                this.selectedDay = selectedDay;
              });
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(
                color: ColorsConstants.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: ColorsConstants.primary.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  widget.cancelPressed();
                  selectedDay = null;
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                      color: ColorsConstants.primary,
                      fontWeight: FontWeight.w500),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (selectedDay == null) {
                    Messages.showError('Selecione uma data', context);
                    return;
                  }
                  widget.okPressed(selectedDay!);
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: ColorsConstants.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
