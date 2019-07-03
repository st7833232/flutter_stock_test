import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_stock_test/CommonFuction.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class TickPriceValueView extends StatefulWidget {
  TickPriceValueView(
    this.listTick,
    this.dbYPrice, {
    Key key,
  }) : super(key: key);

  List<TickData> listTick;
  double dbYPrice;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TickPriceValueView(listTick, dbYPrice);
  }
}

class _TickPriceValueView extends State<TickPriceValueView>
    with AutomaticKeepAliveClientMixin {
  _TickPriceValueView(this.listTick, this.dbYPrice);

  int nFocus;
  List<TickData> listTick;
  double dbYPrice;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nFocus = 0;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  onPressed: nFocus == 0
                      ? null
                      : () {
                          setState(() {
                            nFocus = 0;
                          });
                        },
                  child: Text(
                    "分時明細",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue[900],
                  disabledColor: Colors.blue[600],
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                ),
              ),
              Expanded(
                child: FlatButton(
                  onPressed: nFocus == 1
                      ? null
                      : () {
                          setState(() {
                            nFocus = 1;
                          });
                        },
                  child: Text(
                    "分價明細",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue[900],
                  disabledColor: Colors.blue[600],
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 9,
          child: nFocus == 0
              ? TickView(listTick, dbYPrice)
              : ValueView(listTick, dbYPrice),
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class TickView extends StatefulWidget {
  TickView(
    this.listTick,
    this.dbYPrice, {
    Key key,
  }) : super(key: key);

  List<TickData> listTick;
  double dbYPrice;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TickView(listTick, dbYPrice);
  }
}

class _TickView extends State<TickView> {
  _TickView(this.listTick, this.dbYPrice);

  List<TickData> listTick;
  double dbYPrice;
  bool isBottom = true;

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset == 0.0 && isBottom == false) {
        setState(() {
          isBottom = true;
        });
      } else if (_scrollController.offset != 0.0 && isBottom == true) {
        setState(() {
          isBottom = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  Widget _getList() {
    Widget obj = ListView.separated(
      reverse: true,
      controller: _scrollController,
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.white,
        );
      },
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Text(
                      listTick[listTick.length - index - 1].time,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      listTick[listTick.length - index - 1].priceBuy.toString(),
                      style: TextStyle(
                          color: getPriceColor(
                              listTick[listTick.length - index - 1].priceBuy,
                              dbYPrice)),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      listTick[listTick.length - index - 1]
                          .priceSell
                          .toString(),
                      style: TextStyle(
                          color: getPriceColor(
                              listTick[listTick.length - index - 1].priceSell,
                              dbYPrice)),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      listTick[listTick.length - index - 1].price.toString(),
                      style: TextStyle(
                          color: getPriceColor(
                              listTick[listTick.length - index - 1].price,
                              dbYPrice)),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      listTick[index].value.toString(),
                      style: TextStyle(
                          color: listTick[index].isSell
                              ? Colors.green
                              : Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
      itemCount: listTick.length,
    );

    return obj;
  }

  Future<void> _setBottom() async {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Text(
                    '時間',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '買價',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '賣價',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '成交',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '量',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 9,
          child: Scaffold(
            backgroundColor: Colors.black,
            body: _getList(),
            floatingActionButton: !isBottom
                ? FloatingActionButton(
                    mini: true,
                    child: Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _setBottom();
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

class ValueView extends StatefulWidget {
  ValueView(this.listTick, this.dbYPrice, {Key key}) : super(key: key);

  List<TickData> listTick;
  double dbYPrice;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ValueView(listTick, dbYPrice);
  }
}

class _ValueView extends State<ValueView> {
  _ValueView(this.listTick, this.dbYPrice);

  List<TickData> listTick;
  double dbYPrice;
  int valueTotal = 0;

  List<TickData> listSortTick = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sortListTick();
  }

  void _sortListTick() {
    bool isFind = false;
    valueTotal = 0;
    for (int i = 0; i < listTick.length; i++) {
      isFind = false;
      if (listSortTick.length > 0) {
        for (int j = 0; j < listSortTick.length; j++) {
          if (listSortTick[j].price == listTick[i].price) {
            listSortTick[j].value += listTick[i].value;
            isFind = true;
            break;
          }
        }

        if (false == isFind) {
          listSortTick.add(listTick[i]);
        }
      } else {
        listSortTick.add(listTick[i]);
      }

      valueTotal += listTick[i].value;
    }

    listSortTick.sort((a, b) => b.price.compareTo(a.price));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Text(
                    '成交價',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Text(
                    '成交量',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Text(
                    '比例',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 9,
          child: ListView.separated(
              itemBuilder: (context, index) {
                return _getValueDetail(index);
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.white,
                  height: 2,
                );
              },
              itemCount: listSortTick.length),
        ),
      ],
    );
  }

  Widget _getValueDetail(int index) {
    Widget obj;
    String str = '';
    Color color = Colors.white;

    if (listSortTick[index].price == listTick[listTick.length - 1].price) {
      str = '現';
      color = Colors.yellow;
    } else if (0 == index) {
      str = '高';
      color = Colors.red;
    } else if (index == listSortTick.length - 1) {
      str = '低';
      color = Colors.green;
    }

    obj = Container(
      //height: 25,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    str,
                    style: TextStyle(color: color),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      listSortTick[index].price.toString(),
                      style: TextStyle(
                        color:
                            getPriceColor(listSortTick[index].price, dbYPrice),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: Text(
                listSortTick[index].value.toString(),
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Expanded(
            child: LinearPercentIndicator(
              percent: listSortTick[index].value / valueTotal,
              linearStrokeCap: LinearStrokeCap.butt,
              progressColor: Colors.blue,
              backgroundColor: Colors.black,
              lineHeight: 15,
              isRTL: true,
              center: Text(
                ((listSortTick[index].value / valueTotal) * 100)
                        .toStringAsFixed(2) +
                    "%",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );

    return obj;
  }
}
