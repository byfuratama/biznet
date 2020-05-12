import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import './avatar_w_user.dart';


class AppHeader extends StatelessWidget {

  final page;

  AppHeader(this.page);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      height: 200,
      color: theme.primaryColor,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Biznet Branch Ubud \n$page',
                style: theme.textTheme.display1
                    .copyWith(color: Colors.white),
              ),
              Container(
                child: Card(
                  elevation: 10,
                  color: theme.cardColor,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                    child: Text(
                      DateFormat('dd MMMM yyyy', 'ID')
                          .format(DateTime.now()),
                      style: theme.textTheme.display1
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          AvatarWUser()
        ],
      ),
    );
  }
}
