// ignore_for_file: unnecessary_new

import 'dart:convert';

import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_highlighter/themes/an-old-hope.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlighter/themes/dark.dart';
import 'package:highlight/languages/dart.dart';
import 'package:highlight/languages/swift.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:http/http.dart';
import 'package:swift_pad/screens/console.dart';

import '../service/compiler_process.dart';

class Editor extends StatefulWidget {
  const Editor({Key? key}) : super(key: key);

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  String result = "";
  final APICompiler _apiCompiler = new APICompiler();

  late CodeController _codeController;

  @override
  void initState() {
    super.initState();
    var source = "print(\"Hello, World!\")  ";

    _codeController = CodeController(
      text: source,
      language: swift,
      patternMap: {
        r'".*"': const TextStyle(color: Colors.red),
        r'[0-9]': const TextStyle(color: Color(0xffD9C97C)),
      },
      stringMap: {
        "let": const TextStyle(color: Color(0xffDC6B99)),
        "for": const TextStyle(color: Color(0xffDC6B99)),
        "var": const TextStyle(color: Color(0xffDC6B99)),
        "if": const TextStyle(color: Color(0xffDC6B99)),
        "nil": const TextStyle(color: Color(0xffDC6B99)),
        "else": const TextStyle(color: Color(0xffDC6B99)),
        "switch": const TextStyle(color: Color(0xffDC6B99)),
        "case": const TextStyle(color: Color(0xffDC6B99)),
        "default": const TextStyle(color: Color(0xffDC6B99)),
        "where": const TextStyle(color: Color(0xffDC6B99)),
        "in": const TextStyle(color: Color(0xffDC6B99)),
        "repeat": const TextStyle(color: Color(0xffDC6B99)),
        "while": const TextStyle(color: Color(0xffDC6B99)),
        "func": const TextStyle(color: Color(0xffDC6B99)),
        "return": const TextStyle(color: Color(0xffDC6B99)),
        "true": const TextStyle(color: Color(0xffDC6B99)),
        "false": const TextStyle(color: Color(0xffDC6B99)),
        "class": const TextStyle(color: Color(0xffDC6B99)),
        "override": const TextStyle(color: Color(0xffDC6B99)),
        "willSet": const TextStyle(color: Color(0xffDC6B99)),
        "init": const TextStyle(color: Color(0xffDC6B99)),
        "self": const TextStyle(color: Color(0xffDC6B99)),
        "enum": const TextStyle(color: Color(0xffDC6B99)),
        "struct": const TextStyle(color: Color(0xffDC6B99)),
        "async": const TextStyle(color: Color(0xffDC6B99)),
        "await": const TextStyle(color: Color(0xffDC6B99)),
        "mutating": const TextStyle(color: Color(0xffDC6B99)),
        "get": const TextStyle(color: Color(0xffDC6B99)),
        "protocol": const TextStyle(color: Color(0xffDC6B99)),
        "extension": const TextStyle(color: Color(0xffDC6B99)),
        "throw": const TextStyle(color: Color(0xffDC6B99)),
        "do": const TextStyle(color: Color(0xffDC6B99)),
        "try": const TextStyle(color: Color(0xffDC6B99)),
        "catch": const TextStyle(color: Color(0xffDC6B99)),
        "as": const TextStyle(color: Color(0xffDC6B99)),
        "defer": const TextStyle(color: Color(0xffDC6B99)),
        "for _ in": const TextStyle(color: Color(0xffDC6B99)),
        "map": const TextStyle(color: Color(0xffDC6B99)),
        "some": const TextStyle(color: Color(0xffDC6B99)),
        "subscript": const TextStyle(color: Color(0xffDC6B99)),
        "print": const TextStyle(color: Color(0xffDABAFE)),
        "String": const TextStyle(color: Color(0xffDABAFE)),
        "Double": const TextStyle(color: Color(0xffDABAFE)),
        "Int": const TextStyle(color: Color(0xffDABAFE)),
        "Item": const TextStyle(color: Color(0xffDABAFE)),
        "Wrapped": const TextStyle(color: Color(0xffDABAFE)),
        "Array": const TextStyle(color: Color(0xffDABAFE)),
        "Character": const TextStyle(color: Color(0xffDABAFE)),
        "Set": const TextStyle(color: Color(0xffDABAFE)),
        "Bool": const TextStyle(color: Color(0xffDABAFE)),
        "Matrix": const TextStyle(color: Color(0xffDABAFE)),
        "SomeSuperclass": const TextStyle(color: Color(0xffDABAFE)),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff1C2834),
          leading: PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                      value: 0,
                      child: TextButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Editor()),
                          ).then((value) => setState(() {}));
                        },
                        child: const Text(
                          "New Pad",
                          style: TextStyle(color: Color(0xff1C2834)),
                        ),
                      )),
                  PopupMenuItem<int>(
                    value: 1,
                    child: TextButton(
                      onPressed: () {
                        _codeController.clear();
                      },
                      child: const Text(
                        "Rest",
                        style: TextStyle(color: Color(0xff1C2834)),
                      ),
                    ),
                  ),
                ];
              }),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Image(
                width: 30,
                height: 30,
                image: AssetImage('assets/images/swift-p-r.png'),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "SwiftPad",
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 23),
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      result = _codeController.text.toString();
                      _apiCompiler.getCompiler(result);

                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Console(output: _apiCompiler.output)));
                      });
                    });
                  },
                  icon: const Icon(Icons.play_arrow)),
            )
          ],
        ),
        body: Column(
          children: [
            Row(children: [
              SizedBox(
                  width: 390.0,
                  height: 741.0,
                  child: CodeField(
                    background: const Color(0xff0F161F),
                    controller: _codeController,
                    textStyle:
                        const TextStyle(fontFamily: 'SourceCode', fontSize: 20),
                    minLines: 14,
                  )),
            ]),
          ],
        ));
  }
}
