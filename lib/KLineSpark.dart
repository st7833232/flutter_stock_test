import 'package:flutter/material.dart';
import 'package:flutter_stock_test/CommonFuction.dart';
import 'dart:math';

class KLineSpark extends StatefulWidget {
  KLineSpark(this.list, this.currentDataType,
      {Key key,
      this.nTickWidth = 1.0,
      this.nIdx = -1,
      this.dbFontSize = 14.0,
      this.bShowTime = true,
      this.nStart = 0,
      this.nEnd = 0})
      : super(key: key);

  List<KTickData> list;
  double nTickWidth;
  int nStart;
  int nEnd;
  int nIdx;
  String currentDataType;
  double dbFontSize;
  bool bShowTime;
  _KLinePainter viewTA;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _KLineSpark();
  }

  int getRectIdx(Offset offset) {
    int nIdx = -1;
    if (null != viewTA) {
      nIdx = viewTA.getRectIdx(offset);
    }
    return nIdx;
  }

  int getTaViewStart() {
    int nIdx = 0;
    if (null != viewTA) {
      nIdx = viewTA.getTaViewStart();
    }
    return nIdx;
  }

  int getTaViewEnd() {
    int nIdx = 0;
    if (null != viewTA) {
      nIdx = viewTA.getTaViewEnd();
    }
    return nIdx;
  }

  int getTaViewCount() {
    int nIdx = 0;
    if (null != viewTA) {
      nIdx = viewTA.getTaViewCount();
    }
    return nIdx;
  }
}

class _KLineSpark extends State<KLineSpark> {
  _KLineSpark();

  String _getIdxAngValue(int nIdx, int nAvg) {

    if (nIdx >= widget.list.length) widget.nIdx = nIdx = widget.list.length - 1;

    if (0 > nIdx) nIdx = widget.list.length + nIdx;

    double dbTotal = 0.0;
    int nCount = 0;

    for (int i = 0; i < nAvg; i++) {
      if (nIdx - i < widget.list.length && nIdx - i >= 0) {
        dbTotal += widget.list[nIdx - i].price;
        nCount++;
      }
    }

    int nTmp = widget.list.length < nAvg ? widget.list.length : nCount;

    return (dbTotal / nTmp).toStringAsFixed(2);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      '均價5: ',
                      style: TextStyle(
                          color: Colors.yellow, fontSize: widget.dbFontSize),
                    ),
                    Text(
                      _getIdxAngValue(widget.nIdx, 5) + " ",
                      style: TextStyle(
                          color: getPriceColor(
                              double.parse(_getIdxAngValue(widget.nIdx, 5)),
                              double.parse(
                                  _getIdxAngValue(widget.nIdx - 1, 5))),
                          fontSize: widget.dbFontSize),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      '均價20: ',
                      style: TextStyle(
                          color: Colors.purpleAccent,
                          fontSize: widget.dbFontSize),
                    ),
                    Text(
                      _getIdxAngValue(widget.nIdx, 20) + " ",
                      style: TextStyle(
                          color: getPriceColor(
                              double.parse(_getIdxAngValue(widget.nIdx, 20)),
                              double.parse(
                                  _getIdxAngValue(widget.nIdx - 1, 20))),
                          fontSize: widget.dbFontSize),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      '均價60: ',
                      style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontSize: widget.dbFontSize),
                    ),
                    Text(
                      _getIdxAngValue(widget.nIdx, 60) + " ",
                      style: TextStyle(
                          color: getPriceColor(
                              double.parse(_getIdxAngValue(widget.nIdx, 60)),
                              double.parse(
                                  _getIdxAngValue(widget.nIdx - 1, 60))),
                          fontSize: widget.dbFontSize),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 19,
          child: LimitedBox(
            child: CustomPaint(
              size: Size.infinite,
              painter: widget.viewTA = _KLinePainter(
                  widget.list, widget.currentDataType,
                  nTickWidth: widget.nTickWidth,
                  dbFontSize: widget.dbFontSize,
                  bShowTime: widget.bShowTime,
                  nIdx: widget.nIdx,
                  nStart: widget.nStart,
                  nEnd: widget.nEnd),
            ),
          ),
        ),
      ],
    );
  }
}

