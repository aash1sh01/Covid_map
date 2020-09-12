import 'package:flutter/material.dart';
import 'package:flutter_auth/components/text_field_container.dart';

class ErrorMsg extends StatelessWidget {
  final title;
  final content;


  const ErrorMsg({Key key, this.title, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextFieldContainer(
      child: AlertDialog(
        title: title,
        content: content,
        actions: <Widget>[
          FlatButton(onPressed: () {
            Navigator.of(context).pop();
          },
              child: Text("Close"),
          )
        ]
      )
    );
  }


}






