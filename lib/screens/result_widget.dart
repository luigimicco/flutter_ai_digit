import 'package:flutter/material.dart';
import '../models/classification.dart';

class ResultWidget extends StatelessWidget {
  final List<Classification> classifications;

  const ResultWidget({required this.classifications, super.key});

  @override
  Widget build(BuildContext context) {
    var values = _getClassificationValues(classifications);

    return Column(
      children: [
        const Text("Classification",
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
                  for (var i = 0; i < 10; i++)
                    _classificationWidget(i, values[i])
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _classificationWidget(
      int label, Classification? currentClassification) {
    Color classificationColor = _getClassificationColor(currentClassification);
    double classificationConfidence =
        _getClassificationConfidence(currentClassification);

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
                    color: classificationColor,
                  ),
                ),
                Container(
                  height: classificationConfidence,
                  width: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: classificationColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    (classificationConfidence == 0)
                        ? ""
                        : "${classificationConfidence.toStringAsFixed(0)}%",
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

  Color _getClassificationColor(Classification? classification) {
    return classification == null
        ? Colors.black
        : Colors.blue.withOpacity(classification.confidence);
  }

  double _getClassificationConfidence(Classification? classification) {
    return (classification == null) ? 0 : classification.confidence * 100;
  }

  List<dynamic> _getClassificationValues(
      List<Classification>? classifications) {
    List<dynamic> data = List.generate(10, (_) => null);

    if (classifications != null) {
      for (var classification in classifications) {
        data[classification.index] = classification;
      }
    }

    return data;
  }
}
