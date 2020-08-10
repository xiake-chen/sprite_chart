import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'sprite_chart_painter.dart';


class SpriteChartwidget extends StatefulWidget {
  Size size;

  //实际的数据
  List<ChartData> dataList;

  //折线图的背景颜色
  Color bgColor;

  //x轴与y轴的颜色
  Color xyColor;
  //xy轴宽度
  double  xywidth;

  bool isCurve; //标记是否为曲线
  //绘制x轴、y轴分割线，标记文字的画笔
  Paint linePaint;

  //绘制x轴、y轴、 画笔
  Paint xyPaint;

  //折线的颜色
  Color lineColor;
  double lineWidth; //线宽

  double ylabSize,xlabSize,zeroPointSize; //y刻度文本大小//x刻度文本大小
  Color ylabColor,xlabColor,zeroPointColor;
  FontWeight zeroPointFontWeight;

  //刻度线颜色
  Color indexlineColor;

  //y轴分多少行
  int yCount = 0;

  Duration duration; //动画时长
  bool isAnimation; //是否执行动画
  bool isShowXy, isShowYlab;

  //----辅助线---
  bool isShowPressedHintLine; //触摸时是否显示辅助线
  double pressedPointRadius; //触摸点半径
  double pressedHintLineWidth; //触摸辅助线宽度
  Color pressedHintLineColor; //触摸辅助线颜色



  double xSpacing;
  int yNum; //y轴的值数量
  double value;

  int fixYnum;




  SpriteChartwidget({
    @required this.dataList,
    this.size,
    this.bgColor = Colors.white,
    this.xyColor = Colors.black,
    this.xywidth=2,
    this.isCurve = false,
    this.lineColor = Colors.black54,
    this.lineWidth = 2,
    this.ylabSize =12,
    this.xlabSize=12,
    this.zeroPointSize=12,
    this.ylabColor = Colors.black,
    this.xlabColor = Colors.black,
    this.indexlineColor = Colors.black54,

    this.zeroPointColor = Colors.black,
    this.zeroPointFontWeight=FontWeight.bold,
    this.fixYnum = 0,
    this.isShowYlab = true,
    this.yNum = 7,
    this.isShowXy = true,
    this.duration = const Duration(microseconds: 800),
    this.isAnimation = true,
    this.isShowPressedHintLine = true,
    this.pressedPointRadius = 4,
    this.pressedHintLineWidth = 0.5,
    this.pressedHintLineColor = Colors.black54,
    this.xSpacing = defauletXsapcing,
    this.value = 1,
  });

  @override
  State<StatefulWidget> createState() {
    return SpriteChartwidgetState();
  }
}

class SpriteChartwidgetState extends State<SpriteChartwidget> {
  double xOffset;
  double xSpacing;
  Size size;

  //长按和点击全局坐标
  Offset globalPosition;

  @override
  void initState() {
    xOffset = 0;
    xSpacing = widget.xSpacing;
    size = widget.size;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {

        setState(() {
          globalPosition = details.globalPosition;
          print("onLongPressStart="+globalPosition.toString());

        });
      },
      onLongPressMoveUpdate: (details) {

        setState(() {
          globalPosition = details.globalPosition;
          print("onLongPressMoveUpdate = "+globalPosition.toString());

        });
      },
      onLongPressUp: () async {
        print("onLongPressUp");

        await Future.delayed(Duration(milliseconds: 800)).then((_) {
          setState(() {
            globalPosition = null;
          });
        });
      },
      onTapUp: (TapUpDetails details) {

        setState(() {
          globalPosition = details.globalPosition;
          print("onTapUp="+globalPosition.toString());

        });

      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        print("onHorizontalDragUpdate");

        xOffset += details.primaryDelta;
        //禁止右滑动超出
        if (xOffset > 0) {
          xOffset = 0;
        }
        //禁止左滑动超出
        int startPosition = (xOffset ~/ xSpacing).ceil().abs();
        int maxVisitPoint = (size.width / xSpacing).ceil();
        if ((startPosition + maxVisitPoint) > widget.dataList.length) {
          xOffset -= details.primaryDelta;
        }
        setState(() {
          xOffset;
        });
      },
      child: CustomPaint(
        size: widget.size,
        painter: SpriteChartPainter(
          size: widget.size,
          yNum: widget.yNum,
          dataList: widget.dataList,
          isCurve: widget.isCurve,
          isShowYlab: widget.isShowYlab,
          isShowXy: widget.isShowXy,
          isAnimation: widget.isAnimation,
          isShowPressedHintLine: widget.isShowPressedHintLine,
          globalPosition: globalPosition,
          bgColor: widget.bgColor,
          xyColor: widget.xyColor,
          fixYnum: widget.fixYnum,
          lineColor: widget.lineColor,
          lineWidth: widget.lineWidth,
          ylabSize: widget.ylabSize,
          xlabSize: widget.xlabSize,
          xlabColor: widget.xlabColor,
          ylabColor: widget.ylabColor,
          zeroPointColor: widget.zeroPointColor,
          zeroPointFontWeight: widget.zeroPointFontWeight,
          zeroPointSize: widget.zeroPointSize,
          indexlineColor: widget.indexlineColor,
          duration: widget.duration,
          pressedPointRadius: widget.pressedPointRadius,
          pressedHintLineWidth: widget.pressedHintLineWidth,
          pressedHintLineColor: widget.pressedHintLineColor,
          xOffset: xOffset,
          xSpacing: widget.xSpacing,
          value: widget.value,
        ),
      ),
    );
  }
}


class ChartData {
  String type;
  double value;
  bool isSelect;

  ChartData(this.type, this.value);
}
