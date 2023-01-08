import 'package:flutter/material.dart';
import '../models/prediction.dart';

class PredictionWidget extends StatelessWidget {
  final List<Prediction> predictions;

  const PredictionWidget({required this.predictions, super.key});

  Widget _numberWidget(int num, Prediction? prediction) {
    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            const SizedBox(
              height: 180,
              width: 5,
            ),
            Column(
              children: [
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    (prediction == null)
                        ? ""
                        : "${(prediction.confidence * 100).toStringAsFixed(0)}%",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
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
      children: [
        const Text("Prediction",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.orange[200],
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (var i = 0; i < 10; i++) _numberWidget(i, styles[i])
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
