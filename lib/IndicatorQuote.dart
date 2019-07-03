import 'package:flutter/material.dart';
import 'package:flutter_stock_test/CommonFuction.dart';
import 'dart:math';
import 'package:intl/intl.dart' as intl;

class IndicatorQuote extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _IndicatorQuote();
  }
}

class _IndicatorQuote extends State<IndicatorQuote>
    with AutomaticKeepAliveClientMixin {
  double frontSize = 20.0;
  double numfrontSize = 22.0;

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
            child: ListView.separated(
                itemBuilder: (context, i) {
                  List<String> list = i == 0 ? listTitle : listSymbol;
                  int index = i == 0 ? i : i - 1;

                  if (i == 0) {
                    return Container(
                      height: 30.0,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              list[0],
                              style: TextStyle(color: Colors.white, fontSize: 20.0),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              list[1],
                              style: TextStyle(color: Colors.white, fontSize: 20.0),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              list[4],
                              style: TextStyle(color: Colors.white, fontSize: 20.0),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              list[6],
                              style: TextStyle(color: Colors.white, fontSize: 20.0),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container(height: 30.0, child:  Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            list[index],
                            style: TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            (Random.secure().nextInt(1000) +
                                Random.secure().nextDouble())
                                .toStringAsFixed(2),
                            style: TextStyle(
                                color: Random.secure().nextBool() == true
                                    ? Colors.red
                                    : Colors.green, fontSize: 20.0),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            Random.secure().nextInt(100).toString(),
                            style: TextStyle(color: Colors.yellow, fontSize: 20.0),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            Random.secure().nextInt(100).toString(),
                            style: TextStyle(color: Colors.yellow, fontSize: 20.0),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),);
                  }
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.white,
                    height: 2,
                  );
                },
                itemCount: listSymbol.length + 1),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
