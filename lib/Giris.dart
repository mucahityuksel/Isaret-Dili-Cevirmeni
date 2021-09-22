

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Cam extends StatefulWidget {
  @override
  _CamState createState() => _CamState();
}

class _CamState extends State<Cam> {

  List<CameraDescription> _cameras;
  CameraController _controller;
  int _cameraIndex;
  bool _isRecording = false;
  String _filePath;

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
    return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
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

  Future<void> _onStop() async {
    await _controller.stopVideoRecording();
    setState(() => _isRecording = false);
    //debugPrint("dsagdasgdfgasdsagsdgsa" + _filePath);
  }
  Future<void> dosya_yaz() async {}

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
        appBar: AppBar(
          title: Text("video recorder"),
        ),
        body: Column(
          children: [
            Container(
              height: 500,
              child: _buildCamera(),
            ),
            SizedBox(
              width: 50,
            ),
            RaisedButton(onPressed: _buildControls),

          ],
        ));
  }
}
