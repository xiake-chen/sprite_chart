import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spritechart/spritechart.dart';
import 'package:spritechart/sprite_chart_widget.dart';
import 'package:spritechart/sprite_chart_painter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnnotatedRegion(
        value: SystemUiOverlayStyle.light
            .copyWith(statusBarBrightness: Brightness.dark),
        child: ExampleChart(),
      ),
    );
  }
}

class ExampleChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        _buildMyLineChart(context),
        _buildMyLineChartTwo(context),
      ],
    );
  }

  Widget _buildMyLineChart(context) {
    Size size = Size(MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height / 5 * 1.6);
    var linechart = SpriteChartwidget(
      fixYnum: 0,
      size: size,
      dataList: getListdata(),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.white,
      child: linechart,
      clipBehavior: Clip.antiAlias,
    );
  }

  Widget _buildMyLineChartTwo(context) {
    Size size = Size(MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height / 5 * 1.6);
    var linechart = SpriteChartwidget(
      bgColor: Colors.brown,
      xyColor: Colors.white,
      lineWidth: 4,
      lineColor: Colors.white,
      ylabSize: 13,
      xlabSize: 13,
      xlabColor: Colors.white,
      ylabColor: Colors.white,
      zeroPointSize: 13,
      zeroPointColor: Colors.white,
      xywidth: 4,
      fixYnum: 1,
      yNum: 6,
      size: size,
      dataList: getListdatatwo(),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.white,
      child: linechart,
      clipBehavior: Clip.antiAlias,
    );
  }

  List<ChartData> getListdata() {
    return [
      ChartData("1", 1),
      ChartData("q", 2),
      ChartData(" 3", 3),
      ChartData(" 4", 4),
      ChartData(" 5", -2),
      ChartData(" 王", 8),
      ChartData(" 7", -3),
      ChartData(" 无", 1),
      ChartData(" 9", 4),
      ChartData(" 10", -23),
      ChartData(" 11", 5),
      ChartData(" 12", 4),
      ChartData("13", 4.3),
      ChartData(" 14", -102.3),
      ChartData(" 15", 1),
      ChartData(" 16", 4),
      ChartData(" 17", -23),
      ChartData(" 18", 5),
      ChartData(" 19", 4),
    ];
  }

  List<ChartData> getListdatatwo() {
    return [
      ChartData("1", 0.01),
      ChartData("q", 0.34),
      ChartData(" 3", 0.001),
      ChartData(" 4", 0.5),
      ChartData(" 5", 0),
      ChartData(" 王", 2),
      ChartData(" 7", 1.05),
      ChartData(" 无", 1),
      ChartData(" 9", 4),
      ChartData(" 10", -23),
      ChartData(" 11", 5),
      ChartData(" 12", 4),
      ChartData("13", 4.3),
      ChartData(" 14", -102.3),
      ChartData("q", 0.34),
      ChartData(" 3", 0.001),
      ChartData(" 4", 0.5),
      ChartData(" 5", 0),
      ChartData(" 王", 2),
      ChartData(" 7", -1.05),
      ChartData(" 无", 1),
      ChartData(" 9", 4),
      ChartData(" 10", -23),
      ChartData(" 11", 5),
      ChartData(" 12", 4),
      ChartData("13", 4.3),
      ChartData(" 14", -102.3),
      ChartData("q", 0.34),
      ChartData(" 3", 0.001),
      ChartData(" 4", 0.5),
      ChartData(" 5", 0),
      ChartData(" 王", 2),
      ChartData(" 7", -1.05),
      ChartData(" 无", 1),
      ChartData(" 9", 4),
      ChartData(" 10", -23),
      ChartData(" 11", 5),
      ChartData(" 12", 4),
      ChartData("13", 4.3),
      ChartData(" 14", -102.3),
      ChartData("q", 0.34),
      ChartData(" 3", 0.001),
      ChartData(" 4", 0.5),
      ChartData(" 5", 0),
      ChartData(" 王", 2),
      ChartData(" 7", -1.05),
      ChartData(" 无", 1),
      ChartData(" 9", 4),
      ChartData(" 10", -23),
      ChartData(" 11", 5),
      ChartData(" 12", 4),
      ChartData("13", 4.3),
      ChartData(" 14", -102.3),
      ChartData("q", 0.34),
      ChartData(" 3", 0.001),
      ChartData(" 4", 0.5),
      ChartData(" 5", 0),
      ChartData(" 王", 2),
      ChartData(" 7", -1.05),
      ChartData(" 无", 1),
      ChartData(" 9", 4),
      ChartData(" 10", -23),
      ChartData(" 11", 5),
      ChartData(" 12", 4),
      ChartData("13", 4.3),
      ChartData(" 14", -102.3),
      ChartData("q", 0.34),
      ChartData(" 3", 0.001),
      ChartData(" 4", 0.5),
      ChartData(" 5", 0),
      ChartData(" 王", 2),
      ChartData(" 7", -1.05),
      ChartData(" 无", 1),
      ChartData(" 9", 4),
      ChartData(" 10", -23),
      ChartData(" 11", 5),
      ChartData(" 12", 4),
      ChartData("13", 4.3),
      ChartData(" 14", -102.3),
      ChartData(" 15", 1),
      ChartData(" 16", 4),
      ChartData(" 17", -23),
      ChartData(" 18", 5),
      ChartData(" 19", 4),
    ];
  }
}
