import 'package:flutter/material.dart';
import '../models/prediction.dart';

class PredictionWidget extends StatelessWidget {
  final List<Prediction> predictions;

  const PredictionWidget({required this.predictions, super.key});

  Widget _numberWidget(int num, Prediction? prediction) {
    return Column(
      children: <Widget>[
        Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            const SizedBox(
              height: 120,
              width: 5,
            ),
            Column(
              children: [
                Text(
                  prediction == null
                      ? ''
                      : "${(prediction.confidence * 100).toStringAsFixed(0)}%",
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  height:
                      (prediction == null) ? 0 : prediction.confidence * 100,
                  width: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: prediction == null
                        ? Colors.black
                        : Colors.blue.withOpacity(
                            (prediction.confidence * 2).clamp(0, 1).toDouble(),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Text(
          '$num',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: prediction == null
                ? Colors.black
                : Colors.blue.withOpacity(
                    (prediction.confidence * 2).clamp(0, 1).toDouble(),
                  ),
          ),
        ),
      ],
    );
  }

  List<dynamic> getPredictionStyles(List<Prediction>? predictions) {
    List<dynamic> data = [
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null
    ];

    if (predictions != null) {
      for (var prediction in predictions) {
        data[prediction.index] = prediction;
      }
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    var styles = getPredictionStyles(predictions);

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            for (var i = 0; i < 10; i++) _numberWidget(i, styles[i])
          ],
        ),
      ],
    );
  }
}
