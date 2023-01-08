import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'painter_screen.dart';
import "../services/recognizer.dart";
import "../models/prediction.dart";
import 'result_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Offset?> _points = [];
  List<Prediction> _prediction = [];
  bool initialize = false;
  final _recognizer = Recognizer();

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: const [
            Text('Digit AI Recognizer'),
            Text(
              '(using MNIST database of handwritten digits)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [_tapWidget(), _smallImage()]),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _points.clear();
                        _prediction.clear();
                        setState(() {});
                      },
                      child: const Text("Clear"))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ResultWidget(
                predictions: _prediction,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tapWidget() {
    return Container(
      width: Constants.canvasSize + Constants.borderSize * 2,
      height: Constants.canvasSize + Constants.borderSize * 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.black,
          width: Constants.borderSize,
        ),
      ),
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          Offset pos = details.localPosition;
          if (pos.dx.clamp(0, Constants.canvasSize) == pos.dx &&
              pos.dy.clamp(0, Constants.canvasSize) == pos.dy) {
            _points.add(pos);
            setState(() {});
          }
        },
        onPanEnd: (DragEndDetails details) {
          _points.add(null);
          _recognize();
        },
        child: CustomPaint(
          painter: Painter(_points),
        ),
      ),
    );
  }

  Widget _smallImage() {
    return Container(
      width: Constants.previewImageSize,
      height: Constants.previewImageSize,
      color: Colors.black,
      child: FutureBuilder(
        future: _previewImage(),
        builder: (BuildContext _, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(
              snapshot.data!,
              fit: BoxFit.fill,
            );
          } else {
            return const Center(
              child: Text('Error'),
            );
          }
        },
      ),
    );
  }

  void _initModel() async {
    await _recognizer.loadModel();
  }

  Future<Uint8List> _previewImage() async {
    return await _recognizer.previewImage(_points);
  }

  void _recognize() async {
    List<dynamic> pred = await _recognizer.recognize(_points);
    _prediction = pred.map((json) => Prediction.fromJson(json)).toList();
    setState(() {});
  }
}
