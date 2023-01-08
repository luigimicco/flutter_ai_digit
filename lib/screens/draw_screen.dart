import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'drawing_painter.dart';
import "../services/recognizer.dart";
import "../models/prediction.dart";
import 'prediction_widget.dart';

class DrawScreen extends StatefulWidget {
  const DrawScreen({super.key});

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
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
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [_drawCanvasWidget(), _mnistPreviewImage()]),
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _points.clear();
                        _prediction.clear();
                      });
                    },
                    child: const Text("Clear"))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            PredictionWidget(
              predictions: _prediction,
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawCanvasWidget() {
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
          Offset localPosition = details.localPosition;
          if (localPosition.dx >= 0 &&
              localPosition.dx <= Constants.canvasSize &&
              localPosition.dy >= 0 &&
              localPosition.dy <= Constants.canvasSize) {
            setState(() {
              _points.add(localPosition);
            });
          }
        },
        onPanEnd: (DragEndDetails details) {
          _points.add(null);
          _recognize();
        },
        child: CustomPaint(
          painter: DrawingPainter(_points),
        ),
      ),
    );
  }

  Widget _mnistPreviewImage() {
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
    setState(() {
      _prediction = pred.map((json) => Prediction.fromJson(json)).toList();
    });
  }
}
