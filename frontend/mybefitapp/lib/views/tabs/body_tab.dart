import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:mybefitapp/model/body_model.dart';
import 'package:mybefitapp/services/auth/auth_service.dart';
import 'package:mybefitapp/services/libraries/body_service.dart';
import 'package:mybefitapp/utilities/app_styles.dart';
import 'package:mybefitapp/views/tabs/sheets/add_body_sheet.dart';
import 'package:mybefitapp/views/tabs/sheets/edit_body_sheet.dart';
import 'package:pretty_gauge/pretty_gauge.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Future<dynamic> _bodyData;
  late final TextEditingController _height;
  late final TextEditingController _weight;
  String email = AuthService.firebase().currentUser?.email.toString() ?? '';
  bool showContainer = false;

  @override
  void initState() {
    _height = TextEditingController();
    _weight = TextEditingController();
    super.initState();
    _bodyData = BodyClient().checkAndGetBody(email);

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        showContainer = true;
      });
    });
  }

  @override
  void dispose() {
    _height.dispose();
    _weight.dispose();
    super.dispose();
  }

  BodyModel createBodyModel() {
    String emailReal = email;
    int height = int.parse(_height.text);
    int weight = int.parse(_weight.text);

    return BodyModel(height: height, weight: weight, email: emailReal);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 1.0,
      decoration: BoxDecoration(
        color: Styles.bgColor,
        border: Border.all(
          width: 1.0,
          color: Colors.black,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.red, Colors.pinkAccent],
                        ).createShader(bounds),
                        child: const Text(
                          'Back',
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(45.0, 15.0, 0.0, 15.0),
                  child: Text(
                    'Body',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            FutureBuilder(
              future: _bodyData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final model = snapshot.data!;
                  BodyModel forBody = bodyModelFromJson(model);
                  int height = forBody.height;
                  int weight = forBody.weight;
                  String bmi = BodyClient().forBmi(height, weight).toString();
                  //REMINDER TO SELF: WORK FOR DISPLAYING BODY MEASUREMENTS HERE
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                        ),
                        width: 320,
                        child: Column(
                          children: [
                            const Text(
                              'Body Information',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 30.0, 10.0, 5.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Height:',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        '${height.toString()} cm',
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    indent: 0,
                                    endIndent: 0,
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Weight:',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        '${weight.toString()} kg',
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    indent: 0,
                                    endIndent: 0,
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'BMI:',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        bmi,
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(
                                    color: Colors.grey,
                                    indent: 0,
                                    endIndent: 0,
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Show Suggestions:',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.info,
                                            confirmBtnColor: Colors.pinkAccent,
                                            text: BodyClient()
                                                .getHealthSuggestion(
                                                    double.parse(bmi)),
                                          );
                                        },
                                        child: const Text(
                                          'Click to View',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.pinkAccent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: PrettyGauge(
                                maxValue: 40,
                                gaugeSize: 200,
                                segments: [
                                  GaugeSegment('Severe Thinness', 15,
                                      const Color.fromARGB(255, 171, 30, 20)),
                                  GaugeSegment('Moderate Thinness', 1,
                                      Colors.pinkAccent),
                                  GaugeSegment(
                                      'Mild Thinness', 1.5, Colors.yellow),
                                  GaugeSegment('Normal', 6.5, Colors.green),
                                  GaugeSegment('Overweight', 5, Colors.yellow),
                                  GaugeSegment(
                                      'Obese Class I', 5, Colors.redAccent),
                                  GaugeSegment(
                                      'Obese Class II', 5, Colors.pink),
                                  GaugeSegment('Obese Class III', 1,
                                      const Color.fromARGB(255, 171, 30, 20)),
                                ],
                                currentValue: double.parse(bmi),
                                showMarkers: true,
                                needleColor: Colors.pink,
                                displayWidget: Text(
                                    BodyClient().classifyBMI(double.parse(bmi)),
                                    style: const TextStyle(fontSize: 12)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //edit button
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            Colors.redAccent,
                            Colors.pinkAccent,
                          ]),
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.30),
                              blurRadius: 5,
                            )
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet<void>(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25.0),
                                  topRight: Radius.circular(25.0),
                                ),
                              ),
                              isScrollControlled: true,
                              useRootNavigator: true,
                              useSafeArea: true,
                              enableDrag: true,
                              context: context,
                              builder: (BuildContext context) {
                                return const EditBody();
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            disabledForegroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            minimumSize: const Size(100, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: const Text(
                            'Edit Measurements',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return showContainer
            ? Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                    ),
                    width: 320,
                    child: Column(
                      children: [
                        const Icon(
                          Icons.directions_run_rounded,
                          color: Colors.pinkAccent,
                          size: 100,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Add Body Measurements',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                              'You can add your body measurements here to keep track of them and view other related data.'),
                        ),
                        const SizedBox(height: 15),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              Colors.redAccent,
                              Colors.pinkAccent,
                            ]),
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.30),
                                blurRadius: 5,
                              )
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet<void>(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25.0),
                                    topRight: Radius.circular(25.0),
                                  ),
                                ),
                                isScrollControlled: true,
                                useRootNavigator: true,
                                useSafeArea: true,
                                enableDrag: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return const AddBody();
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              disabledForegroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              minimumSize: const Size(100, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: const Text(
                              'Get Started',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ) : const Center(
              child: SizedBox(
                width: 35,
                child: CircularProgressIndicator(),
              ),
            );
                }
              },
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              width: 320,
              child: Column(
                children: const [
                  Text(
                    'About Body Measurements',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                        'The "Body Measurements" tab in BeFit tracks and displays height, weight, and BMI (Body Mass Index) for users to monitor their physical changes and make informed decisions about their fitness and health goals.'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
