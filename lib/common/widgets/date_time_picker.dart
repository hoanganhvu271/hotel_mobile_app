import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePickerDropdown extends StatefulWidget {
  final String label;
  final Function(String date, String time) onChanged;
  final DateTime? initialDateTime;

  const DateTimePickerDropdown({
    super.key,
    required this.label,
    required this.onChanged,
    this.initialDateTime,
  });

  @override
  State<DateTimePickerDropdown> createState() => _DateTimePickerDropdownState();
}

class _DateTimePickerDropdownState extends State<DateTimePickerDropdown> {
  late DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.initialDateTime ?? DateTime.now();
    _notifyParent();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          selectedDateTime.hour,
          selectedDateTime.minute,
        );
      });
      _notifyParent();
    }
  }

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
    );

    if (pickedTime != null) {
      setState(() {
        selectedDateTime = DateTime(
          selectedDateTime.year,
          selectedDateTime.month,
          selectedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
      _notifyParent();
    }
  }

  void _notifyParent() {
    final String date = DateFormat('yyyy-MM-dd').format(selectedDateTime);
    final String time = DateFormat('HH:mm').format(selectedDateTime);
    widget.onChanged(date, time);
  }

  @override
  Widget build(BuildContext context) {
    final String displayDate = DateFormat('dd/MM/yyyy').format(selectedDateTime);
    final String displayTime = DateFormat('HH:mm').format(selectedDateTime);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${widget.label}:',
              style: const TextStyle(
                color: Color(0xFF65462D),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          GestureDetector(
            onTap: _pickTime,
            child: Container(
              width: 80,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              margin: const EdgeInsets.only(right: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0x1E787880),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                displayTime,
                style: const TextStyle(
                  color: Color(0xFF65462D),
                  fontSize: 16,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              width: 130,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0x1E787880),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                displayDate,
                style: const TextStyle(
                  color: Color(0xFF65462D),
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
