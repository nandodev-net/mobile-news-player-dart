import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/views/native_webview/native_webview.dart';
import 'package:noticias_sin_filtro/views/wrappers/webview_wrapper.dart';

class Navigate extends StatefulWidget {
  const Navigate({Key? key, required this.port}) : super(key: key);
  final String port;
  @override
  _NavigateState createState() => _NavigateState();
}

class _NavigateState extends State<Navigate> {
  final String _defaultURL = "https://www.google.com";
  String _currentUrl = "www.google.com";
  final urlInputController = TextEditingController(text: "www.google.com");

  @override
  void dispose() {
    urlInputController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    //urlInputController.addListener(_printLatestValue);
  }

  // void _printLatestValue() {
  //   print('Second text field: ${urlInputController.text}');
  // }

  void _handleSubmit(submission) {
    print('submission: ${urlInputController.text}');
    setState(() {
      _currentUrl = submission;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: TextField(
                onSubmitted: _handleSubmit,
                controller: urlInputController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(CupertinoIcons.doc_text_search),
                  border:OutlineInputBorder(),
                  hintText: 'Url',
                  prefix: Text('https://'),
                  prefixIconColor:
                  MaterialStateColor.resolveWith((Set<MaterialState> states) {
                    if (states.contains(MaterialState.focused)) {
                      return Colors.green;
                    }
                    if (states.contains(MaterialState.error)) {
                      return Colors.red;
                    }
                    return Colors.grey;
                  }),
                ),
            ),
          ),
          Expanded(
            child: NativeWebView(url: _currentUrl==""?"https://"+_currentUrl:_defaultURL, port: widget.port)
          ),
      ],
    );
  }
}
