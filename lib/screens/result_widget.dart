import 'package:flutter/material.dart';
import '../models/prediction.dart';

class ResultWidget extends StatelessWidget {
  final List<Prediction> predictions;

  const ResultWidget({required this.predictions, super.key});

  @override
  Widget build(BuildContext context) {
    var values = _getPredictionValues(predictions);

    return Column(
      children: [
        const Text("Prediction",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
        Container(
          decoration: BoxDecoration(
              color: Colors.orange[200],
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (var i = 0; i < 10; i++) _predictionWidget(i, values[i])
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _predictionWidget(int label, Prediction? currentPrediction) {
    Color predictionColor = _getPredictionColor(currentPrediction);
    double predictionConfidence = _getPredictionConfidence(currentPrediction);

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
                  '$label',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: predictionColor,
                  ),
                ),
                Container(
                  height: predictionConfidence,
                  width: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: predictionColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    (predictionConfidence == 0)
                        ? ""
                        : "${predictionConfidence.toStringAsFixed(0)}%",
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

  Color _getPredictionColor(Prediction? prediction) {
    return prediction == null
        ? Colors.black
        : Colors.blue.withOpacity(prediction.confidence);
  }

  double _getPredictionConfidence(Prediction? prediction) {
    return (prediction == null) ? 0 : prediction.confidence * 100;
  }

  List<dynamic> _getPredictionValues(List<Prediction>? predictions) {
    List<dynamic> data = List.generate(10, (_) => null);

    if (predictions != null) {
      for (var prediction in predictions) {
        data[prediction.index] = prediction;
      }
    }

    return data;
  }
}
