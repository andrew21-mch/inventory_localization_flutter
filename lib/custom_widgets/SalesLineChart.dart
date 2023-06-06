import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SalessHistogramChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final bool animate;

  SalessHistogramChartWidget(this.data, {required this.animate});

  @override
  _SalessHistogramChartWidgetState createState() =>
      _SalessHistogramChartWidgetState();
}

class _SalessHistogramChartWidgetState
    extends State<SalessHistogramChartWidget> {
  List<charts.Series<dynamic, String>> _seriesList = [];

  @override
  void initState() {
    super.initState();
    _generateSeriesList();
  }

  void _generateSeriesList() {
    print('Generating series list');

    final data = widget.data != null ? widget.data[0]['data'] : [];
    _seriesList = [
      charts.Series<dynamic, String>(
        id: 'Quantity',
        //extract the data from the list of maps
        data: data.map((datum) {
          return MapEntry('id: ${datum['component_id']}', datum['quantity']);
        }).toList(),
        domainFn: (datum, index) => datum.key,
        measureFn: (datum, index) => datum.value,
        colorFn: (datum, index) {
          if (datum.value < 2) {
            return charts.MaterialPalette.red.shadeDefault.lighter;
          } else if (datum.value > 5) {
            return charts.MaterialPalette.green.shadeDefault.lighter;
          } else {
            return charts.MaterialPalette.blue.shadeDefault;
          }
        },
        displayName: 'Quantity',
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      _seriesList,
      animate: widget.animate,
      defaultRenderer: charts.BarRendererConfig(
        cornerStrategy: const charts.ConstCornerStrategy(10),
      ),
      behaviors: [
        charts.ChartTitle('Item',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        charts.ChartTitle('Quantity',
            behaviorPosition: charts.BehaviorPosition.start,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
      ],
      domainAxis: const charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(labelRotation: 60),
      ),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        tickProviderSpec:
            charts.BasicNumericTickProviderSpec(desiredTickCount: 6),
      ),
    );
  }
}
