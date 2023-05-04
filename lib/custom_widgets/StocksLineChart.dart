import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StocksLineChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final bool animate;

  StocksLineChartWidget(this.data, {required this.animate});

  @override
  _StocksLineChartWidgetState createState() => _StocksLineChartWidgetState();
}

class _StocksLineChartWidgetState extends State<StocksLineChartWidget> {
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
        domainFn: (datum, index) => index as num,
        measureFn: (datum, index) => datum['quantity'] as int,
        colorFn: (datum, index) {
          final quantity = datum['quantity'] as int;
          return quantity > 10 ? charts.MaterialPalette.green.shadeDefault : charts.MaterialPalette.blue.shadeDefault;
        },        displayName: 'Quantity',
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
