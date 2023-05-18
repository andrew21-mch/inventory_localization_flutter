import 'package:SmartShop/screens/customs/button.dart';
import 'package:flutter/material.dart';

import 'CustomText.dart';

class CustomFilterWidget extends StatefulWidget {
  final Function(DateTime?, DateTime?) onFilter;

  const CustomFilterWidget({Key? key, required this.onFilter})
      : super(key: key);

  @override
  _CustomFilterWidgetState createState() => _CustomFilterWidgetState();
}
class _CustomFilterWidgetState extends State<CustomFilterWidget> {
  isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _endDate = DateTime.now();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = selectedDate;
        } else {
          _endDate = selectedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const CustomText(placeholder: 'Start date: '),
            GestureDetector(
              onTap: () => _selectDate(context, true),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: CustomText(
                  placeholder: '${_startDate.day}/${_startDate.month}/${_startDate.year}',

                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const CustomText(placeholder: 'End date: '),
            GestureDetector(
              onTap: () => _selectDate(context, false),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: CustomText(
                  placeholder: '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        CustomButton(
          method: () {
            widget.onFilter(_startDate, _endDate);
            Navigator.pop(context);
          },
          placeholder: 'Filter',
          width: isMobile(context) ? 100 : 150,
          height: 40,
        ),
      ],
    );
  }
}
