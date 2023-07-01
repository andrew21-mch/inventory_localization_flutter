import 'dart:ui' as ui;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SalesHistogramChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final bool animate;

  SalesHistogramChartWidget(this.data, {required this.animate});

  @override
  _SalesHistogramChartWidgetState createState() =>
      _SalesHistogramChartWidgetState();
}

class _SalesHistogramChartWidgetState
    extends State<SalesHistogramChartWidget> {
  List<charts.Series<dynamic, String>> _seriesList = [];
  String? selectedBarLabel;

  @override
  void initState() {
    super.initState();
    _generateSeriesList();
  }

  void _generateSeriesList() {
    print('Generating series list');

    final data = widget.data != null ? widget.data[0]['data'] : null;

    if (data != null && data.isNotEmpty) {
      _seriesList = [
        charts.Series<dynamic, String>(
          id: 'Quantity',
          data: data.map((datum) {
            return {
              'id': 'id: ${datum['component_id']}',
              'quantity': datum['quantity'],
              'name': datum['component_name']
            };
          }).toList(),
          domainFn: (datum, index) => datum['id'],
          measureFn: (datum, index) => datum['quantity'],
          colorFn: (datum, index) {
            if (datum['quantity'] < 2) {
              return charts.MaterialPalette.red.shadeDefault.lighter;
            } else if (datum['quantity'] > 5) {
              return charts.MaterialPalette.green.shadeDefault.lighter;
            } else {
              return charts.MaterialPalette.blue.shadeDefault;
            }
          },
          displayName: 'Quantity',
          // Access the 'name' property
          labelAccessorFn: (datum, index) => datum['name'].toString(),
        ),
      ];
    } else {
      _seriesList = [];
    }
  }

  void _drawBarLabel(String label) {
    setState(() {
      selectedBarLabel = label.substring(4); // Remove the "id: " prefix from the label
    });
  }



  void _clearBarLabel() {
    setState(() {
      selectedBarLabel = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final localPosition = renderBox.globalToLocal(details.globalPosition);
        final chartContainerWidth = renderBox.size.width;
        final barWidth = chartContainerWidth / _seriesList.length;
        final barIndex =
        (localPosition.dx ~/ barWidth).clamp(0, _seriesList.length - 1);
        final datum = _seriesList[0].data[barIndex];
        final label = datum.key;
        _drawBarLabel(label);
        Future.delayed(const Duration(seconds: 2), () {
          _clearBarLabel();
        });
      },
      child: Stack(
        children: [
          charts.BarChart(
            _seriesList,
            animate: widget.animate,
            defaultRenderer: charts.BarRendererConfig(
              cornerStrategy: const charts.ConstCornerStrategy(10),
              barRendererDecorator: charts.BarLabelDecorator<String>(
                labelPosition: charts.BarLabelPosition.inside,
                labelAnchor: charts.BarLabelAnchor.middle,
                labelPadding: 4,
                insideLabelStyleSpec: charts.TextStyleSpec(
                  color: charts.ColorUtil.fromDartColor(Colors.white),
                ),
                outsideLabelStyleSpec: charts.TextStyleSpec(
                  color: charts.ColorUtil.fromDartColor(Colors.black),
                ),
                // This is a workaround to get the label position outside the bar
                // since labelPositionBuilder is not available

              ),
            ),
            behaviors: [
              charts.ChartTitle(
                'Item',
                behaviorPosition: charts.BehaviorPosition.bottom,
                titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea,
              ),
              charts.ChartTitle(
                'Quantity',
                behaviorPosition: charts.BehaviorPosition.start,
                titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea,
              ),
            ],
            domainAxis: const charts.OrdinalAxisSpec(
              renderSpec: charts.SmallTickRendererSpec(labelRotation: 60),
            ),
            primaryMeasureAxis: const charts.NumericAxisSpec(
              tickProviderSpec: charts.BasicNumericTickProviderSpec(
                desiredTickCount: 6,
              ),
            ),
          ),
          if (selectedBarLabel != null)
            CustomPaint(
              painter: LabelPainter(selectedBarLabel!),
            ),
        ],
      ),
    );
  }
}


class LabelPainter extends CustomPainter {
  final String label;

  LabelPainter(this.label);

  @override
  void paint(Canvas canvas, Size size) {
    final textSpan = TextSpan(
      text: label,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.layout();
    final x = (size.width - textPainter.width) / 2;
    final y = (size.height - textPainter.height) / 2;
    textPainter.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
