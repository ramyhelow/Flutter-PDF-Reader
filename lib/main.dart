import 'dart:io';

import 'package:flutter_file_picker/flutter_document_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_reader/shared/constants.dart';

void main() {
  runApp(MaterialApp(
    title: 'PDF Reader',
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();
  String _enteredURL;
  String _pathPDF = "";
  bool loadingPDF = false;

  Future<File> createFileOfPdfUrl(url) async {
    //final url = url;

    //final url = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    print('creating file');
    await file.writeAsBytes(bytes);
    print('created file');
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PDF Reader',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Card(
              child: FlatButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    await createFileOfPdfUrl(_enteredURL).then((f) {
                      showDialog(
                          context: context,
                          builder: ((BuildContext context) {
                            return SimpleDialog(
                              children: <Widget>[CircularProgressIndicator()],
                            );
                          }));
                      setState(() {
                        _pathPDF = f.path;
                        print(_pathPDF);
                      });
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PDFScreen(_pathPDF)));
                  }
                },
                color: Colors.red[400],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'URL'),
                        validator: (val) => val.isEmpty || !val.endsWith('.pdf')
                            ? 'Please enter a valid url'
                            : null,
                        onChanged: (val) => setState(() => _enteredURL = val),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      'Enter URL',
                      style: TextStyle(color: Colors.white, fontSize: 24.0),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Card(
              child: FlatButton(
                onPressed: () async {
                  FlutterDocumentPickerParams params =
                      FlutterDocumentPickerParams(
                    allowedFileExtensions: ['pdf'],
                  );
                  _pathPDF = await FlutterDocumentPicker.openDocument(params: params);
                  if (_pathPDF != '' && _pathPDF != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PDFScreen(_pathPDF)));
                  }else{
                    print("File path: "+_pathPDF);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Invalid Pdf file'),
                    ));
                  }
                },
                child: Text(
                  'Select Local File',
                  style: TextStyle(color: Colors.white, fontSize: 24.0),
                ),
                color: Colors.green[500],
              ),
            ),
          )
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text('Plugin example app')),
  //     body: Center(
  //       child: RaisedButton(
  //         child: Text("Open PDF"),
  //         onPressed: () => Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => PDFScreen(pathPDF)),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class PDFScreen extends StatelessWidget {
  String pathPDF = "";
  PDFScreen(this.pathPDF);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            pathPDF.substring(pathPDF.lastIndexOf('/') + 1, pathPDF.length)),
      ),
      path: pathPDF,
    );
  }
}
