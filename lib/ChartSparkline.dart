import 'package:flutter/material.dart';
import 'dart:math';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_stock_test/CommonFuction.dart';

const PriceX = "0:00";

class ChartSparkLine extends StatefulWidget {
  ChartSparkLine({
    Key key,
    this.symbolName,
    this.listUpPrice,
    this.listDownPrice,
    this.listPrice,
    this.listTime,
    this.listTick,
    this.size,
    this.padding,
  }) : super(key: key);

  String symbolName;
  List<double> listUpPrice;
  List<double> listDownPrice;
  List<double> listPrice;
  List<String> listTime;
  List<TickData> listTick;

  final EdgeInsetsGeometry padding;
  final Size size;
  _ChartSparkLine pChart;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return pChart = _ChartSparkLine(
        symbolName: symbolName,
        listUpPrice: listUpPrice,
        listDownPrice: listDownPrice,
        listPrice: listPrice,
        listTime: listTime,
        listTick: listTick);
  }

  bool isInChartRect(Offset offset) {
    bool bRC = false;

    if (pChart != null) {
      bRC = pChart.isInChartRect(offset);
    }

    return bRC;
  }
}

class _ChartSparkLine extends State<ChartSparkLine> {
  _ChartSparkLine(
      {this.symbolName,
      this.listUpPrice,
      this.listDownPrice,
      this.listPrice,
      this.listTime,
      this.listTick});

  String symbolName;
  List<double> listUpPrice;
  List<double> listDownPrice;
  List<double> listPrice;
  List<String> listTime;
  List<TickData> listTick;
  List<double> listAvgPrice = new List();
  DrawChartSparkLine chart;
  String selectTime;
  double dbSelectAvgPrice;
  double dbSelectPrice;
  int nSelectValue;
  int nSelectIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (listAvgPrice.length > 0) listAvgPrice.clear();

