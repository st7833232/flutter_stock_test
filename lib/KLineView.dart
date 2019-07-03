import 'package:flutter/material.dart';
import 'package:flutter_stock_test/CommonFuction.dart';
import 'package:flutter_stock_test/KLineSpark.dart';

import 'dart:math';
import 'package:intl/intl.dart' as intl;
import 'package:holding_gesture/holding_gesture.dart';

const nTotalMinTickCount = 1000;
const dbTickMaxWidth = 65.0;
const dbTickMinWidth = 1.0;

class KLineView extends StatefulWidget {
  KLineView(this.dbYPrice,
      {Key key, this.dbFontSize = 14.0, this.bShowTime = true})
      : super(key: key);
  double dbYPrice;
  double dbFontSize;
  bool bShowTime;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _KLineView(dbYPrice, dbFontSize, bShowTime);
  }
}

class _KLineView extends State<KLineView> with AutomaticKeepAliveClientMixin {
  _KLineView(this.dbYPrice, this.dbFontSize, this.bShowTime);

  List<double> listUpPrice;
  List<double> listDownPrice;
  List<double> listPrice;
  List<String> listTime;
  double dbYPrice;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String currentDataType;
  KTickData _tickDatatick;
  List<KTickData> _listTick;
  double dbFontSize;
  bool bShowTime;
  KLineSpark TAViewFirst, TAViewSec, TAViewThird;
  int _nTAViewCount = 3;
  int _nTAIdx = -1;
  double _dbTickWidth = 1.0;
  int _nStart = 0;
  int _nEnd = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    _listTick.clear();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    listUpPrice = <double>[
      78,
      76,
      74,
    ];

    listDownPrice = <double>[
      72,
      70,
      68,
    ];

    listPrice = <double>[
      80.1,
      72.9,
      65.7,
    ];

    listTime = <String>[
      '09:00',
      '10:00',
      '11:00',
      '12:00',
      '13:00',
      '13:30',
    ];

    _dropDownMenuItems = getDropDownMenuItems();
    currentDataType = _dropDownMenuItems[0].value;
    _getKLineData(currentDataType);
    _dbTickWidth = 1.0;

