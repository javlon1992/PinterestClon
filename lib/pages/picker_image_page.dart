import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPage extends StatefulWidget {
  static String id="image_picker";

  const ImagePickerPage({Key? key}) : super(key: key);

  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  var image;

  Future getMyImage() async{
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if(pickedImage!=null){
        image = File(pickedImage.path);
        print("Here path ${pickedImage.path}");
      }
    });
  }

  Future getMyImageCamera() async{
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      if(pickedImage!=null){
        image = File(pickedImage.path);
        print("Here path ${pickedImage.path}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 400,
              width: 400,
              child: image==null? const Center(child:  Text("No image selected yet")): Image.file(image, fit: BoxFit.fitHeight,),
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: getMyImage, child: const Text("Pick", style: TextStyle(fontSize: 18),),
                ),
                ElevatedButton(
                  onPressed: getMyImageCamera, child: const Text("Take", style: TextStyle(fontSize: 18)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}