    double dbAvgPrice = 0.0;
    double dbTotalPrice = 0.0;
    for (int i = 0; i < listTick.length; i++) {
      dbTotalPrice += listTick[i].price;
      dbAvgPrice = double.parse((dbTotalPrice / (i + 1)).toStringAsFixed(2));
      listAvgPrice.add(dbAvgPrice);
    }
    selectTime = listTick[listTick.length - 1].time;
    dbSelectAvgPrice = listAvgPrice[listAvgPrice.length - 1];
    dbSelectPrice = listTick[listTick.length - 1].price;
    nSelectValue = listTick[listTick.length - 1].value;
    nSelectIndex = -1;
  }

  bool isInChartRect(Offset offset) {
    bool bRC = false;

    if (chart != null) {
      bRC = chart.isInRect(offset);
    }

    return bRC;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _getChart();
  }

  Widget _getChart() {
    Widget obj;

    obj = Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: _getTickMem(),
        ),
        Expanded(
          flex: 15,
          child: GestureDetector(
            onTapUp: (TapUpDetails detail) {
              onTap(context, detail);
            },
            child: CustomSingleChildLayout(
              delegate: _DrawChartSparkLine(widget.size, widget.padding),
              child: CustomPaint(
                painter: chart = DrawChartSparkLine(
                  listUpPrice: listUpPrice,
                  listDownPrice: listDownPrice,
                  listPrice: listPrice,
                  listTime: listTime,
                  listTick: listTick,
                  listAvgPrice: listAvgPrice,
                  nSelectIndex: nSelectIndex,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: _getMemInfo(),
        ),
        Expanded(
          flex: 1,
          child: _getBSBar(),
        ),
        Expanded(
          flex: 2,
          child: _getBSTitle(),
        ),
        Expanded(
          flex: 9,
          child: Column(
            children: _getBS5Sets(),
          ),
        ),
      ],
    );

    return obj;
  }

  List<Widget> _getBS5Sets() {
    List<Widget> listObj = List<Widget>();

    List<BSData> listBuy = <BSData>[
      BSData(72.60, 22),
      BSData(72.50, 33),
      BSData(72.40, 25),
      BSData(72.30, 7),
      BSData(72.20, 36),
    ];

    List<BSData> listSell = <BSData>[
      BSData(73.70, 3),
      BSData(73.80, 15),
      BSData(73.90, 16),
      BSData(74.00, 59),
      BSData(74.10, 11),
    ];

    int buyTotal = 0;
    int sellTotal = 0;

    for (int i = 0; i < listBuy.length; i++) {
      buyTotal += listBuy[i].value;
      sellTotal += listSell[i].value;
    }

    for (int i = 0; i < 5; i++) {
      int buyValue = listBuy[i].value;
      double buyPrice = listBuy[i].price;

      int sellValue = listSell[i].value;
      double sellPrice = listSell[i].price;
      Widget obj = Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Text(
                      '$buyValue',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: LinearPercentIndicator(
                    percent: listBuy[i].value / buyTotal,
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: Colors.red,
                    isRTL: true,
                    lineHeight: 10,
                    center: Text(((listBuy[i].value / buyTotal) * 100)
                            .toStringAsFixed(2) +
                        "%"),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Text(
                      buyPrice.toStringAsFixed(2),
                      style: TextStyle(color: getPriceColor(buyPrice, listPrice[1])),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Text(
                      ' ' + sellPrice.toStringAsFixed(2),
                      style: TextStyle(color: getPriceColor(sellPrice, listPrice[1])),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: LinearPercentIndicator(
                    percent: listSell[i].value / sellTotal,
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: Colors.green,
                    isRTL: false,
                    lineHeight: 10,
                    center: Text(((listSell[i].value / sellTotal) * 100)
                            .toStringAsFixed(2) +
                        "%"),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Text(
                      '$sellValue',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
      listObj.add(obj);
    }

    for (int i = 0; i < 2; i++) {
      Widget obj;

      if (0 == i) {
        obj = Container(
          height: 1,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Divider(
                  color: Colors.red,
                ),
              ),
              Expanded(
                child: Divider(
                  color: Colors.green,
                ),
              ),
            ],
          ),
        );
      } else {
        obj = Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Text(
                  buyTotal.toString(),
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Text(
                  sellTotal.toString(),
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ],
        );
      }
      listObj.add(obj);
    }

    return listObj;
  }

  Widget _getBSTitle() {
    Widget obj;

    obj = Row(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '委買量',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
                Expanded(
                  child: Text(
                    '買價',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 1.0),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '賣價',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
                Expanded(
                  child: Text(
                    '委賣量',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 1.0),
            ),
          ),
        ),
      ],
    );

    return obj;
  }

  Widget _getBSBar() {
    Widget obj;
    int Sell = 0, Buy = 0, Total = 0;
    String SellRate, BuyRate;

    for (int i = 0; i < listTick.length; i++) {
      if (listTick[i].isSell == true)
        Sell += listTick[i].value;
      else
        Buy += listTick[i].value;

      Total += listTick[i].value;
    }

    SellRate = ((Sell / Total) * 100).toStringAsFixed(0);
    BuyRate = ((Buy / Total) * 100).toStringAsFixed(0);

    obj = Row(
      children: <Widget>[
        Expanded(
          flex: int.parse(SellRate),
          child: Container(
            height: 15.0,
            color: Colors.green,
            child: Center(
              child: Text(
                '$SellRate%',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
        Expanded(
          flex: int.parse(SellRate),
          child: Container(
            height: 15.0,
            color: Colors.red,
            child: Center(
              child: Text(
                '$BuyRate%',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );

    return obj;
  }

  Widget _getMemInfo() {
    Widget obj;

    String open = '0';
    String hight = '0';
    String low = '0';
    String value = '0';
    double dbHight = 0, dbLow = 0, dbOpen = 0;
    int nValue = 0;

    for (int i = 0; i < listTick.length; i++) {
      if (i == 0) dbLow = dbHight = dbOpen = listTick[i].price;

      dbHight = max(listTick[i].price, dbHight);
      dbLow = min(listTick[i].price, dbLow);

      nValue += listTick[i].value;
    }

    open = dbOpen.toString();
    hight = dbHight.toString();
    low = dbLow.toString();
    value = nValue.toString();

    obj = Row(
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              Text(
                "開 ",
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
              Text(
                open,
                style: TextStyle(
                  color: getPriceColor(dbOpen, listPrice[1]),
                  fontSize: 19.0,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: <Widget>[
              Text(
                "高 ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
              Text(
                hight,
                style: TextStyle(
                  color: getPriceColor(dbHight, listPrice[1]),
                  fontSize: 19.0,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: <Widget>[
              Text(
                "低 ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
              Text(
                low,
                style: TextStyle(
                  color: getPriceColor(dbLow, listPrice[1]),
                  fontSize: 19.0,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: <Widget>[
              Text(
                "總量 ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 19.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return obj;
  }

  Widget _getTickMem() {
    Widget obj;

    obj = Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Text(
            selectTime,
            style: TextStyle(color: Colors.yellow),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '價:',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Expanded(
          flex: 7,
          child: Container(
            child: Text(getPriceString(dbSelectPrice, listPrice[1]),
                style: TextStyle(
                  color: getPriceColor(dbSelectPrice, listPrice[1]),
                ),
                textAlign: TextAlign.left,
                maxLines: 1),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '均:',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            dbSelectAvgPrice.toStringAsFixed(2),
            style: TextStyle(color: Colors.red),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '量:',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            nSelectValue.toString(),
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );

    return obj;
  }

  void onTap(BuildContext context, TapUpDetails detail) {
    Offset offset = Offset(detail.globalPosition.dx,
        detail.globalPosition.dy - widget.size.height);

    if (chart != null) {
      int index = -1;

      index = chart.getSelectIndex(offset);

      if (-1 == index) {
        setState(() {
          selectTime = listTick[listTick.length - 1].time;
          dbSelectAvgPrice = listAvgPrice[listAvgPrice.length - 1];
          dbSelectPrice = listTick[listTick.length - 1].price;
          nSelectValue = listTick[listTick.length - 1].value;
          nSelectIndex = index;
        });
      } else {
        setState(() {
          selectTime = listTick[index].time;
          dbSelectAvgPrice = listAvgPrice[index];
          dbSelectPrice = listTick[index].price;
          nSelectValue = listTick[index].value;
          nSelectIndex = index;
        });
      }
    }
  }
}

class _DrawChartSparkLine extends SingleChildLayoutDelegate {
  final Size size;
  final EdgeInsetsGeometry padding;

  _DrawChartSparkLine(this.size, this.padding)
      : assert(size != null),
        assert(padding != null);

  @override
  Size getSize(BoxConstraints constraints) {
    // TODO: implement getSize
    return size;
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // TODO: implement getConstraintsForChild
    return BoxConstraints.tight(padding.deflateSize(size));
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset((size.width - childSize.width) / 2,
        (size.height - childSize.height) / 2);
  }

  @override
  bool shouldRelayout(_DrawChartSparkLine oldDelegate) {
    // TODO: implement shouldRelayout
    return this.size != oldDelegate.size;
  }
}

class DrawChartSparkLine extends CustomPainter {
  DrawChartSparkLine(
      {this.listUpPrice,
      this.listDownPrice,
      this.listPrice,
      this.listTime,
      this.listTick,
      this.listAvgPrice,
      this.nSelectIndex});

  List<double> listUpPrice;
  List<double> listDownPrice;
  List<double> listPrice;
  List<String> listTime;
  List<TickData> listTick;
  List<double> listAvgPrice;
  Rect rectChart;
  int nSelectIndex;

  bool isInRect(Offset offset) {
    bool bRC = false;

    if (rectChart != null && false == rectChart.isEmpty) {
      bRC = rectChart.contains(offset);
    }

    return bRC;
  }

  int getSelectIndex(Offset offset) {
    int index = -1;
    double dx;

    if (isInRect(offset)) {
      for (int i = 0; i < listTick.length; i++) {
        dx = _transferPriceToPosition(
                    listTick[i].price,
                    listPrice[0],
                    listPrice[2],
                    listTick[i].time,
                    listTime[0],
                    listTime[listTime.length - 1],
                    rectChart)
                .dx +
            rectChart.left;

        if (dx > offset.dx) {
          index = i;
          break;
        }
      }
    }
    return index;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    canvas.save();
    Rect rect = Offset.zero & size;
    canvas.clipRect(rect);
    Offset offset;
    if (listTick != null &&
        listUpPrice != null &&
        listDownPrice != null &&
        listPrice != null &&
        listTime != null) offset = _drawHighLowPrice(canvas, rect, false);

    rectChart = offset == null
        ? rect
        : Rect.fromLTRB(rect.left + offset.dx + 2, rect.top + 10, rect.right,
            rect.bottom - 25);

    _drawMainLine(canvas, rectChart, offset);

    if (listTick != null &&
        listUpPrice != null &&
        listDownPrice != null &&
        listPrice != null &&
        listTime != null &&
        listAvgPrice != null) {
      _drawPrice(canvas, rectChart);
      _drawHighLowPrice(canvas, rectChart, true);
      _drawTime(canvas, rectChart, offset);
      _drawTickData(canvas, rectChart, offset);
      _drawAvgPrice(canvas, rectChart, offset);
      _drawValueLine(canvas, rectChart, offset);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(DrawChartSparkLine oldDelegate) {
    // TODO: implement shouldRepaint
    return listTick != oldDelegate.listTick || rectChart != oldDelegate.rectChart;
  }

  Offset _transferPriceToPosition(double price, double priceHigh, double priceLow,
      String time, String startTime, String endTime, Rect rect) {
    double dx = 0.0;
    double dy = 0.0;
    int Gap = startTime.indexOf(":");
    int nStartTime = int.parse(startTime.substring(0, Gap)) * 60 +
        int.parse(startTime.substring(Gap + 1));
    Gap = endTime.indexOf(":");
    int nEndTime = int.parse(endTime.substring(0, Gap)) * 60 +
        int.parse(endTime.substring(Gap + 1));

    Gap = time.indexOf(":");
    int nTime = Gap == -1
        ? 0
        : int.parse(time.substring(0, Gap)) * 60 +
            int.parse(time.substring(Gap + 1));

    double dbPriceGap = rect.height / (priceHigh - priceLow);
    double dbTimeGap = rect.width / (nEndTime - nStartTime);

    if (price != 0 && nTime != 0) {
      dx = nTime == 0 ? 0 : ((nTime - nStartTime) * dbTimeGap);
      dy = ((priceHigh - price) * dbPriceGap);
    } else if (price == 0) {
      dx = nTime == 0 ? 0 : ((nTime - nStartTime) * dbTimeGap);
      dy = ((priceHigh - priceLow) * dbPriceGap);
    } else if (nTime == 0) {
      dx = nTime == 0 ? 0 : ((nTime - nStartTime) * dbTimeGap);
      dy = ((priceHigh - price) * dbPriceGap);
    }

    return Offset(dx, dy);
  }

  Offset _drawHighLowPrice(Canvas canvas, Rect rect, bool bPaint) {
    double dbWidth = 0.0;
    double dbHeight = 0.0;

    for (int i = 0; i < listPrice.length; i++) {
      Color crTmp;
      switch (i) {
        case 0:
          crTmp = Colors.red;
          break;
        case 1:
          crTmp = Colors.blue;
          break;
        case 2:
          crTmp = Colors.green;
          break;
      }

      String price = listPrice[i].toString();

      TextSpan span = new TextSpan(
        style: new TextStyle(
          color: Colors.white,
          fontSize: 18.0,
          backgroundColor: crTmp,
        ),
        text: price,
      );

      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.right,
          textDirection: TextDirection.ltr);
      tp.layout();

      dbWidth = tp.size.width;
      dbHeight = tp.size.height / 2;

      if (bPaint) {
        tp.paint(
            canvas,
            _transferPriceToPosition(listPrice[i], listPrice[0], listPrice[2],
                PriceX, listTime[0], listTime[listTime.length - 1], rect));
      }
    }
    return Offset(dbWidth, dbHeight);
  }

  Offset _drawPrice(Canvas canvas, Rect rect) {
    double dbWidth = 0.0;
    double dbHeight = 0.0;

    for (int j = 0; j < 2; j++) {
      Color crTmp = Colors.white;
      List<double> tmpList;

      switch (j) {
        case 0:
          crTmp = Colors.red;
          tmpList = listUpPrice;
          break;
        case 1:
          crTmp = Colors.green;
          tmpList = listDownPrice;
          break;
      }

      for (int i = 0; i < tmpList.length; i++) {
        String price = tmpList[i].toString();

        TextSpan span = new TextSpan(
          style: new TextStyle(
            color: crTmp,
            fontSize: 18.0,
          ),
          text: price,
        );

        TextPainter tp = new TextPainter(
            text: span,
            textAlign: TextAlign.right,
            textDirection: TextDirection.ltr);
        tp.layout();

        dbWidth = tp.size.width;
        dbHeight = tp.size.height / 2;

        tp.paint(
            canvas,
            _transferPriceToPosition(tmpList[i], listPrice[0], listPrice[2],
                PriceX, listTime[0], listTime[listTime.length - 1], rect));
      }
    }
    return Offset(dbWidth, dbHeight);
  }

  void _drawMainLine(Canvas canvas, Rect rect, Offset offset) {
    Paint paint;

    paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0;

    canvas.drawLine(
        Offset(rect.left, rect.top), Offset(rect.left, rect.bottom), paint);
    canvas.drawLine(
        Offset(rect.left, rect.bottom), Offset(rect.right, rect.bottom), paint);
    canvas.drawLine(
        Offset(rect.right, rect.top), Offset(rect.right, rect.bottom), paint);

    if (listTick != null &&
        listUpPrice != null &&
        listDownPrice != null &&
        listPrice != null &&
        listTime != null) {
      _drawPriceLine(canvas, rect, offset);
      _drawTimeLine(canvas, rect, offset);
    }
  }

  void _drawValueLine(Canvas canvas, Rect rect, Offset offset) {
    Paint paint;
    int maxValue = 0;
    Offset offsetTmp;
    Rect tmpRect = Rect.fromLTRB(
        rect.left, rect.top + (rect.height / 2), rect.right, rect.bottom);

    paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 0.5;

    for (int i = 0; i < listTick.length; i++) {
      maxValue = max(maxValue, listTick[i].value);
    }

    maxValue = ((((maxValue / 10) + 1).toInt()) * 10);

    for (int i = 0; i < listTick.length; i++) {
      offsetTmp = _transferPriceToPosition(
          listTick[i].value.toDouble(),
          maxValue.toDouble() /*500*/,
          0.0,
          listTick[i].time,
          listTime[0],
          listTime[listTime.length - 1],
          tmpRect);

      canvas.drawLine(
          Offset(tmpRect.left + offsetTmp.dx, tmpRect.top + offsetTmp.dy),
          Offset(tmpRect.left + offsetTmp.dx, tmpRect.bottom),
          paint);
    }
  }

  void _drawTimeLine(Canvas canvas, Rect rect, Offset offset) {
    Paint paint;
    double width = 0.0;

    paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 0.5;

    for (int i = 0; i < listTime.length; i++) {
      width = _transferPriceToPosition(0, listPrice[0], listPrice[2], listTime[i],
              listTime[0], listTime[listTime.length - 1], rect)
          .dx;

      canvas.drawLine(Offset(rect.left + /*offset.dx +*/ width, rect.top),
          Offset(rect.left /*+ offset.dx*/ + width, rect.bottom), paint);
    }
  }

  void _drawPriceLine(Canvas canvas, Rect rect, Offset offset) {
    Paint paint;
    double height = 0.0;

    paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 0.5;

    for (int j = 0; j < 2; j++) {
      List<double> tmpList;

      switch (j) {
        case 0:
          tmpList = listUpPrice;
          break;
        case 1:
          tmpList = listDownPrice;
          break;
      }

      for (int i = 0; i < tmpList.length; i++) {
        height = _transferPriceToPosition(tmpList[i], listPrice[0], listPrice[2],
                PriceX, listTime[0], listTime[listTime.length - 1], rect)
            .dy;

        canvas.drawLine(Offset(rect.left, height + offset.dy),
            Offset(rect.right, height + offset.dy), paint);
      }
    }

    for (int i = 0; i < listPrice.length; i++) {
      switch (i) {
        case 0:
          paint.color = Colors.red;
          break;
        case 1:
          paint.color = Colors.blue;
          break;
        case 2:
          paint.color = Colors.green;
          break;
      }
      paint.strokeWidth = 1.0;

      height = _transferPriceToPosition(listPrice[i], listPrice[0], listPrice[2],
              PriceX, listTime[0], listTime[listTime.length - 1], rect)
          .dy;

      canvas.drawLine(Offset(rect.left, height + offset.dy),
          Offset(rect.right, height + offset.dy), paint);
    }
  }

  void _drawTime(Canvas canvas, Rect rect, Offset offsetText) {
    for (int i = 0; i < listTime.length; i++) {
      String time = listTime[i];

      TextSpan span = new TextSpan(
        style: new TextStyle(
          color: Colors.yellow,
          fontSize: 18.0,
        ),
        text: time,
      );

      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();

      Offset offset = Offset(
          _transferPriceToPosition(0, listPrice[0], listPrice[2], time,
                      listTime[0], listTime[listTime.length - 1], rect)
                  .dx +
              (offsetText.dx / 2) -
              2,
          _transferPriceToPosition(0, listPrice[0], listPrice[2], time,
                      listTime[0], listTime[listTime.length - 1], rect)
                  .dy +
              offsetText.dy +
              5);

      if (offset.dx + tp.width < rect.width + offsetText.dx)
        tp.paint(canvas, offset);
    }
  }

  void _drawAvgPrice(Canvas canvas, Rect rect, Offset offset) {
    Paint paint;
    paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0;
    Offset offsetNow;
    Offset offsetTmp;
    Offset offsetPre;

    for (int i = 0; i < listAvgPrice.length; i++) {
      offsetTmp = _transferPriceToPosition(
          listAvgPrice[i],
          listPrice[0],
          listPrice[2],
          listTick[i].time,
          listTime[0],
          listTime[listTime.length - 1],
          rect);

      offsetNow = Offset(rect.left + offsetTmp.dx, offset.dy + offsetTmp.dy);
      if (0 == i) {
        offsetPre = offsetNow;
      }
      canvas.drawLine(offsetPre, offsetNow, paint);
      offsetPre = offsetNow;
    }
  }

  void _drawTickData(Canvas canvas, Rect rect, Offset offset) {
    Paint paint;
    paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0;

    Color crTmp = Colors.grey;
    Offset offsetNow;
    Offset offsetTmp;
    Offset offsetPre;
    double dbTmp = 0.0;

    double dbHight = 0.0;
    double dbLow = 0.0;

    int indexHight = -1, indexLow = -1;

    for (int i = 0; i < listTick.length; i++) {
      if (i == 0) {
        dbHight = dbLow = listTick[i].price;
        indexHight = indexLow = i;
      } else if (listTick[i].price > dbHight) {
        dbHight = listTick[i].price;
        indexHight = i;
      } else if (listTick[i].price < dbLow) {
        dbLow = listTick[i].price;
        indexLow = i;
      }
    }

    for (int i = 0; i < listTick.length; i++) {
      if (listTick[i].price > listPrice[1]) {
        crTmp = Colors.red;
      } else if (listTick[i].price < listPrice[1]) {
        crTmp = Colors.green;
      } else if (dbTmp == listTick[i].price && dbTmp > 0) {
        crTmp = Colors.grey;
      }

      paint.color = crTmp;
      offsetTmp = _transferPriceToPosition(
          listTick[i].price,
          listPrice[0],
          listPrice[2],
          listTick[i].time,
          listTime[0],
          listTime[listTime.length - 1],
          rect);

      offsetNow = Offset(rect.left + offsetTmp.dx, offset.dy + offsetTmp.dy);
      if (0 == i) {
        offsetPre = offsetNow;
      }

      if (dbTmp > 0 &&
          dbTmp != listTick[i].price &&
          ((dbTmp > listPrice[1] && listTick[i].price < listPrice[1]) ||
              (dbTmp < listPrice[1] && listTick[i].price > listPrice[1]))) {
        double dbMid =
            (offsetNow.dx - offsetPre.dx) / (offsetNow.dy - offsetPre.dy);
        double dbMidPointY = _transferPriceToPosition(
                    listPrice[1],
                    listPrice[0],
                    listPrice[2],
                    PriceX,
                    listTime[0],
                    listTime[listTime.length - 1],
                    rect)
                .dy +
            offset.dy;
        double dbMidPointX =
            ((dbMidPointY - offsetPre.dy) * dbMid) + offsetPre.dx;

        if (dbTmp > listPrice[1]) {
          paint.color = Colors.red;
          canvas.drawLine(offsetPre, Offset(dbMidPointX, dbMidPointY), paint);
          paint.color = Colors.green;
          canvas.drawLine(Offset(dbMidPointX, dbMidPointY), offsetNow, paint);
        } else {
          paint.color = Colors.green;
          canvas.drawLine(offsetPre, Offset(dbMidPointX, dbMidPointY), paint);
          paint.color = Colors.red;
          canvas.drawLine(Offset(dbMidPointX, dbMidPointY), offsetNow, paint);
        }
      } else {
        canvas.drawLine(offsetPre, offsetNow, paint);
      }

      if (nSelectIndex != null && i == nSelectIndex) {
        paint.color = Colors.yellow;
        canvas.drawLine(Offset(offsetNow.dx, rect.top),
            Offset(offsetNow.dx, rect.bottom), paint);
      }

      dbTmp = listTick[i].price;

      double dx, dy;

      if (i == indexHight || indexLow == i) {
        Color color = Colors.grey;
        Offset offsetText;
        if (dbTmp > listPrice[1])
          color = Colors.red;
        else if (dbTmp < listPrice[1]) color = Colors.green;

        TextSpan span = new TextSpan(
          style: new TextStyle(
            color: color,
            fontSize: 18.0,
          ),
          text: dbTmp.toString(),
        );

        TextPainter tp = new TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr);
        tp.layout();

        if (offsetNow.dx - (tp.width / 2) < rect.left)
          dx = offsetNow.dx;
        else if (offsetNow.dx + (tp.width / 2) > rect.right)
          dx = offsetNow.dx - (tp.width);
        else
          dx = offsetNow.dx - (tp.width / 2);

        if (offsetNow.dy - tp.height < rect.top)
          dy = offsetNow.dy + tp.height / 2;
        else if (offsetNow.dy + tp.height > rect.bottom)
          dy = offsetNow.dy - tp.height;
        else {
          if (dbTmp > listPrice[1])
            dy = offsetNow.dy - tp.height;
          else
            dy = offsetNow.dy;
        }

        offsetText = Offset(dx, dy);

        tp.paint(canvas, offsetText);
      }

      offsetPre = offsetNow;
    }
  }
}