    _nStart = 0;
    _nEnd = _listTick.length - 1;
  }

  void _getMinData(int nMin) {
    _nTAIdx = -1;
    List<KTickData> listTick = new List();
    listTick.clear();
    var time = DateTime.utc(2019, 05, 27, 09, 00, 00);
    String strTime, strDate;
    double dbPrice = 0.0,
        dbBuy = 0.0,
        dbSell = 0.0,
        dbOpen = 0.0,
        dbHigh = 0.0,
        dbLow = 0.0;
    int nTickCount =
        getTotalTickCount(listTime[0], listTime[listTime.length - 1]) ~/ nMin;

    if (_listTick != null) {
      _listTick.clear();
    }

    int nMaxDay = nTotalMinTickCount ~/ nTickCount + 1;

    for (int nDay = nMaxDay - 1; nDay >= 0; nDay--) {
      strDate = intl.DateFormat("yyyy/MM/dd")
          .format(DateTime.now().add(Duration(days: -nDay)));

      time = DateTime.utc(2019, 05, 27, 09, 00, 00);

      for (int i = 0; i < nTickCount; i++) {
        strTime = intl.DateFormat("HH:mm").format(time);
        dbPrice = 0.0;

        while (true) {
          dbPrice = Random.secure().nextInt(85) +
              (Random.secure().nextInt(100) / 100);
          if (dbPrice > 71.0 /*listPrice[2]*/ &&
              dbPrice < 75.0 /*listPrice[0]*/) break;
        }

        while (true) {
          dbOpen = Random.secure().nextInt(85) +
              (Random.secure().nextInt(100) / 100);
          if (dbOpen > 71.0 /*listPrice[2]*/ && dbOpen < 75.0 /*listPrice[0]*/)
            break;
        }

        while (true) {
          dbHigh = Random.secure().nextInt(85) +
              (Random.secure().nextInt(100) / 100);
          if (dbHigh > 71.0 /*listPrice[2]*/ &&
              dbHigh < 75.0 /*listPrice[0]*/ &&
              dbHigh >= dbPrice) break;
        }

        while (true) {
          dbLow = Random.secure().nextInt(85) +
              (Random.secure().nextInt(100) / 100);
          if (dbLow > 71.0 /*listPrice[2]*/ &&
              dbLow < 75.0 /*listPrice[0]*/ &&
              dbLow <= dbPrice) break;
        }

        while (true) {
          dbBuy = Random.secure().nextInt(85) +
              (Random.secure().nextInt(100) / 100);
          if (dbBuy > 71.0 /*listPrice[2]*/ && dbBuy < 75.0 /*listPrice[0]*/)
            break;
        }

        while (true) {
          dbSell = Random.secure().nextInt(85) +
              (Random.secure().nextInt(100) / 100);
          if (dbSell > 71.0 /*listPrice[2]*/ && dbSell < 75.0 /*listPrice[0]*/)
            break;
        }

        time = time.add(new Duration(minutes: nMin));

        listTick.add(KTickData(
            strDate,
            strTime,
            dbOpen,
            dbHigh,
            dbLow,
            dbPrice,
            dbBuy,
            dbSell,
            Random.secure().nextInt(100),
            Random.secure().nextBool()));
      }
    }

    _listTick = listTick;
  }

  void _getDayData(int nDay) {
    var time = DateTime.utc(2019, 05, 27, 13, 30, 00);
    String strTime, strDate;
    double dbPrice = 0.0,
        dbBuy = 0.0,
        dbSell = 0.0,
        dbOpen = 0.0,
        dbHigh = 0.0,
        dbLow = 0.0;

    if (_listTick != null) {
      _listTick.clear();
    }

    List<KTickData> listTick = new List();
    listTick.clear();

    for (int i = 0; i < nTotalMinTickCount; i++) {
      strTime = intl.DateFormat("HH:mm").format(time);
      dbPrice = 0.0;
      dbBuy = 0.0;
      dbSell = 0.0;
      dbOpen = 0.0;
      dbHigh = 0.0;
      dbLow = 0.0;

      while (true) {
        dbPrice =
            Random.secure().nextInt(85) + (Random.secure().nextInt(100) / 100);
        if (dbPrice > listPrice[2] && dbPrice < listPrice[0]) break;
      }

      while (true) {
        dbOpen =
            Random.secure().nextInt(85) + (Random.secure().nextInt(100) / 100);
        if (dbOpen > listPrice[2] && dbOpen < listPrice[0]) break;
      }

      while (true) {
        dbHigh =
            Random.secure().nextInt(85) + (Random.secure().nextInt(100) / 100);
        if (dbHigh > listPrice[2] && dbHigh < listPrice[0] && dbHigh >= dbPrice)
          break;
      }

      while (true) {
        dbLow =
            Random.secure().nextInt(85) + (Random.secure().nextInt(100) / 100);
        if (dbLow > listPrice[2] && dbLow < listPrice[0] && dbLow <= dbPrice)
          break;
      }

      while (true) {
        dbBuy =
            Random.secure().nextInt(85) + (Random.secure().nextInt(100) / 100);
        if (dbBuy > listPrice[2] && dbBuy < listPrice[0]) break;
      }

      while (true) {
        dbSell =
            Random.secure().nextInt(85) + (Random.secure().nextInt(100) / 100);
        if (dbSell > listPrice[2] && dbSell < listPrice[0]) break;
      }

      strDate = intl.DateFormat("yyyy/MM/dd").format(DateTime.now()
          .add(Duration(days: -(nTotalMinTickCount - i - 1) * nDay)));

      listTick.add(KTickData(
          strDate,
          strTime,
          dbOpen,
          dbHigh,
          dbLow,
          dbPrice,
          dbBuy,
          dbSell,
          Random.secure().nextInt(100),
          Random.secure().nextBool()));
    }
    _listTick = listTick;
  }

  void _getKLineData(String dataType) {
    switch (dataType) {
      case '1分':
        _getMinData(1);
        break;
      case '5分':
        _getMinData(5);
        break;
      case '15分':
        _getMinData(15);
        break;
      case '30分':
        _getMinData(30);
        break;
      case '60分':
        _getMinData(60);
        break;
      case '日':
        _getDayData(1);
        break;
      case '周':
        _getDayData(7);
        break;
      case '月':
        _getDayData(30);
        break;
      case '季':
        _getDayData(90);
        break;
      case '還':
        _getDayData(1);
        break;
    }
  }

  Widget _getTAView() {
    Widget obj;

    if (TAViewFirst != null) {
      TAViewFirst = null;
    }

    if (TAViewSec != null) {
      TAViewSec = null;
    }

    if (TAViewThird != null) {
      TAViewThird = null;
    }

    if (_nTAViewCount > 0 && _nTAViewCount < 4) {
      switch (_nTAViewCount) {
        case 1:
          obj = Column(
            children: <Widget>[
              Expanded(
                child: TAViewFirst = KLineSpark(
                  _listTick,
                  currentDataType,
                  dbFontSize: 15,
                  bShowTime: bShowTime,
                  nIdx: _nTAIdx,
                  nTickWidth: _dbTickWidth,
                  nStart: _nStart,
                  nEnd: _nEnd,
                ),
              ),
            ],
          );
          break;
        case 2:
          obj = Column(
            children: <Widget>[
              Expanded(
                flex: 13,
                child: TAViewFirst = KLineSpark(
                  _listTick,
                  currentDataType,
                  dbFontSize: 15,
                  bShowTime: false,
                  nIdx: _nTAIdx,
                  nTickWidth: _dbTickWidth,
                  nStart: _nStart,
                  nEnd: _nEnd,
                ),
              ),
              Expanded(
                flex: 11,
                child: TAViewSec = KLineSpark(
                  _listTick,
                  currentDataType,
                  dbFontSize: 15,
                  bShowTime: bShowTime,
                  nIdx: _nTAIdx,
                  nTickWidth: _dbTickWidth,
                  nStart: _nStart,
                  nEnd: _nEnd,
                ),
              ),
            ],
          );
          break;
        case 3:
          obj = Column(
            children: <Widget>[
              Expanded(
                flex: 10,
                child: TAViewFirst = KLineSpark(
                  _listTick,
                  currentDataType,
                  dbFontSize: 11,
                  bShowTime: false,
                  nIdx: _nTAIdx,
                  nTickWidth: _dbTickWidth,
                  nStart: _nStart,
                  nEnd: _nEnd,
                ),
              ),
              Expanded(
                flex: 7,
                child: TAViewSec = KLineSpark(
                  _listTick,
                  currentDataType,
                  dbFontSize: 11,
                  bShowTime: false,
                  nIdx: _nTAIdx,
                  nTickWidth: _dbTickWidth,
                  nStart: _nStart,
                  nEnd: _nEnd,
                ),
              ),
              Expanded(
                flex: 8,
                child: TAViewThird = KLineSpark(
                  _listTick,
                  currentDataType,
                  dbFontSize: 11,
                  bShowTime: bShowTime,
                  nIdx: _nTAIdx,
                  nTickWidth: _dbTickWidth,
                  nStart: _nStart,
                  nEnd: _nEnd,
                ),
              ),
            ],
          );
          break;
      }
    }
    return obj;
  }

  void getRectIdx(Offset offset) {
    int nIdx1 = -1, nIdx2 = -1, nIdx3 = -1;
    int nResult = -1;

    if (null != TAViewFirst) {
      nIdx1 = TAViewFirst.getRectIdx(offset);
    }

    if (null != TAViewSec) {
      nIdx2 = TAViewSec.getRectIdx(offset);
    }

    if (null != TAViewThird) {
      nIdx3 = TAViewThird.getRectIdx(offset);
    }

    if (-1 != nIdx1)
      nResult = nIdx1;
    else if (-1 != nIdx2)
      nResult = nIdx2;
    else if (-1 != nIdx3)
      nResult = nIdx3;
    else
      nResult = -1;

    setState(() {
      _nTAIdx = nResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: _getTitleBar(),
        ),
        Expanded(
          flex: 1,
          child: _getTickMem(),
        ),
        Expanded(
          flex: 22,
          child: GestureDetector(
            onTapUp: (TapUpDetails detail) {
              getRectIdx(detail.globalPosition);
            },
            onVerticalDragStart: (details) {
              getRectIdx(details.globalPosition);
            },
            onVerticalDragUpdate: (details) {
              if (details.delta.dy < 0) {
                _changeTickWidth(true);
              } else if (details.delta.dy > 0) {
                _changeTickWidth(false);
              }
            },
            child: _getTAView(),
          ),
        ),
      ],
    );
  }

  Widget _getTickMem() {
    Widget obj;
    if (_listTick.isNotEmpty) {
      if (_nTAIdx < 0 || _nTAIdx >= _listTick.length)
        _tickDatatick = _listTick[_listTick.length - 1];
      else
        _tickDatatick = _listTick[_nTAIdx];

      String strTime =
          true == currentDataType.contains('分') ? _tickDatatick.time : '';

      obj = Row(
        children: <Widget>[
          Expanded(
            flex: 40,
            child: Text(
              _tickDatatick.date + " " + strTime,
              style: TextStyle(color: Colors.yellow, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 20,
            child: Row(
              children: <Widget>[
                Text(
                  '開:',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  _tickDatatick.open.toString(),
                  style: TextStyle(
                      color: getPriceColor(_tickDatatick.open, dbYPrice)),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 20,
            child: Row(
              children: <Widget>[
                Text(
                  '高:',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  _tickDatatick.high.toString(),
                  style: TextStyle(
                      color: getPriceColor(_tickDatatick.high, dbYPrice)),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 20,
            child: Row(
              children: <Widget>[
                Text(
                  '低:',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  _tickDatatick.low.toString(),
                  style: TextStyle(
                      color: getPriceColor(_tickDatatick.low, dbYPrice)),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 20,
            child: Row(
              children: <Widget>[
                Text(
                  '收:',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  _tickDatatick.price.toString(),
                  style: TextStyle(
                      color: getPriceColor(_tickDatatick.price, dbYPrice)),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return obj;
  }

  void _changeTickWidth(bool isUp) {
    double dbTmp = _dbTickWidth;
    bool bReDraw = false;

    if (isUp) {
      if (dbTmp < dbTickMaxWidth) {
        if ((45 <= dbTmp)) {
          dbTmp += 20;
        } else if (25 <= dbTmp) {
          dbTmp += 10;
        } else if (10 <= dbTmp) {
          dbTmp += 5;
        } else {
          dbTmp++;
        }
        bReDraw = true;
      }
    } else {
      if (dbTmp > dbTickMinWidth) {
        if ((45 <= dbTmp))
          dbTmp -= 20;
        else if (25 <= dbTmp)
          dbTmp -= 10;
        else if (10 <= dbTmp)
          dbTmp -= 5;
        else
          dbTmp--;
        bReDraw = true;
      }
    }

    if (bReDraw) {
      setState(() {
        _dbTickWidth = dbTmp;
      });
    }
  }

  Widget _getTitleBar() {
    Widget obj = Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            child: Text(
              "週期:",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: DropdownButton(
            items: _dropDownMenuItems,
            onChanged: (String newValue) {
              setState(() {
                currentDataType = newValue;
                _getKLineData(currentDataType);
              });
            },
            value: currentDataType,
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            iconSize: 20.0,
            color: Colors.blue,
            disabledColor: Colors.grey,
            icon: Icon(
              Icons.close,
            ),
            onPressed: _nTAIdx == -1
                ? null
                : () {
                    setState(() {
                      _nTAIdx = -1;
                    });
                  },
          ),
        ),
        Expanded(
          flex: 1,
          child: HoldDetector(
            onHold: () {
              _changeTickWidth(true);
            },
            enableHapticFeedback: true,
            child: IconButton(
              iconSize: 20.0,
              color: Colors.blue,
              disabledColor: Colors.grey,
              icon: Icon(
                Icons.add,
              ),
              onPressed: _dbTickWidth >= dbTickMaxWidth
                  ? null
                  : () {
                      _changeTickWidth(true);
                    },
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: HoldDetector(
            onHold: () {
              if (_dbTickWidth > dbTickMinWidth) {
                _changeTickWidth(false);
              }
            },
            enableHapticFeedback: true,
            child: IconButton(
              iconSize: 20.0,
              color: Colors.blue,
              disabledColor: Colors.grey,
              icon: Icon(
                Icons.remove,
              ),
              onPressed: _dbTickWidth == dbTickMinWidth
                  ? null
                  : () {
                      _changeTickWidth(false);
                    },
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: HoldDetector(
            onHold: () {
              if (_nTAIdx > 0) {
                setState(() {
                  _nStart = TAViewFirst.getTaViewStart();
                  _nEnd = TAViewFirst.getTaViewEnd();
                  _nTAIdx--;
                });
              } else if (_nTAIdx == -1 && _nStart > 0) {
                setState(() {
                  _nStart = TAViewFirst.getTaViewStart() -
                      TAViewFirst.getTaViewCount() ~/ 2;
                  _nEnd = TAViewFirst.getTaViewEnd() -
                      TAViewFirst.getTaViewCount() ~/ 2;
                });
              }
            },
            enableHapticFeedback: true,
            holdTimeout: Duration(milliseconds: 10),
            child: IconButton(
                iconSize: 20.0,
                color: Colors.blue,
                disabledColor: Colors.grey,
                icon: Icon(
                  Icons.chevron_left,
                ),
                onPressed:
                    ((_nTAIdx == -1 && null != TAViewFirst && _nStart <= 0) ||
                            _nTAIdx == 0)
                        ? null
                        : () {
                            if (_nTAIdx >= 0) {
                              setState(() {
                                _nStart = TAViewFirst.getTaViewStart();
                                _nEnd = TAViewFirst.getTaViewEnd();
                                _nTAIdx--;
                              });
                            } else if (_nTAIdx == -1) {
                              setState(() {
                                _nStart = TAViewFirst.getTaViewStart() -
                                    TAViewFirst.getTaViewCount() ~/ 2;
                                _nEnd = TAViewFirst.getTaViewEnd() -
                                    TAViewFirst.getTaViewCount() ~/ 2;
                              });
                            }
                          }),
          ),
        ),
        Expanded(
          flex: 1,
          child: HoldDetector(
            onHold: () {
              if (_nTAIdx < _listTick.length - 1 &&
                  _nTAIdx >= 0 &&
                  null != TAViewFirst) {
                setState(() {
                  _nStart = TAViewFirst.getTaViewStart();
                  _nEnd = TAViewFirst.getTaViewEnd();
                  _nTAIdx++;
                });
              } else if (_nTAIdx == -1 &&
                  _nEnd < _listTick.length - 1 &&
                  null != TAViewFirst) {
                setState(() {
                  _nStart = TAViewFirst.getTaViewStart() +
                      TAViewFirst.getTaViewCount() ~/ 2;
                  _nEnd = TAViewFirst.getTaViewEnd() +
                      TAViewFirst.getTaViewCount() ~/ 2;
                });
              }
            },
            enableHapticFeedback: true,
            holdTimeout: Duration(milliseconds: 10),
            child: IconButton(
              iconSize: 20.0,
              color: Colors.blue,
              disabledColor: Colors.grey,
              icon: Icon(
                Icons.chevron_right,
              ),
              onPressed: (null == TAViewFirst ||
                      (_nTAIdx == -1 && _nEnd >= _listTick.length - 1) ||
                      _nTAIdx >= _listTick.length - 1)
                  ? null
                  : () {
                      if (_nTAIdx >= 0) {
                        setState(() {
                          _nStart = TAViewFirst.getTaViewStart();
                          _nEnd = TAViewFirst.getTaViewEnd();
                          _nTAIdx++;
                        });
                      } else if (_nTAIdx == -1) {
                        setState(() {
                          _nStart = TAViewFirst.getTaViewStart() +
                              TAViewFirst.getTaViewCount() ~/ 2;
                          _nEnd = TAViewFirst.getTaViewEnd() +
                              TAViewFirst.getTaViewCount() ~/ 2;
                        });
                      }
                    },
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            iconSize: 20.0,
            color: Colors.blue,
            disabledColor: Colors.grey,
            icon: Icon(
              Icons.last_page,
            ),
            onPressed: (_nTAIdx < _listTick.length - 1 && _nTAIdx >= 0 ||
                    (_nTAIdx == -1 && _nEnd < _listTick.length - 1))
                ? () {
                    if (_nTAIdx == -1 && _nEnd < _listTick.length - 1) {
                      setState(() {
                        _nEnd = _listTick.length - 1;
                        _nStart = _nEnd - TAViewFirst.getTaViewCount();
                      });
                    } else {
                      setState(() {
                        _nTAIdx = _listTick.length - 1;
                        _nEnd = _listTick.length - 1;
                        _nStart = _nEnd - TAViewFirst.getTaViewCount();
                      });
                    }
                  }
                : null,
          ),
        ),
        Expanded(
          flex: 1,
          child: FlatButton(
            onPressed: () {
              print('設定');
            },
            child: Text(
              "設",
              style: TextStyle(color: Colors.white, fontSize: 15.0),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: FlatButton(
            onPressed: () {
              print('全螢幕');
            },
            child: Text(
              "全",
              style: TextStyle(color: Colors.white, fontSize: 15.0),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
    return obj;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