class _KLinePainter extends CustomPainter {
  _KLinePainter(
    this.list,
    this.currentDataType, {
    this.nTickWidth,
    this.dbFontSize = 14.0,
    this.bShowTime = true,
    this.nIdx = -1,
    this.nStart = 0,
    this.nEnd = 0,
  });

  List<KTickData> list;
  String currentDataType;
  double nTickWidth;
  int nStart = 0;
  int nEnd = 0;
  int _nTickCount;
  int _nMaxValue = 0;
  int _nViewCount = 0;
  double _dbHighPrice = 0.0;
  double _dbLowPrice = 0.0;
  double dbFontSize;
  bool bShowTime;
  Rect _rectKLine;
  int nIdx;
  List<double> _listAvg5 = new List();
  List<double> _listAvg20 = new List();
  List<double> _listAvg60 = new List();

  int getTaViewStart() {
    return this.nStart;
  }

  int getTaViewEnd() {
    return this.nEnd;
  }

  int getTaViewCount() {
    return this._nViewCount;
  }

  int getRectIdx(Offset offset) {
    int nIdx = -1;

    if (null != _rectKLine) {
      if (offset.dx == _rectKLine.left)
        nIdx = nStart;
      else if (offset.dx == _rectKLine.right)
        nIdx = nEnd;
      else if (offset.dx >= _rectKLine.left && offset.dx <= _rectKLine.right) {
        double left = 0.0, right = 0.0;
        double dbGap = _rectKLine.width / _nViewCount;

        for (int i = nStart; i <= nEnd; i++) {
          if (i == nStart)
            left = _rectKLine.left;
          else
            left = _rectKLine.left + (i - nStart) * dbGap;

          right = _rectKLine.left + (i + 1 - nStart) * dbGap;

          barK tick = _getBarKRect(left, right, list[i], _rectKLine);

          if (tick.rect.right >= offset.dx) {
            nIdx = i;
            break;
          }
        }
      }
    }

    return nIdx;
  }

  bool _getAvgList(int nAvg, List<double> list, List<KTickData> listTick) {
    bool bRC = false;
    double dbTotal = 0.0;

    list.clear();
    if (listTick != null && listTick.length > 0) {
      for (int i = 0; i < listTick.length; i++) {
        dbTotal = 0.0;
        for (int j = 0; j < nAvg; j++) {
          if (i - j >= 0) dbTotal += listTick[i - j].price;
        }
        if (i < nAvg && i + 1 <= listTick.length)
          list.add(double.parse((dbTotal / (i + 1)).toStringAsFixed(2)));
        else
          list.add(double.parse((dbTotal / nAvg).toStringAsFixed(2)));
      }

      if (list.length == listTick.length) bRC = true;
    }

    return bRC;
  }

  void _update(Size size) {
    if (nStart < 0 || nStart > list.length) nStart = 0;

    if (nEnd == 0 || nEnd >= list.length) this.nEnd = list.length - 1;

    _nTickCount = list.length;

    double dbGap = 1.0;

    switch (currentDataType) {
      case "15分":
        dbGap = 3.0;
        break;
      case "30分":
        dbGap = 6.0;
        break;
      case "60分":
        dbGap = 12.0;
        break;
      case "日":
        dbGap = 3.0;
        break;
      case "周":
        dbGap = 15.0;
        break;
      case "月":
        dbGap = 60.0;
        break;
      case "季":
        dbGap = 30.0;
        break;
      default:
        dbGap = 1.0;
        break;
    }

    _nViewCount = size.width ~/ (nTickWidth * dbGap);

    assert(_getAvgList(5, _listAvg5, list));
    assert(_getAvgList(20, _listAvg20, list));
    assert(_getAvgList(60, _listAvg60, list));

    if (nEnd - nStart >= _nViewCount) nStart = nEnd - _nViewCount + 1;

    if (nEnd - nStart < _nViewCount) {
      if (nStart + _nViewCount - 1 >= _nTickCount)
        nStart = nEnd - _nViewCount;
      else
        nEnd = nStart + _nViewCount - 1;
    }

    if (-1 != nIdx &&
        nIdx >= 0 &&
        nIdx < _nTickCount &&
        (nIdx < nStart || nIdx > nEnd)) {
      int nTmp = _nViewCount ~/ 2;
      int nMore = 0;

      nEnd = nIdx + nTmp;

      if (nEnd > _nTickCount) nMore = nEnd - _nTickCount;

      nStart = nIdx - nTmp - nMore;

      if (nEnd >= _nTickCount) nEnd = _nTickCount - 1;

      if (nStart < 0) nStart = 0;

      if (nEnd - nStart >= _nViewCount)
        nEnd = nStart + _nViewCount - 1;
    }

    if (nStart >= 0 &&
        nEnd >= 0 &&
        nStart < _nTickCount &&
        nEnd < _nTickCount) {
      for (int i = nStart; i <= nEnd; i++) {
        _nMaxValue = max(_nMaxValue, list[i].value);
        _dbHighPrice =
            double.parse(max(_dbHighPrice, list[i].high).toStringAsFixed(2));

        if (nStart == i) _dbLowPrice = list[i].low;

        _dbLowPrice =
            double.parse(min(_dbLowPrice, list[i].low).toStringAsFixed(2));
      }
    }

    _dbHighPrice =
        double.parse(((_dbHighPrice ~/ 5 + 2) * 5).toStringAsFixed(2));
    _dbLowPrice = double.parse(((_dbLowPrice ~/ 5 - 1) * 5).toStringAsFixed(2));

    _getKLineRect(size);
  }

