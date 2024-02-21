class PredictionMlModel {
  final double predictedGlucose;
  final int timeDifference;

  PredictionMlModel({
    required this.predictedGlucose,
    required this.timeDifference,
  });

  factory PredictionMlModel.fromJson(Map<String, dynamic> json) =>
      PredictionMlModel(
        predictedGlucose: json["predicted_glucose"]?.toDouble(),
        timeDifference: json["time_difference"],
      );

  Map<String, dynamic> toJson() => {
        "predicted_glucose": predictedGlucose,
        "time_difference": timeDifference,
      };
}
