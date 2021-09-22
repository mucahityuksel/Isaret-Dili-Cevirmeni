import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:final_project/loadData.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<CameraDescription> _cameras;
  CameraController _controller;
  int _cameraIndex;
  bool _isRecording = false;
  String _filePath;

  Future<loadData> _loadData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    availableCameras().then((cameras) => {
          _cameras = cameras,
          if (_cameras.length != 0)
            {_cameraIndex = 0, _initCamera(_cameras[_cameraIndex])}
        });
  }

  _initCamera(CameraDescription camera) async {
    if (_controller != null) {
      await _controller.dispose();
    }
    _controller = CameraController(camera, ResolutionPreset.high);
    _controller.addListener(() {
      this.setState(() {});
    });
    _controller.initialize();
  }

  Widget _buildCamera() {
    if (_controller == null || !_controller.value.isInitialized) {
      return Center(
        child: Text("yukleniyor"),
      );
    }
    return RotationTransition(
        turns: AlwaysStoppedAnimation(270 / 360),
        child: CameraPreview(_controller));
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(_getCameraIcon(_cameras[_cameraIndex].lensDirection)),
          onPressed: _onSwitchCamera,
        ),
        IconButton(
          icon: Icon(Icons.radio_button_checked),
          onPressed: _isRecording ? null : _onRecord,
        ),
        IconButton(
          icon: Icon(Icons.stop),
          onPressed: _isRecording ? _onStop : null,
        ),
        IconButton(
          icon: Icon(Icons.play_arrow),
          onPressed: _isRecording ? null : _onPlay,
        ),
      ],
    );
  }

  Future<void> _onPlay() async {
    await OpenFile.open(_filePath);
    dosya_yaz();
  }

  sendFile(file) {
    // var reader = new FileReader();
    // reader.readAsDataUrl(new File(_filePath));
    File file = new File(_filePath);
    var url = Uri.parse("http://10.0.2.2:5000/video");
    var request = new http.MultipartRequest("POST", file.uri);
    Uint8List _bytesData =
        Base64Decoder().convert(file.toString().split(",").last);
    List<int> _selectedFile = _bytesData;

    request.files.add(http.MultipartFile.fromBytes('file', _selectedFile,
        contentType: new MediaType('application', 'octet-stream'),
        filename: "text_upload.txt"));

    request.send().then((response) {
      print("test");
      print(response.statusCode);
      if (response.statusCode == 200) print("Uploaded!");
    });
  }

  Future<FormData> dosya_yolla() async {
    try {
      FormData formData = new FormData.fromMap({
        "name": "mucahit",
        "file":
            await MultipartFile.fromFile(_filePath, filename: "dosyaadibu.mp4")
      });

      Response response = await Dio().post("http://10.0.2.2:5000/video",
          data: formData, options: Options(validateStatus: (status) => true));
      print("----");

      //return response.data;

    } catch (e) {
      print(e);
    }
  }

  Future<Widget> x() async {
    try {
      Response response1 = await Dio().get("http://10.0.2.2:5000/test",
          options: Options(validateStatus: (status) => true));
      print(response1.data);
      return showDialog(
          context: context,
          builder: (context) {
            return Text(
              response1.data,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 40,
                  color: Colors.white),
              textAlign: TextAlign.center,
            );
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onStop() async {
    await _controller.stopVideoRecording();
    setState(() => _isRecording = false);
    debugPrint("dsagdasgdfgasdsagsdgsa" + _filePath);
  }

  

  Future<void> _onRecord() async {
    var directory = await getTemporaryDirectory();
    _filePath = directory.path + '/${DateTime.now()}.mp4';

    _controller.startVideoRecording(_filePath);
    setState(() {
      _isRecording = true;
    });
  }

  IconData _getCameraIcon(CameraLensDirection lensDirection) {
    if (lensDirection == CameraLensDirection.back) {
      return Icons.camera_front;
    } else {
      return Icons.camera_rear;
    }
  }

  void _onSwitchCamera() {
    if (_cameras.length < 2) return;
    _cameraIndex = (_cameraIndex + 1) % 2;
    _initCamera(_cameras[_cameraIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          height: 500,
          child: _buildCamera(),
        ),
        SizedBox(
          width: 50,
        ),
        RaisedButton(
          onPressed: () => x(),
          child: Text("Göster"),
          color: Colors.blueGrey,
        ),
        RaisedButton(
          onPressed: () {
            dosya_yolla();
          },
          child: Text("Yükle"),
          color: Colors.lightBlue,
        ),
        SizedBox(
          width: 50,
        ),
        _buildControls(),
      ],
    ));
  }
}
