import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SalessLineChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final bool animate;

  SalessLineChartWidget(this.data, {required this.animate});

  @override
  _SalessLineChartWidgetState createState() => _SalessLineChartWidgetState();
}

class _SalessLineChartWidgetState extends State<SalessLineChartWidget> {
  List<charts.Series<Map<String, dynamic>, num>> _seriesList = [];

  @override
  void initState() {
    super.initState();
    _generateSeriesList();
  }

  void _generateSeriesList() {
    _seriesList = [
      charts.Series<Map<String, dynamic>, num>(
        id: 'Quantity',
        data: widget.data,
        domainFn: (datum, index) => datum['id'] as num,
        measureFn: (datum, index) => datum['quantity'] as int,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        displayName: 'Quantity',
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return charts.LineChart(
      _seriesList,
      animate: widget.animate,
      defaultRenderer: charts.LineRendererConfig(
        includePoints: true,
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
    );
  }
}

