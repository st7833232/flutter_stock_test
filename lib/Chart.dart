import 'package:flutter/material.dart';
import 'package:flutter_stock_test/ChartSparkline.dart';
import 'package:flutter_stock_test/TickPriceValue.dart';
import 'package:flutter_stock_test/CommonFuction.dart';
import 'package:flutter_stock_test/IndicatorView.dart';
import 'package:flutter_stock_test/KLineView.dart';
import 'dart:math';
import 'package:intl/intl.dart' as intl;

const List<String> _itemList = <String>[
  "分時",
  "價量",
  "K線",
  "指標",
  "法人",
  "籌碼",
  "權證",
  "新聞",
  "大戶",
  "營收",
  "獲利",
  "財務",
  "基本資料",
  "除權息",
];

class StockChart extends StatefulWidget {
  StockChart({Key key, this.strSymbolName, this.symbolList}) : super(key: key);

  String strSymbolName;
  List<String> symbolList;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StockChart(strSymbolName, symbolList);
  }
}

class _StockChart extends State<StockChart>
    with SingleTickerProviderStateMixin {
  _StockChart(this._symbolName, this._symbolList);

  String _symbolName;
  List<String> _symbolList;
  TabController _controller;
  List<double> listUpPrice;
  List<double> listDownPrice;
  List<double> listPrice;
  List<String> listTime;
  List<TickData> listTick = new List();

  ChartSparkLine m_pChart;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(vsync: this, length: _itemList.length);

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

    var time = DateTime.utc(2019, 05, 27, 09, 00, 00);
    String strTime;
    double dbPrice = 0.0, dbBuy = 0.0, dbSell = 0.0, dbOpen = 0.0, dbHigh = 0.0, dbLow = 0.0;
    for (int i = 0;
    i < getTotalTickCount(listTime[0], listTime[listTime.length - 1]);
    i++) {
      strTime = intl.DateFormat("HH:mm").format(time);
      dbPrice = 0.0;

      while (true) {
        dbPrice =
            Random.secure().nextInt(85) + (Random.secure().nextInt(100) / 100);
        if (dbPrice > 71.0 /*listPrice[2]*/ && dbPrice < 75.0 /*listPrice[0]*/)
          break;
      }

      while (true) {
        dbOpen =
            Random.secure().nextInt(85) + (Random.secure().nextInt(100) / 100);
        if (dbOpen > 71.0 /*listPrice[2]*/ && dbOpen < 75.0 /*listPrice[0]*/)
          break;
      }

      while (true) {
        dbHigh =
            Random.secure().nextInt(85) + (Random.secure().nextInt(100) / 100);
        if (dbHigh > 71.0 /*listPrice[2]*/ && dbHigh < 75.0 /*listPrice[0]*/ && dbHigh >= dbPrice)
          break;
      }

      while (true) {
        dbLow =
            Random.secure().nextInt(85) + (Random.secure().nextInt(100) / 100);
        if (dbLow > 71.0 /*listPrice[2]*/ && dbLow < 75.0 /*listPrice[0]*/ && dbLow <= dbPrice)
          break;
      }

      while (true) {
        dbBuy =
            Random.secure().nextInt(85) + (Random.secure().nextInt(100) / 100);
        if (dbBuy > 71.0 /*listPrice[2]*/ && dbBuy < 75.0 /*listPrice[0]*/)
          break;
      }

      while (true) {
        dbSell =
            Random.secure().nextInt(85) + (Random.secure().nextInt(100) / 100);
        if (dbSell > 71.0 /*listPrice[2]*/ && dbSell < 75.0 /*listPrice[0]*/)
          break;
      }

      time = time.add(new Duration(minutes: 1));

      listTick.add(TickData(strTime, dbOpen, dbHigh, dbLow, dbPrice, dbBuy, dbSell,
          Random.secure().nextInt(100), Random.secure().nextBool()));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "個股資訊",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onPressed: null),
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: null),
        ],
      ),
      body: _getStockInfo(),
    );
  }

  void printTest() {
    print("Test");
  }

  Widget _getStockInfo() {
    Widget obj;

    obj = Column(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: _getMemInfo(),
        ),
        Expanded(
          flex: 28,
          child: _getTabView(_controller),
        ),
        Expanded(flex: 2, child: _getBottomItem()),
      ],
    );

    return obj;
  }

  Widget _getMemInfo() {
    Widget obj;

    double dbPrice = listTick.last.price;
    Color color = Colors.grey;
    double dbRadio = ((dbPrice - listPrice[1]).abs()) / listPrice[1];
    String strRadio;

    color = getPriceColor(dbPrice, listPrice[1]);

    if (dbPrice > listPrice[1]) {
      strRadio = "▲" + (dbPrice - listPrice[1]).abs().toStringAsFixed(2);
    } else if (dbPrice < listPrice[1]) {
      strRadio = "▼" + (dbPrice - listPrice[1]).abs().toStringAsFixed(2);
    }

    obj = Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: IconButton(
              alignment: Alignment.centerLeft,
              iconSize: 60,
              icon: Icon(
                _symbolList != null ? Icons.arrow_left : null,
                color: Colors.white,
              ),
              onPressed: null),
        ),
        Expanded(
          flex: 2,
          child: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    width: 80,
                    child: Text(
                      _symbolName,
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Text(
                          "市",
                          style: TextStyle(
                              color: Colors.white,
                              backgroundColor: Colors.purple),
                        ),
                      ),
                      Container(
                        child: Text(
                          "6214",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            child: Card(
              color: Colors.black,
              child: Text(
                "$dbPrice",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: 30.0,
                ),
              ),
            ),
            //),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.black,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    width: 80,
                    child: Center(
                      child: Text(
                        strRadio,
                        style: TextStyle(color: color, fontSize: 20.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      (dbRadio * 100).toStringAsFixed(2).toString() + "%",
                      style: TextStyle(color: color, fontSize: 22.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: IconButton(
              alignment: Alignment.centerRight,
              iconSize: 60,
              icon: Icon(
                _symbolList != null ? Icons.arrow_right : null,
                color: Colors.white,
              ),
              onPressed: null),
        ),
      ],
    );

    return obj;
  }

  Widget _getTabView(TabController controller) {
    Widget obj;

    obj = Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.sort,
              color: Colors.white,
              size: 50.0,
            ),
            onPressed: null),
        backgroundColor: Colors.black,
        title: TabBar(
          controller: controller,
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: TextStyle(fontSize: 15.0),
          tabs: _itemList.map<Tab>((String item) {
            return Tab(text: item);
          }).toList(),
        ),
      ),
      body: new TabBarView(
        controller: controller,
        children: _itemList.map<Widget>((String item) {
          return _getTabViewItem(item);
        }).toList(),
      ),
    );

    return obj;
  }

  Widget _getBottomItem() {
    Widget obj;

    obj = Row(
      children: <Widget>[
        Expanded(
          child: FlatButton.icon(
            onPressed: printTest,
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            label: Text("Share", style: TextStyle(color: Colors.white)),
          ),
        ),
        Expanded(
          child: FlatButton.icon(
            onPressed: printTest,
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.white,
            ),
            label: Text("自選", style: TextStyle(color: Colors.white)),
          ),
        ),
        Expanded(
          child: FlatButton.icon(
            onPressed: printTest,
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            label: Text("下單", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );

    return obj;
  }

  Widget _getTabViewItem(String strItem) {
    Widget obj;

    switch (strItem) {
      case '分時':
        obj = Container(
          color: Colors.black,
          child: m_pChart = ChartSparkLine(
            symbolName: _symbolName,
            listUpPrice: listUpPrice,
            listDownPrice: listDownPrice,
            listPrice: listPrice,
            listTime: listTime,
            listTick: listTick,
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height * 0.32),
            padding: EdgeInsets.all(0.0),
          ),
        );
        break;
      case '價量':
        obj = Container(
          color: Colors.black,
          child: TickPriceValueView(listTick, listPrice[1]),
        );
        break;
      case '指標':
        obj = Container(
          color: Colors.black,
          child: IndicatorView(),
        );
        break;
      case 'K線':
        obj = Container(
          color: Colors.black,
          child: KLineView(listPrice[1]),
        );
        break;
      default:
        obj = Container(
          color: Colors.black,
          child: Icon(
            Icons.directions_car,
            size: 50.0,
            color: Colors.white,
          ),
        );
        break;
    }

    return obj;
  }
}