  void _getKLineRect(Size size) {
    Rect rect = Offset.zero & size;

    TextSpan span = new TextSpan(
      style: new TextStyle(
        color: Colors.white,
        backgroundColor: Colors.yellow,
        fontSize: dbFontSize,
      ),
      text: _dbHighPrice.toStringAsFixed(2),
    );

    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.right,
        textDirection: TextDirection.ltr);
    tp.layout();

    Offset offset = Offset(tp.size.width, tp.size.height / 2);
    int nTmp;
    bShowTime == true ? nTmp = 3 : nTmp = 0;

    _rectKLine = offset == null
        ? rect
        : Rect.fromLTRB(rect.left + offset.dx + 2, rect.top + offset.dy,
            rect.right - 15, rect.bottom - (offset.dy * nTmp));
  }

  void _drawMainLine(Canvas canvas, Rect rect) {
    Paint paint;

    paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0;

    canvas.drawLine(
        Offset(rect.left, rect.top), Offset(rect.left, rect.bottom), paint);
    canvas.drawLine(
        Offset(rect.left, rect.bottom), Offset(rect.right, rect.bottom), paint);
  }

  void _drawYValue(Canvas canvas, double dx, double dy, double dbValue) {
    TextSpan span = new TextSpan(
      style: new TextStyle(
        color: Colors.yellow,
        fontSize: dbFontSize,
      ),
      text: dbValue.toStringAsFixed(2),
    );

    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.right,
        textDirection: TextDirection.ltr);
    tp.layout();

    tp.paint(canvas, Offset(dx - tp.width - 1, dy - (tp.height / 2)));
  }

  void _drawYLine(
      Canvas canvas, Rect rect, double dbHigh, double dbLow, int nSpilt) {
    double dbGapValue = (dbHigh - dbLow) / nSpilt;
    double dbGapY = rect.height / nSpilt;
    Paint paint;

    paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 0.3;

    for (int i = 0; i < nSpilt; i++) {
      canvas.drawLine(Offset(rect.left, rect.bottom - (i + 1) * dbGapY),
          Offset(rect.right, rect.bottom - (i + 1) * dbGapY), paint);
      _drawYValue(canvas, rect.left, rect.bottom - (i + 1) * dbGapY,
          dbLow + (i + 1) * dbGapValue);
    }
  }

  double _getYValue(double dbVale, Rect rect) {
    double dbPriceGap = rect.height / (_dbHighPrice - _dbLowPrice);
    return rect.top + (dbPriceGap * (_dbHighPrice - dbVale));
  }

  barK _getBarKRect(double left, double right, KTickData tickData, Rect rect) {
    Color color;
    Rect rectTick;
    double dbHeight, dbLow;

    _getYValue(tickData.high, rect);
    _getYValue(tickData.low, rect);

    if (tickData.open > tickData.price) {
      color = Colors.green;
      rectTick = Rect.fromLTRB(left + 1, _getYValue(tickData.open, rect),
          right - 1, _getYValue(tickData.price, rect));
    } else if (tickData.open < tickData.price) {
      color = Colors.red;
      rectTick = Rect.fromLTRB(left + 1, _getYValue(tickData.price, rect),
          right - 1, _getYValue(tickData.open, rect));
    } else {
      color = Colors.white;
      rectTick = Rect.fromLTRB(left + 1, _getYValue(tickData.price, rect),
          right - 1, _getYValue(tickData.open, rect));
    }

    if (tickData.high >= tickData.low) {
      dbHeight = _getYValue(tickData.high, rect);
      dbLow = _getYValue(tickData.low, rect);
    } else {
      dbLow = _getYValue(tickData.high, rect);
      dbHeight = _getYValue(tickData.low, rect);
    }

    return barK(rectTick, dbHeight, dbLow, color);
  }

  void _drawKLine(Canvas canvas, Rect rect) {
    double left = 0.0, right = 0.0;
    double dbGap = rect.width / _nViewCount;

    Paint paint;
    paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0;

    for (int i = nStart; i <= nEnd; i++) {
      if (i == nStart)
        left = rect.left;
      else
        left = rect.left + (i - nStart) * dbGap;

      right = rect.left + (i + 1 - nStart) * dbGap;

      if (i >= _nTickCount) break;

      barK tick = _getBarKRect(left, right, list[i], rect);

      paint.color = tick.color;
      canvas.drawRect(tick.rect, paint);
      canvas.drawLine(Offset(tick.rect.center.dx, tick.height),
          Offset(tick.rect.center.dx, tick.low), paint);

      if (-1 != nIdx && i == nIdx) {
        Paint paintLine = Paint()
          ..color = Colors.yellow
          ..strokeWidth = 0.3;
        canvas.drawLine(Offset(tick.rect.center.dx, rect.bottom),
            Offset(tick.rect.center.dx, rect.top), paintLine);
      }
    }
  }

  _drawAngLine(Canvas canvas, Rect rect) {
    Paint paint;
    paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0;

    List<double> listAvg;
    Offset offsetPre, offsetNow;
    double left = 0.0, right = 0.0;
    double dbGap = rect.width / _nViewCount;

    for (int i = 0; i < 3; i++) {
      switch (i) {
        case 0:
          paint.color = Colors.yellow;
          listAvg = _listAvg5;
          break;
        case 1:
          paint.color = Colors.purpleAccent;
          listAvg = _listAvg20;
          break;
        case 2:
          paint.color = Colors.lightBlueAccent;
          listAvg = _listAvg60;
          break;
      }

      for (int j = nStart; j <= nEnd; j++) {
        if (j >= listAvg.length) break;

        if (nStart == j && j != 0)
          offsetPre = Offset(rect.left, _getYValue(listAvg[j - 1], rect));
        else if (nStart == j && j == 0)
          offsetPre = Offset(rect.left, _getYValue(listAvg[j], rect));

        if (j == nStart)
          left = rect.left;
        else
          left = rect.left + (j - nStart) * dbGap;

        right = rect.left + (j + 1 - nStart) * dbGap;

        offsetNow = Offset((left + right) / 2, _getYValue(listAvg[j], rect));

        canvas.drawLine(offsetPre, offsetNow, paint);
        offsetPre = offsetNow;
      }
    }
  }

  void _drawMinTimeX(int nMin, Rect rect, Canvas canvas) {
    Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 0.3;

    String stringNow;
    String stringPre;
    double left = 0.0, right = 0.0;
    double dbGap = rect.width / _nViewCount;

    for (int i = nStart; i <= nEnd; i++) {
      if (i == nStart) stringPre = list[i].date;

      stringNow = list[i].date;

      if (stringNow != stringPre) {
        if (i == nStart)
          left = rect.left;
        else
          left = rect.left + (i - nStart) * dbGap;

        right = rect.left + (i + 1 - nStart) * dbGap;

        TextSpan span = new TextSpan(
          style: new TextStyle(
            color: Colors.yellow,
            fontSize: dbFontSize,
          ),
          text: stringNow.substring(5),
        );

        TextPainter tp = new TextPainter(
            text: span,
            textAlign: TextAlign.right,
            textDirection: TextDirection.ltr);
        tp.layout();

        if (bShowTime)
          tp.paint(canvas, Offset((right + left) / 2, rect.bottom));
        canvas.drawLine(Offset(left + (right - left) / 2, rect.bottom),
            Offset(left + (right - left) / 2, rect.top), paint);
        stringPre = stringNow;
      }
    }
  }

  void _drawDayTimeX(int nDay, Rect rect, Canvas canvas) {
    Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 0.3;

    String stringNow;
    String stringPre;
    double left = 0.0, right = 0.0;
    double dbGap = rect.width / _nViewCount;
    int nDateEnd;

    switch (nDay) {
      case 1:
        nDateEnd = 7;
        break;
      case 7:
        nDateEnd = 7;
        break;
      case 30:
        nDateEnd = 7;
        break;
      case 90:
        nDateEnd = 5;
        break;
      default:
        nDateEnd = 7;
        break;
    }

    for (int i = nStart; i <= nEnd; i++) {
      if (i >= _nTickCount) break;

      if (i == nStart) stringPre = list[i].date;

      stringNow = list[i].date;

      if (stringNow.substring(0, nDateEnd) !=
          stringPre.substring(0, nDateEnd)) {
        if (i == nStart)
          left = rect.left;
        else
          left = rect.left + (i - nStart) * dbGap;

        right = rect.left + (i + 1 - nStart) * dbGap;

        TextSpan span = new TextSpan(
          style: new TextStyle(
            color: Colors.yellow,
            fontSize: dbFontSize,
          ),
          text: nDay == 90 ? stringNow.substring(0, 7) : stringNow.substring(5),
        );

        TextPainter tp = new TextPainter(
            text: span,
            textAlign: TextAlign.right,
            textDirection: TextDirection.ltr);
        tp.layout();

        if (bShowTime) {
          if ((right + left) / 2 + tp.width >= rect.right)
            tp.paint(
                canvas, Offset((right + left) / 2 - tp.width / 2, rect.bottom));
          else
            tp.paint(canvas, Offset((right + left) / 2, rect.bottom));
        }
        canvas.drawLine(Offset(left + (right - left) / 2, rect.bottom),
            Offset(left + (right - left) / 2, rect.top), paint);
        stringPre = stringNow;
      }
    }
  }

  void _drawTimeX(Canvas canvas, Rect rect) {
    switch (currentDataType) {
      case "1分":
        _drawMinTimeX(1, rect, canvas);
        break;
      case "5分":
        _drawMinTimeX(5, rect, canvas);
        break;
      case "15分":
        _drawMinTimeX(15, rect, canvas);
        break;
      case "30分":
        _drawMinTimeX(30, rect, canvas);
        break;
      case "60分":
        _drawMinTimeX(60, rect, canvas);
        break;
      case "日":
        _drawDayTimeX(1, rect, canvas);
        break;
      case "周":
        _drawDayTimeX(7, rect, canvas);
        break;
      case "月":
        _drawDayTimeX(30, rect, canvas);
        break;
      case "季":
        _drawDayTimeX(90, rect, canvas);
        break;
      case "還":
        _drawDayTimeX(1, rect, canvas);
        break;
      default:
        _drawDayTimeX(1, rect, canvas);
        break;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    if (nEnd == 0 ||
        nStart < 0 ||
        nStart > list.length ||
        nEnd > list.length ||
        _nTickCount != list.length) _update(size);

    canvas.save();
    _drawMainLine(canvas, _rectKLine);
    _drawYLine(canvas, _rectKLine, _dbHighPrice, _dbLowPrice, 5);
    _drawKLine(canvas, _rectKLine);
    _drawAngLine(canvas, _rectKLine);
    _drawTimeX(canvas, _rectKLine);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_KLinePainter oldDelegate) {
    // TODO: implement shouldRepaint
    return (oldDelegate.list.length != this.list.length ||
        oldDelegate.nTickWidth != this.nTickWidth ||
        oldDelegate.nStart != this.nStart ||
        oldDelegate.nEnd != this.nEnd);
  }
}

class barK {
  Rect rect;
  double height;
  double low;
  Color color;

  barK(this.rect, this.height, this.low, this.color);
}
