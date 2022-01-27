import 'dart:async';

import 'package:dream_university_finder_app/app/Home/job-entries-code/job_entries/format.dart';
import 'package:dream_university_finder_app/common_widgets/input_dropdown.dart';
import 'package:flutter/material.dart';

class CourseDatepicker extends StatelessWidget {
  const CourseDatepicker({
    Key? key,
    required this.labelText,
     required this.selectedDate,
     required this.selectDate,
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;

  final ValueChanged<DateTime> selectDate;


  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021, 1),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      selectDate(pickedDate);
    }
  }


  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.headline6;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: InputDropdown(
            labelText: labelText,
            valueText: Format.date(selectedDate),
            valueStyle:  valueStyle!,
            onPressed: () => _selectDate(context),
          ),
        ),

      ],
    );
  }
}
