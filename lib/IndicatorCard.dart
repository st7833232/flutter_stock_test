import 'package:flutter/material.dart';
import 'package:flutter_stock_test/CommonFuction.dart';
import 'dart:math';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_stock_test/Chart.dart';

class indicatorCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _indicatorCard();
  }
}

class _indicatorCard extends State<indicatorCard>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              child: Text(
                "更新時間:" +
                    intl.DateFormat("yyyy/MM/dd HH:mm:ss")
                        .format(DateTime.now()),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            flex: 25,
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              itemCount: listSymbol.length,
              itemBuilder: (context, index) {
                return CardQuote(symbol: listSymbol[index]);
              },
              staggeredTileBuilder: (int index) {
                return StaggeredTile.count(1, 1);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class CardQuote extends StatelessWidget {
  String symbol = '';
  bool bSell = Random.secure().nextBool();

  CardQuote({Key key, this.symbol}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      color: Colors.white,
      child: FlatButton(
        onPressed: () {
          return Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StockChart(strSymbolName: symbol)));
        },
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Text(
                  symbol,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Center(
                child: Text(
                  (Random.secure().nextInt(1000) + Random.secure().nextDouble())
                      .toStringAsFixed(2),
                  style: TextStyle(
                      fontSize: 25.0,
                      color: Random.secure().nextBool() == true
                          ? Colors.red
                          : Colors.green),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  (Random.secure().nextInt(10) + Random.secure().nextDouble())
                          .toStringAsFixed(2) +
                      '%',
                  style: TextStyle(
                      fontSize: 23.0,
                      color: Random.secure().nextBool() == true
                          ? Colors.red
                          : Colors.green),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                width: 200.0,
                child: Center(
                  child: Text(
                    bSell == true ? '籌碼小賣' : '中立',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                decoration: BoxDecoration(
                  color: bSell == true ? Colors.green : Colors.yellow[800],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
