import 'package:get/get.dart';

import '../../export_packages.dart';

/// Returns a list of maps containing glucose prediction data for charting.
RxList<Map<String, dynamic>> packageGetChartData() {
  // Clear the chart data list if it's not empty.
  if (packageChartDataList.isNotEmpty) {
    packageChartDataList.clear();
  }

  // Loop through the prediction list and add a new map to the chart data list for each item.
  for (int i = 0; i < packagePredictionList.value.length; i++) {
    // Get the time set by the user if not then now
    var now = DateTime.now();

    // Add a new map to the chart data list with the time and predicted glucose values.
    packageChartDataList.add({
      'time': now.add(Duration(
        minutes: packagePredictionList.value[i].timeDifference,
      )),
      'glucose': packagePredictionList.value[i].predictedGlucose,
    });
  }

  // Return the chart data list.
  return packageChartDataList;
}
