

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DialogUtils {
  static void showLoading(BuildContext context, {bool dismissible = true}) {
    showDialog(
      barrierDismissible: dismissible,
      context: context,
      builder: (context) => PopScope(
        canPop: dismissible,
        child: CupertinoAlertDialog(
          content: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  static void hideDialog(BuildContext context) {
    Navigator.pop(context);
  }

  static void showDialogMessage(
    BuildContext context, {
    required String message,
    String? posTitle,
    String? negTitle,
    VoidCallback? posAction,
    VoidCallback? negAction,
  }) {
    List<Widget> actions = [];
    if (posTitle != null) {
      actions.add(MaterialButton(onPressed: () {
       posAction?.call();
       Navigator.pop(context);
      }, child: Text(posTitle)));
    }

    if (negTitle != null) {
      actions.add(MaterialButton(onPressed: () {
        negAction?.call();
        Navigator.pop(context);
      }, child: Text(negTitle)));
    }
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Row(children: [Text(message)]),
        actions: actions,
      ),
    );
  }



  static void showToast(String message, Color color){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
