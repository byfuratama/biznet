import 'package:flutter/material.dart';

class NumberedTile extends StatelessWidget {
  final int index;
  final List<String> contents;
  final Widget trailing;

  NumberedTile(this.index, this.contents, this.trailing);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor.withAlpha(25),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(index.toString()),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: contents.map((content) => Text(content)).toList(),
        ),
        trailing: trailing,
      ),
    );
  }
}
