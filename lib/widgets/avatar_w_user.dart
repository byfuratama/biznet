import 'package:flutter/material.dart';

class AvatarWUser extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      // width: double.infinity,
      height: 120,
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 30,
            child: Icon(
              Icons.person,
              size: 45,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "<NAMA USER>",
                  style: theme.textTheme.display2
                      .copyWith(color: Colors.white),
                ),
                Text(
                  "<POSISI>",
                  style: theme.textTheme.display1
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}