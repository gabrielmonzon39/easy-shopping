// ignore_for_file: empty_catches, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/data.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/model/product_bought.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class Income extends StatefulWidget {
  const Income({Key? key}) : super(key: key);
  @override
  IncomeBuilder createState() => IncomeBuilder();
}

class IncomeBuilder extends State<Income> {
  List<Widget> list = [];
  Widget? result;
  DateTime? selectedDate = DateTime.now();
  DateTime? datePrevious = DateTime.now();
  DateTime? datePreviousPrevious = DateTime.now();
  List<int> money = [0, 0, 0];
  List<Data> data = [];
  bool go = false;

  final quantityController = TextEditingController();
  static const Map<int, String> months = {
    1: "Enero",
    2: "Febrero",
    3: "Marzo",
    4: "Abril",
    5: "Mayo",
    6: "Junio",
    7: "Julio",
    8: "Agosto",
    9: "Septiembre",
    10: "Octubre",
    11: "Noviembre",
    12: "Diciembre"
  };

  List<ProductBought> products = [];

  List<ColumnSeries<Data, String>> _getRoundedColumnSeries() {
    data.add(Data(
        cantidad: money[0].toDouble(),
        fecha: "${returnMonth(datePrevious!.month)} ${datePrevious?.year}"));
    data.add(Data(
        cantidad: money[1].toDouble(),
        fecha:
            "${returnMonth(datePreviousPrevious!.month)} ${datePreviousPrevious?.year}"));
    data.add(Data(
        cantidad: money[2].toDouble(),
        fecha: "${returnMonth(selectedDate!.month)} ${selectedDate?.year}"));
    final List<Data> chartData = data;
    return <ColumnSeries<Data, String>>[
      ColumnSeries<Data, String>(
        width: 0.9,
        dataLabelSettings: const DataLabelSettings(
            isVisible: true, labelAlignment: ChartDataLabelAlignment.top),
        dataSource: chartData,

        /// If we set the border radius value for column series,
        /// then the series will appear as rounder corner.
        borderRadius: BorderRadius.circular(10),
        xValueMapper: (Data sales, _) => sales.fecha,
        yValueMapper: (Data sales, _) => sales.cantidad,
      ),
    ];
  }

  Widget printChart() {
    try {
      return SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: ChartTitle(text: ''),
        primaryXAxis: CategoryAxis(
          labelStyle: const TextStyle(color: Colors.white),
          axisLine: const AxisLine(width: 0),
          labelPosition: ChartDataLabelPosition.inside,
          majorTickLines: const MajorTickLines(width: 0),
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis:
            NumericAxis(isVisible: false, minimum: 0, maximum: maxValue + 50),
        series: _getRoundedColumnSeries(),
        tooltipBehavior: TooltipBehavior(
            enable: true,
            canShowMarker: false,
            format: 'point.x : point.y Q',
            header: ''),
      );
    } catch (err) {
      return const Text(
        "Algo ha ido mal al conseguir los datos. Esto puede ser por un error de conexión o porque la mascota aún no posee reportes de comida.",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
    }
  }

  String returnMonth(int month) {
    return months[month]!;
  }

  int getM() {
    int xy = 0;
    int x = 0, y = 0;
    int x2 = 0;
    int n = money.length;
    for (int i = 0; i < money.length; i++) {
      xy += (i + 1) * money[i];
      x += (i + 1);
      y += money[i];
      x2 += (i + 1) * (i + 1);
    }
    return (n * xy - x * y) ~/ (n * x2 - x * x);
  }

  int getB() {
    int x = 0, y = 0;
    int n = money.length;
    for (int i = 0; i < money.length; i++) {
      x += (i + 1);
      y += money[i];
    }
    return (y - getM() * x) ~/ n;
  }

  List<Map<String, dynamic>> parse(List<dynamic> products) {
    List<Map<String, dynamic>> mapProducts = [];
    for (dynamic map in products) {
      mapProducts.add(Map<String, dynamic>.from(map));
    }
    return mapProducts;
  }

  int getPosOfDate(String date) {
    // 31-08-2022
    // dd-mm-aaaa
    List<int> newDate = [];
    for (String element in date.split("-")) {
      newDate.add(int.parse(element));
    }
    if (selectedDate!.month == newDate[1] && selectedDate!.year == newDate[2]) {
      return 2;
    }
    if (datePrevious!.month == newDate[1] && datePrevious!.year == newDate[2]) {
      return 1;
    }
    if (datePreviousPrevious!.month == newDate[1] &&
        datePreviousPrevious!.year == newDate[2]) {
      return 0;
    }
    return -1;
  }

  Future<bool> calculateBestSellingProducts() async {
    String storeId = await FirebaseFS.getStoreId(uid!);
    QuerySnapshot snapSales =
        await FirebaseFirestore.instance.collection('sales').get();

    for (var sales in snapSales.docs) {
      if (sales.get('store_id') == storeId) {
        int pos = getPosOfDate(sales.get('date').toString().split(" ").last);
        if (pos == -1) continue;
        List<dynamic> products = sales.get('products');
        List<Map<String, dynamic>> mapProducts = parse(products);
        for (var mapP in mapProducts) {
          money[pos] += ((mapP['price'] * mapP['buy_quantity']) as int);
        }
      }
    }

    print(
        "Mes: ${returnMonth(selectedDate!.month)}, Año: ${selectedDate?.year} -> ${money[2]}");
    print(
        "Mes: ${returnMonth(datePrevious!.month)}, Año: ${datePrevious?.year} -> ${money[1]}");
    print(
        "Mes: ${returnMonth(datePreviousPrevious!.month)}, Año: ${datePreviousPrevious?.year} -> ${money[0]}");

    int prediction = getM() * (money.length + 1) + getB();

    result = Container(
      decoration: const BoxDecoration(
        color: ternaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          printChart(),
          const SizedBox(
            height: 20,
          ),
          Text(
              "El próximo mes se espera un ingreso de $prediction quetzales en ventas."),
        ],
      ),
    );

    return true;
  }

