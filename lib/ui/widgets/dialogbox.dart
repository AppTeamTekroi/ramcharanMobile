import 'package:flutter/material.dart';

class RejectionDialog extends StatefulWidget {
  final int id; // Pass the leave ID to the dialog
  final Function(String) onSubmit; // Callback function to handle submission

  const RejectionDialog({required this.id, required this.onSubmit, Key? key}) : super(key: key);

  @override
  _RejectionDialogState createState() => _RejectionDialogState();
}

class _RejectionDialogState extends State<RejectionDialog> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rejection',style: TextStyle(color: Colors.green[900]),),
      content: TextField(
        controller: _reasonController,
        decoration: InputDecoration(
          hintText: 'Enter reason here',
        ),
        maxLines: 3,
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
        ElevatedButton(
          child: Text('Submit'),
          onPressed: () {
            final reason = _reasonController.text;
            if (reason.isNotEmpty || reason.isEmpty) {
              widget.onSubmit(reason); // Call the callback with the entered reason
              Navigator.of(context).pop(); // Close the dialog
            } else {
              // Optionally show an error if the reason is empty
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Reason cannot be empty'),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}