import 'package:flutter/material.dart';

class MiniDetailModal extends StatelessWidget {
  final List contents;
  final Function onEdit;
  final Function onDelete;

  MiniDetailModal(this.contents, this.onEdit, this.onDelete);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      color: Theme.of(context).primaryColor.withAlpha(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...contents
              .map((content) => Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      content,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ))
              .toList(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              if (this.onEdit != null) IconButton(
                icon: Icon(Icons.edit),
                onPressed: onEdit,
                color: Colors.amber,
              ),
              if (this.onDelete != null) IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: onDelete,
                  color: Colors.red),
            ],
          ),
        ],
      ),
    );
  }
}
