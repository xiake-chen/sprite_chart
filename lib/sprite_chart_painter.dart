import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'sprite_chart_widget.dart';


//默认X间距
const double defauletXsapcing = 60;

class SpriteChartPainter extends CustomPainter {
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

  //y轴刻度线
  Paint yIndexlinePaint;

  //刻度线颜色
  Color indexlineColor;

  //绘制x轴、y轴、 画笔
  Paint xyPaint;

  //折线的颜色
  Color lineColor;
  double lineWidth; //线宽

  double ylabSize,xlabSize,zeroPointSize; //y刻度文本大小//x刻度文本大小
  Color ylabColor,xlabColor,zeroPointColor;
  FontWeight zeroPointFontWeight;


  bool isShowXy; //是否显示坐标轴

  Path path;
  Map<double, Offset> _points = new Map();

  //y轴分多少行
  int yCount = 0;

  Duration duration; //动画时长
  bool isAnimation; //是否执行动画

  //----辅助线---
  bool isShowPressedHintLine; //触摸时是否显示辅助线
  double pressedPointRadius; //触摸点半径
  double pressedHintLineWidth; //触摸辅助线宽度
  Color pressedHintLineColor; //触摸辅助线颜色

  //x轴所有内容的偏移量，用来在滑动的时候改变内容的位置
  double xOffset;

  //长按和点击全局坐标
  Offset globalPosition;

  //y轴数据预留多少位
  int fixYnum;

  int yNum; //y轴的值数量
  double xSpacing; //x轴间距
  int maxVisitPoint; //屏幕上显示的最大数
  //true  展示y轴lab
  bool isShowYlab;

  //-------------------
//默认x间隔
  double value; //当前动画值

  double _fixedHeight, _fixedWidth; //去除padding后的宽高
  static const double basePadding = 20; //默认的边距
  static const double rigntPadding = 5; //默认的边距

  double startX, endX, startY, endY;
  List<double> maxMin = [0, 0]; //存储极值
  //y轴文字宽度 动态调整
  double yLabwidth = 35;

  double yzero = 0; //y轴0点坐标
  //处理滑动后开始绘制的点
  int startPosition;

  SpriteChartPainter({
    @required this.dataList,
    this.size,
    this.bgColor = Colors.blue,
    this.xyColor = Colors.red,
    this.xywidth=2,
    this.isCurve = false,
    this.lineColor = Colors.white,
    this.indexlineColor = Colors.black54,
    this.lineWidth = 2.5,
    this.ylabSize =12,
    this.xlabSize=12,
    this.zeroPointSize=12,
    this.ylabColor = Colors.black,
    this.xlabColor = Colors.black,
    this.zeroPointColor = Colors.black,
    this.zeroPointFontWeight=FontWeight.bold,


    this.isShowYlab = true,
    this.globalPosition,
    this.fixYnum = 0,
    this.yNum = 7,
    this.isShowXy = true,
    this.duration = const Duration(microseconds: 800),
    this.isAnimation = true,
    this.isShowPressedHintLine = true,
    this.pressedPointRadius = 4,
    this.pressedHintLineWidth = 0.5,
    this.pressedHintLineColor,
    this.xOffset = 0,
    this.xSpacing = defauletXsapcing,
    this.value = 1,
  }) {
    _init();
    initBorder();
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawXy(canvas);
    _drawLine(canvas);
    _drawOnPressed();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

  //初始化参数
  void _init() {
    yIndexlinePaint = Paint()
      ..color = indexlineColor
      ..strokeWidth = 0.1;

    linePaint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round
      ..color = lineColor
      ..style = PaintingStyle.stroke;

    xyPaint = Paint()
      ..color = xyColor
      ..strokeWidth = xywidth;
  }

  //计算边界 (0.0点在左上角)
  void initBorder() {
    startX = yNum > 0 ? basePadding * 2.2 : basePadding * 2; //预留出y轴刻度值所占的空间
    endX = size.width - startX - rigntPadding;
    startY = size.height - basePadding * 2.8;
    endY = basePadding * 2; //
    _fixedHeight = startY - endY;
    _fixedWidth = endX - startX;
    startPosition = (xOffset ~/ xSpacing).ceil().abs();
    print("startPosition=" + startPosition.toString());
    maxVisitPoint = (_fixedWidth / xSpacing).ceil() + 1;
    if (startPosition > (dataList.length - maxVisitPoint)) {
      startPosition = dataList.length - maxVisitPoint;
    }

    maxMin = calculateMaxMin(
        dataList, 0 + startPosition, maxVisitPoint + startPosition);
  }

  //绘制xy轴
  void _drawXy(Canvas canvas) {
    //画背景颜色
    canvas.drawRect(
        Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)),
        Paint()..color = bgColor);

    if (isShowXy) {
      //y轴
      canvas.drawLine(Offset(startX, startY + basePadding),
          Offset(startX, endY - basePadding), xyPaint);
    }

