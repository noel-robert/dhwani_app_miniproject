// import 'package:http/http.dart' as http;
// import 'dart:io';
//
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class DhwaniApp_CameraPage extends StatefulWidget {
//   const DhwaniApp_CameraPage({super.key});
//
//   @override
//   _DhwaniApp_CameraPageState createState() => _DhwaniApp_CameraPageState();
// }
//
// // get a suitable camera icon
// // IconData getCameraLensIcon(CameraLensDirection direction) {
// //   switch (direction) {
// //     case CameraLensDirection.back: return Icons.camera_rear;
// //     case CameraLensDirection.front: return Icons.camera_front;
// //     case CameraLensDirection.external: return Icons.camera;
// //   }
// // }
//
// class _DhwaniApp_CameraPageState extends State<DhwaniApp_CameraPage> {
//   CameraController? _controller;
//   XFile? _imageFile;
//   String? _apiResponse;
//   final picker = ImagePicker();
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }
//
//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     _controller = CameraController(cameras[0], ResolutionPreset.high);
//     await _controller?.initialize();
//
//     if (!mounted) return;
//     setState(() {});
//   }
//
//   Future getImageFromCamera() async {
//     final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
//     setState(() {
//       _imageFile = image;
//     });
//   }
//
//   Future getImageFromGallery() async {
//     final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
//     setState(() {
//       _imageFile = image;
//     });
//   }
//
//   Future<void> sendImageToAPI() async {
//     if (_imageFile != null) {
//       File file = File(_imageFile!.path);
//       String result = await uploadImage("1001", file);
//
//       setState(() {
//         _apiResponse = result;
//       });
//     }
//   }
//
//   uploadImage(String DUID, File file) async {
//     var request = http.MultipartRequest("POST", Uri.parse("https://dhwaniapi-uvi3.onrender.com/accounts/predict"));
//     request.fields['title'] = "dummy";
//     request.headers['Referer'] = "https://dhwaniapi-uvi3.onrender.com";
//     request.fields['DUID'] = DUID;
//
//     var picture = http.MultipartFile.fromBytes('img', file.readAsBytesSync(), filename: 'testimage.png');
//
//     request.files.add(picture);
//     var response = await request.send();
//
//     var responseData = await response.stream.toBytes();
//     var result = String.fromCharCodes(responseData);
//     return result;
//   }
//
//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Camera Page"),
//       ),
//       body: _imageFile == null
//           ? Center(
//         child: _controller!.value.isInitialized
//             ? CameraPreview(_controller!)
//             : CircularProgressIndicator(),
//       )
//           : Image.file(File(_imageFile!.path)),
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//           FloatingActionButton(
//             onPressed: getImageFromGallery,
//             tooltip: 'Pick Image',
//             child: Icon(Icons.photo_library),
//           ),
//           SizedBox(height: 16),
//           FloatingActionButton(
//             onPressed: getImageFromCamera,
//             tooltip: 'Take Picture',
//             child: Icon(Icons.camera_alt),
//           ),
//           SizedBox(height: 16),
//           FloatingActionButton(
//             onPressed: sendImageToAPI,
//             tooltip: 'Send Image to API',
//             child: Icon(Icons.send),
//           ),
//         ],
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       bottomNavigationBar: _apiResponse != null
//           ? Container(
//         padding: EdgeInsets.all(16),
//         color: Colors.grey[300],
//         child: Text(
//           'API Response: $_apiResponse',
//           textAlign: TextAlign.center,
//           style: TextStyle(fontSize: 18),
//         ),
//       )
//           : null,
//     );
//   }
// }








// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
//
// class DhwaniApp_CameraPage extends StatefulWidget {
//   const DhwaniApp_CameraPage({super.key});
//
//   @override
//   _DhwaniApp_CameraPageState createState() => _DhwaniApp_CameraPageState();
// }
//
// class _DhwaniApp_CameraPageState extends State<DhwaniApp_CameraPage> {
//   var data;
//   String output = 'Null';
//   late File _imageFile;
//   final myController = TextEditingController();
//
//   Future getImage(var source) async {
//     XFile? imageFile;
//     if (source == 'camera') {
//       output = 'null';
//       imageFile = await ImagePicker()
//           .pickImage(source: ImageSource.camera); // to take from camera,
//     } else if (source == 'gallery') {
//       output = 'null';
//       imageFile = await ImagePicker()
//           .pickImage(source: ImageSource.gallery); // to take from gallery,
//     } else {
//       // don't know what happens here
//     }
//
//     setState(() {
//       if (imageFile != null) {
//         _imageFile = File(imageFile.path);
//       }
//     });
//   }
//
//   uploadImage(String DUID, File file) async {
//     var request = http.MultipartRequest("POST", Uri.parse("https://dhwaniapi-uvi3.onrender.com/accounts/predict"));
//     request.fields['title'] = "dummy";
//     request.headers['Referer'] = "https://dhwaniapi-uvi3.onrender.com";
//     request.fields['DUID'] = DUID;
//
//     var picture = http.MultipartFile.fromBytes('img', file.readAsBytesSync(), filename: 'testimage.png');
//
//     request.files.add(picture);
//     var response = await request.send();
//
//     var responseData = await response.stream.toBytes();
//     var result = String.fromCharCodes(responseData);
//     return result;
//   }
//
//   @override
//   void dispose() {
//     // clean up controller when widget is disposed
//     myController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Emotion Analysis')),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: myController,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12.0),
//                 ),
//                 hintText: 'Enter your DUID',
//                 contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 // Upload logic...
//               },
//               style: ElevatedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(18.0),
//                 ),
//                 padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
//                 primary: Colors.blueAccent,
//               ),
//               child: Text(
//                 'Upload',
//                 style: TextStyle(fontSize: 20),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Emotion: $output',
//               style: TextStyle(fontSize: 24, color: Colors.green),
//             )
//           ],
//         ),
//       ),
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           FloatingActionButton(
//             onPressed: () => getImage('camera'),
//             heroTag: null,
//             backgroundColor: Colors.blue,
//             child: Icon(Icons.camera_alt_rounded),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           FloatingActionButton(
//             onPressed: () => getImage('gallery'),
//             heroTag: null,
//             backgroundColor: Colors.blue,
//             child: Icon(Icons.image_rounded),
//           )
//         ],
//       ),
//     );
//   }
// }








import 'package:flutter/material.dart';


class DhwaniApp_CameraPage extends StatefulWidget {
  const DhwaniApp_CameraPage({super.key});

  @override
  State<DhwaniApp_CameraPage> createState() => DhwaniApp_CameraPageState();
}

class DhwaniApp_CameraPageState extends State<DhwaniApp_CameraPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}