  @override
  Widget build(BuildContext context) {
    list = [];
    products.clear();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text("Productos más vendidos"),
        ),
        body: Container(
          width: double.infinity,
          margin:
              const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
          padding: const EdgeInsets.all(defaultPadding),
          child: SizedBox(
            height: 680,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Center(
                        child: Text(
                          'Mes: ${returnMonth(selectedDate!.month)}\nAño: ${selectedDate?.year}',
                          style: Theme.of(context).textTheme.headline5,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  return Colors.green;
                                },
                              ),
                            ),
                            onPressed: () {
                              showMonthPicker(
                                context: context,
                                firstDate: DateTime(DateTime.now().year - 1, 5),
                                lastDate: DateTime(DateTime.now().year + 1, 9),
                                initialDate: selectedDate ?? DateTime.now(),
                                locale: const Locale("es"),
                              ).then((date) {
                                if (date != null) {
                                  setState(() {
                                    go = true;
                                    money = [0, 0, 0];
                                    selectedDate = date;
                                    datePrevious = DateTime(
                                        date.year, date.month - 1, date.day);
                                    datePreviousPrevious = DateTime(
                                        date.year, date.month - 2, date.day);
                                  });
                                }
                              });
                            },
                            child: const Icon(
                              Icons.calendar_today,
                              size: 40,
                            )),
                      ),
                    ]),
                const SizedBox(
                  height: 10,
                ),
                if (go)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ////////////////////////////////////////////////////////////////
                          FutureBuilder<bool>(
                              future: calculateBestSellingProducts(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<bool> snapshot) {
                                if (!snapshot.hasData) {
                                  // not loaded
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  // some error
                                  return Column(children: const [
                                    Text(
                                      "Lo sentimos, ha ocurrido un error",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 100,
                                    ),
                                    Icon(
                                      Icons.close,
                                      size: 100,
                                    ),
                                  ]);
                                } else {
                                  // loaded
                                  bool? valid = snapshot.data;
                                  if (valid!) {
                                    return result!;
                                  }
                                }
                                return Center(
                                    child: Column(children: const [
                                  SizedBox(
                                    height: 100,
                                  ),
                                  Text(
                                    "¡Ups! Ha ocurrido un error al obtener los datos.",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 100,
                                  ),
                                  Icon(
                                    Icons.sentiment_very_dissatisfied,
                                    size: 100,
                                  ),
                                ]));
                              }),
                          ////////////////////////////////////////////////////////////////
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }
}