    int yLength = yNum + 1; //包含原点,所以 +1
    double dValue; //一段对应的值
    double dV = _fixedHeight / yNum; //一段对应的高度
    if (maxMin[1] >= 0) {
      if (isShowXy) {
        //x轴
        canvas.drawLine(
            Offset(startX, startY), Offset(endX, startY), xyPaint);
      }
      dValue = maxMin[0] / yNum;
      for (int i = 0; i < yLength; i++) {
        if (isShowYlab) {
          ///绘制y轴文本，保留-位小数
          var yValue = ((dValue * i) - yzero).toStringAsFixed(fixYnum);

          TextStyle textStyle;
          if (yValue == "0.0" || yValue == "0" || yValue == "0.00") {
            textStyle = TextStyle(
                color: zeroPointColor, fontSize: zeroPointSize, fontWeight: zeroPointFontWeight);
          } else {
            textStyle = TextStyle(color:ylabColor, fontSize: ylabSize);
          }

          TextPainter(
              textAlign: TextAlign.center,
              ellipsis: '.',
              maxLines: 1,
              text: TextSpan(text: '$yValue', style: textStyle),
              textDirection: TextDirection.ltr)
            ..layout(minWidth: 40, maxWidth: 50)
            ..paint(
                canvas, Offset(startX - yLabwidth, startY - dV * i - ylabSize / 2));

          ///y轴刻度
          canvas.drawLine(Offset(startX, startY - dV * (i)),
              Offset(startX + _fixedWidth, startY - dV * (i)), yIndexlinePaint);
        }
      }
    } else {
      dValue = (maxMin[0] - maxMin[1]) / yNum;
      yzero = _fixedHeight * (-maxMin[1] / (maxMin[0] - maxMin[1]));
      print("yzero = " + yzero.toString());

      if (isShowXy) {
        canvas.drawLine(Offset(startX, startY - yzero),
            Offset(endX, startY - yzero), xyPaint); //x轴

      }
      //绘制零点
      // 绘制y正轴
      int positCount = (maxMin[0] / dValue).floor(); //正正轴上的点数
      for (int i = 0; i < positCount + 2; i++) {
        if (isShowYlab) {
          ///绘制y轴文本，保留-位小数
          var yValue = ((dValue * i)).toStringAsFixed(fixYnum);

          TextStyle textStyle;
          if (yValue == "0.0" || yValue == "0" || yValue == "0.00") {
            textStyle = TextStyle(
                color: zeroPointColor, fontSize: zeroPointSize, fontWeight: zeroPointFontWeight);
          } else {
            textStyle = TextStyle(color: ylabColor, fontSize: ylabSize);
          }

          TextPainter(
              textAlign: TextAlign.center,
              ellipsis: '.',
              maxLines: 1,
              text: TextSpan(text: '$yValue', style: textStyle),
              textDirection: TextDirection.ltr)
            ..layout(minWidth: 40, maxWidth: 40)
            ..paint(canvas,
                Offset(startX - yLabwidth, startY - dV * i - ylabSize / 2 - yzero));

          //y轴刻度
          canvas.drawLine(
              Offset(startX, startY - dV * (i) - yzero),
              Offset(startX + _fixedWidth, startY - dV * (i) - yzero),
              yIndexlinePaint);
        }
      }

      //绘制y负轴
      int nativeCount = (-maxMin[1] / dValue).ceil(); //负轴上的点数
      for (int i = 1; i < nativeCount + 1; i++) {
        if (isShowYlab) {
          ///绘制y轴文本，保留-位小数
          var yValue = (-(dValue * i)).toStringAsFixed(fixYnum);

          TextPainter(
              textAlign: TextAlign.center,
              ellipsis: '.',
              maxLines: 1,
              text: TextSpan(
                  text: '$yValue',
                  style: TextStyle(color: ylabColor, fontSize: ylabSize)),
              textDirection: TextDirection.ltr)
            ..layout(minWidth: 40, maxWidth: 50)

            ..paint(
                canvas, Offset(startX - 40, startY + dV * i - ylabSize / 2 - yzero));

          //y轴刻度
          canvas.drawLine(
              Offset(startX, startY + dV * (i) - yzero),
              Offset(startX + _fixedWidth, startY + dV * (i) - yzero),
              yIndexlinePaint);
        }
      }
    }
  }

  //绘制折线
  void _drawLine(Canvas canvas) {
    if (dataList == null || dataList.length == 0) return;
    path = Path();

    //创建一个矩形， 绘制限制折线滑动范围
    Rect innerRect = Rect.fromPoints(
      Offset(startX, endY - basePadding),
      Offset(endX, startY + basePadding * 2.5),
    );

    //画折线
    canvas.clipRect(
      innerRect,
    );

    double preX, preY, currentX, currentY;
    int maxPotintCount = (_fixedWidth / xSpacing).ceil();
    maxPotintCount += 1;

    int length =
        dataList.length > maxPotintCount ? maxPotintCount : dataList.length;
//    double W = _fixedWidth / (length - 1); //两个点之间的x方向距离
    double W = xSpacing; //两个点之间的x方向距离
    bool canBreak = false;

    double maxXwidth = startX + _fixedWidth;

    double ylenth; //y轴value差值
    if (maxMin[1] >= 0) {
      ylenth = maxMin[0];
    } else {
      ylenth = maxMin[0] - maxMin[1];
    }

    for (int i = startPosition; i < length + startPosition; i++) {
      if (i == 0) {
        var key = startX + xOffset;
        var value;
        if (dataList[i].value >= 0) {
          value = (startY - dataList[i].value / ylenth * _fixedHeight - yzero);
        } else {
          value = (startY - yzero - dataList[i].value / ylenth * _fixedHeight);
        }
        path.moveTo(key, value);
        _points[key] = Offset(key, value);

        //x轴标记
        TextPainter(
            textAlign: TextAlign.center,
            ellipsis: '.',
            maxLines: 1,
            text: TextSpan(
                text: dataList[i].type,
                style: TextStyle(color: xlabColor, fontSize: xlabSize)),
            textDirection: TextDirection.ltr)
          ..layout()
          ..paint(
              canvas,
              Offset(
                  startX + xSpacing * i + xOffset, startY + basePadding * 1.3));

        continue;
      }

      //x轴标记
      TextPainter(
          textAlign: TextAlign.center,
          ellipsis: '.',
          maxLines: 1,
          text: TextSpan(
              text: dataList[i].type,
              style: TextStyle(color: xlabColor, fontSize: xlabSize)),
          textDirection: TextDirection.ltr)
        ..layout()
        ..paint(
            canvas,
            Offset(
                startX + xSpacing * i + xOffset - xlabSize / 2, //x轴标记正好在点下方
                startY + basePadding * 1.3));

      currentX = startX + W * i + xOffset;
      preX = startX + W * (i - 1) + xOffset;

      if (dataList[i].value >= 0) {
        preY = (startY - dataList[i - 1].value / ylenth * _fixedHeight - yzero);
        currentY = (startY - dataList[i].value / ylenth * _fixedHeight - yzero);
      } else {
        preY = (startY - dataList[i - 1].value / ylenth * _fixedHeight);
        currentY = (startY - yzero - dataList[i].value / ylenth * _fixedHeight);
      }

      if (isCurve) {
        path.cubicTo((preX + currentX) / 2, preY, (preX + currentX) / 2,
            currentY, currentX, currentY);
      } else {
        path.lineTo(currentX, currentY);
      }

      if (canBreak) {
        break;
      }
    }

    if (maxMin[0] <= 0) return;
    var pathMetrics = path.computeMetrics(forceClosed: false);
    var list = pathMetrics.toList();
    var listlength = value * list.length.toInt();
    Path linePath = new Path();
    Path shadowPath = new Path();
    for (int i = 0; i < listlength; i++) {
      var extractPath =
          list[i].extractPath(0, list[i].length * value, startWithMoveTo: true);
      linePath.addPath(extractPath, Offset(0, 0));
      shadowPath = extractPath;
    }

    canvas.drawPath(linePath, linePaint);
  }

  //绘制按下的提示线
  void _drawOnPressed() {}

  _getTextPainter(String value) {
    return TextPainter(
        textAlign: TextAlign.center,
        ellipsis: '.',
        maxLines: 1,
        text: TextSpan(
            text: '$value',
            style: TextStyle(color: Colors.black, fontSize: 12)),
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 40, maxWidth: 50);
  }

  ///计算极值 最大值,最小值
  List<double> calculateMaxMin(List<ChartData> chatBeans, int start, int end) {
    if (chatBeans == null || chatBeans.length == 0) return [0, 0];
    double max = 0.0, minValue = 0.0;
    if (chatBeans.length < start) {
      return [];
    }
    for (start; start < min(end, chatBeans.length); start++) {
      ChartData bean = chatBeans[start];
      if (max < bean.value) {
        max = bean.value;
      }
      if (minValue > bean.value) {
        minValue = bean.value;
      }
    }
    return [max, minValue];
  }

  //画刻度线 lab
  void drawRuler(Canvas canvas) {
    if (dataList == null || dataList.length < 0) {
      return;
    }
    maxMin[0] - maxMin[1];
  }

  List getTextPainterAndSize(String text) {
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: text,
        style: TextStyle(color: Colors.black),
      ),
    );
    textPainter.layout();
    Size size = textPainter.size;
    return [textPainter, size];
  }

  void drawYText(String text, Offset topLeftOffset, Canvas canvas) {
    List list = getTextPainterAndSize(text);
    list[0].paint(
        canvas, topLeftOffset.translate(-list[1].width, -list[1].height / 2));
  }

  void drawXText(String text, Offset topLeftOffset, Canvas canvas) {
    List list = getTextPainterAndSize(text);
    list[0].paint(canvas, topLeftOffset.translate(-list[1].width / 2, 0));
  }
}
