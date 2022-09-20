import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_pharmacy/searchMed.dart';

import 'TitleItem.dart';

class medScanningPage extends StatefulWidget {
  const medScanningPage({Key? key}) : super(key: key);

  @override
  State<medScanningPage> createState() => _medScanningPage();
}

class _medScanningPage extends State<medScanningPage> {
  bool textScanning = false;
  XFile? imageFile;
  String scannedText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey.shade50,
          iconTheme: IconThemeData(color: Colors.blue),
          centerTitle: true,
          title: const Text(
            'Scan a Medicine',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        body: Container(
            width: double.infinity,
            child: ListView(children: [
              SizedBox(height: 12),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Note: The picture must contain one word only! (Medicine Name)\n\nPS: if you upload picture that contains more than one word the program will not give you an information of the entry medicine',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                  child: SingleChildScrollView(
                child: Container(
                    margin: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (textScanning) const CircularProgressIndicator(),
                        SizedBox(height: 20),
                        if (!textScanning && imageFile == null) Container(),
                        SizedBox(height: 50),
                        if (imageFile != null)
                          Image.file(File(imageFile!.path)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                padding: const EdgeInsets.only(top: 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary: Colors.grey,
                                    shadowColor: Colors.grey[400],
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                  ),
                                  onPressed: () {
                                    getImage(ImageSource.gallery);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.image,
                                          size: 30,
                                        ),
                                        Text(
                                          "Gallery",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[600]),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                            Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                padding: const EdgeInsets.only(top: 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary: Colors.grey,
                                    shadowColor: Colors.grey[400],
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                  ),
                                  onPressed: () {
                                    getImage(ImageSource.camera);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.camera_alt,
                                          size: 30,
                                        ),
                                        Text(
                                          "Camera",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[600]),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: scannedText == ''
                              ? Container()
                              : Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  padding: const EdgeInsets.only(top: 10),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      onPrimary: Colors.grey,
                                      shadowColor: Colors.grey[400],
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SearchMed(scannedText)));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.search,
                                            size: 30,
                                          ),
                                          Text(
                                            "Search",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[600]),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                        )
                      ],
                    )),
              )),
            ])));
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occured while scanning";
      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textDetector();
    RecognisedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
      }
    }
    textScanning = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }
}
