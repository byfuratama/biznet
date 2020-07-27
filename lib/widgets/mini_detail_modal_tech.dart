import 'package:flutter/material.dart';

class MiniDetailModalTech extends StatelessWidget {
  final List contents;
  final Function action1;
  final Icon action1Icon;
  final Function action2;
  final Icon action2Icon;

  MiniDetailModalTech(this.contents, {this.action1, this.action1Icon, this.action2, this.action2Icon});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Container(
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
                if (action1 != null)
                  IconButton(
                    icon: action1Icon ?? Icon(Icons.add),
                    onPressed: action1,
                    iconSize: 32,
                  ),
                if (action2 != null)
                  IconButton(
                    icon: action2Icon ?? Icon(Icons.add),
                    onPressed: action2,
                    iconSize: 32,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
