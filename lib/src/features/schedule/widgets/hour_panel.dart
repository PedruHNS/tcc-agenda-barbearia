import 'package:barbershop_schedule/src/core/constants/constants.dart';
import 'package:flutter/material.dart';

class HoursPanel extends StatelessWidget {
  final List<int>? enabledhours;
  final List<int> disabledHours;
  final ValueChanged<int> onHourSelected;
  final int startTime;
  final int endTime;

  const HoursPanel({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onHourSelected,
    required this.disabledHours,
    this.enabledhours,
  });

  @override
  Widget build(BuildContext context) {
    var lastSelection = ValueNotifier<int?>(null);

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecione o Horário de atendimento',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 16,
            children: [
              for (int i = startTime; i <= endTime; i++)
                ValueListenableBuilder(
                  valueListenable: lastSelection,
                  builder: (context, value, child) {
                    return ButtonTime(
                      enabledhours: enabledhours,
                      disabledHours: disabledHours,
                      label: '$i:00',
                      onHourSelected: (timeSelected) {
                        if (lastSelection.value != null) {
                          lastSelection.value = null;
                        }
                        lastSelection.value = timeSelected;
                        onHourSelected(timeSelected);
                      },
                      value: i,
                      timeSelected: lastSelection.value,
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

class ButtonTime extends StatefulWidget {
  final List<int>? enabledhours;
  final List<int> disabledHours;
  final ValueChanged<int> onHourSelected;
  final String label;
  final int value;
  final int? timeSelected;
  const ButtonTime({
    super.key,
    required this.label,
    required this.onHourSelected,
    required this.value,
    required this.timeSelected,
    required this.disabledHours,
    this.enabledhours,
  });

  @override
  State<ButtonTime> createState() => _ButtonTimeState();
}

class _ButtonTimeState extends State<ButtonTime> {
  final _selected = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final ButtonTime(
      :value,
      :label,
      :enabledhours,
      :onHourSelected,
      :timeSelected,
      :disabledHours,
    ) = widget;
    final bool isDisabled = disabledHours.contains(value);

    //& logica para selecionar apenas 1 horário
    if (timeSelected != null && timeSelected == value) {
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

        final disableTime = isDisabled ||
            (enabledhours != null && !enabledhours.contains(widget.value));
        if (disableTime) {
          backgroundButton = Colors.grey[400]!;
        }

        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: disableTime
              ? null
              : () {
                  selectedValue = !selectedValue;

                  onHourSelected(value);
                },
          child: Container(
            width: 64,
            height: 36,
            decoration: BoxDecoration(
              color: backgroundButton,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: borderColor,
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
