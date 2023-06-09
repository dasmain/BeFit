import 'package:flutter/material.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:mybefitapp/services/auth/auth_service.dart';
import 'package:mybefitapp/services/libraries/steps_service.dart';

class WeekChart extends StatefulWidget {
  const WeekChart({Key? key}) : super(key: key);

  @override
  State<WeekChart> createState() => _WeekChartState();
}

class _WeekChartState extends State<WeekChart> {
  List<dynamic> dataList = [0, 0];
  bool check = false;
  late Future<dynamic> _stepData;
  String email = AuthService.firebase().currentUser?.email.toString() ?? '';

  @override
  void initState() {
    super.initState();
    //call step service here to get all steps
    _stepData = StepsClient().getAllStepData(email);
  }

  double getFreq(double max) {
    if (max <= 1000) {
      return 100.0;
    } else if (max > 1000 && max <= 2000) {
      return 200.0;
    } else if (max > 3000 && max <= 3000) {
      return 300.0;
    } else if (max > 4000 && max <= 4000) {
      return 400.0;
    } else if (max > 5000 && max <= 5000) {
      return 500.0;
    } else if (max > 6000 && max <= 6000) {
      return 600.0;
    } else {
      return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text('Weekly Steps'),
      ),
      backgroundColor: const Color.fromARGB(255, 104, 23, 50),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 400.0,
            maxWidth: 600.0,
          ),
          padding: const EdgeInsets.all(24.0),
          child: FutureBuilder(
              future: _stepData,
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  final model = snapshot.data!;
                  List<dynamic> stepList = StepsClient().parseJsonToList(model);
                  //WEEK
                  List<dynamic> filteredList =
                      StepsClient().filterStepsList(stepList);
                  List<dynamic> steps =
                      filteredList.map((item) => item["steps"]).toList();
                  dataList = steps;
                  if (dataList.isEmpty) {
                    check = false;
                  } else {
                    check = true;
                  }
                  return Chart(
                    layers: layers(),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12.0).copyWith(
                      bottom: 12.0,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              })),
        ),
      ),
    );
  }

  List<ChartLayer> layers() {
    return [
      ChartAxisLayer(
        settings: ChartAxisSettings(
          x: ChartAxisSettingsAxis(
            frequency: 1.0,
            max: 6.0,
            min: 0.0,
            textStyle: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 10.0,
            ),
          ),
          y: ChartAxisSettingsAxis(
            frequency: getFreq(dataList
                .reduce((currentMax, element) =>
                    currentMax is num && element is num
                        ? (currentMax > element ? currentMax : element)
                        : currentMax)
                .toDouble()),
            max: check
                ? dataList
                    .reduce((currentMax, element) =>
                        currentMax is num && element is num
                            ? (currentMax > element ? currentMax : element)
                            : currentMax)
                    .toDouble()
                : 500.0,
            min: 0.0,
            textStyle: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 10.0,
            ),
          ),
        ),
        labelX: (value) => (value + 1).toString(),
        labelY: (value) => value.toInt().toString(),
      ),
      ChartBarLayer(
        items: List.generate(
          dataList.length,
          (index) => ChartBarDataItem(
            color: const Color.fromARGB(255, 248, 225, 225),
            value: dataList[index] is num ? dataList[index].toDouble() : 0.0,
            x: index.toDouble(),
          ),
        ),
        settings: const ChartBarSettings(
          thickness: 8.0,
          radius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
    ];
  }
}
