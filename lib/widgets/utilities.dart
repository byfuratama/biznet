import 'package:flutter/material.dart';

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
  final Function onSave;
  final Function validator;
  final String label;

  FormTextBox(this.label, this.onSave, {this.controller,  this.validator});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      onSaved: onSave,
      validator: validator,
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
