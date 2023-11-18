import 'package:flutter/material.dart';

class Utils {

  // this method used to show a loading dialog
  showLoaderDialog(BuildContext context, String text) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
            margin: const EdgeInsets.only(left: 7),
            child: Text(text),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // this method show a message in snackbar
  void showSnackBar(BuildContext context, String text) {

    final snackBar = SnackBar(
      content: Text(text),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Color greyColor=const Color(0xffEBEBEB);
  Color peachColor=const Color(0xfff3c8b1);

}
