import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class ComboBox extends StatelessWidget {
  final String value;
  final List<DropdownMenuItem<String>> items;
  final Function onChanged;

  ComboBox(this.value, this.items, this.onChanged);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
          border: Border.all(color: theme.primaryColor), color: Colors.white),
      child: DropdownButton(
        isExpanded: true,
        value: value,
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}

class TextBox extends StatelessWidget {
  final TextEditingController controller;
  final Function onSubmit;
  final String label;

  TextBox(this.label, this.controller, this.onSubmit);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      onSubmitted: onSubmit,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: theme.primaryColor)),
        fillColor: Colors.white,
        filled: true,
        labelText: label,
      ),
    );
  }
}

class FormTextBox extends StatelessWidget {
  final TextEditingController controller;
  final String initialVal;
  final Function onSave;
  final Function validator;
  final String label;
  final bool readOnly;

  FormTextBox(this.label, this.initialVal, this.onSave,
      {this.controller, this.validator, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      initialValue: controller == null ? initialVal : null,
      controller: controller,
      onSaved: onSave,
      readOnly: readOnly,
      // validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: theme.primaryColor)),
        fillColor: readOnly ? Colors.grey.withAlpha(25) : Colors.white,
        filled: true,
        labelText: label,
      ),
    );
  }
}

class DateTimeBox extends StatelessWidget {
  final TextEditingController controller;
  final String initialVal;
  final Function onSave;
  final Function validator;
  final String label;

  DateTimeBox(this.label, this.initialVal, this.controller, this.onSave,
      {this.validator});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: theme.primaryColor)),
        fillColor: Colors.white,
        filled: true,
        labelText: label,
      ),
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
      },
      onTap: () {
        // print('tap $initialVal');
        FocusScope.of(context).unfocus();
        DatePicker.showDateTimePicker(
          context,
          showTitleActions: true,
          minTime: DateTime(2020, 1, 1),
          maxTime: DateTime(2021, 1, 1),
          onConfirm: (date) {
            controller.text = DateFormat('dd MMMM yyyy, HH:mm', 'ID').format(date);
            onSave(date.toString());
            Future.delayed(Duration(milliseconds: 100)).then((_) {
              FocusScope.of(context).unfocus();
            });
          },
          onCancel: () {
            Future.delayed(Duration(milliseconds: 100)).then((_) {
              FocusScope.of(context).unfocus();
            });
          },
          currentTime: initialVal == "" ? DateTime.now() : DateTime.parse(initialVal),
          locale: LocaleType.id,
        );
      },
    );
  }
}

class Formatting {
  static String dateDMY(dynamic dt) {
    final DateTime dateTime = dt is String ? DateTime.parse(dt) : dt;
    return DateFormat("dd MMMM yyyy","ID").format(dateTime);
  }
  static String dateDMYHM(dynamic dt) {
    final DateTime dateTime = dt is String ? DateTime.parse(dt) : dt;
    return DateFormat("dd MMMM yyyy, HH:mm","ID").format(dateTime);
  }
}