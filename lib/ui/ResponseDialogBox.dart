import 'package:flutter/material.dart';

void showResponseDialog(BuildContext context, bool status,String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text((status = true) ? 'Success' : 'Failure'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();

              // Close dialog
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}
