import 'package:flutter/material.dart';
import 'dart:math';
import 'ColumnBuilder.dart';
import 'package:flutter_stock_test/CommonFuction.dart';

class Quote extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Quote();
  }
}

class _Quote extends State<Quote>{
  double frontSize = 20.0;
  double numfrontSize = 26.0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('QuoteTest'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: frontSize * 1.5 * (listSymbol.length + 1),
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: listTitle.length,
                itemBuilder: (BuildContext context, int index1) => SizedBox(
                      width: listTitle[index1].compareTo(SymbolName) == 0
                          ? 80.0
                          : 100.0,
                      child: ColumnBuilder(
                        itemCount: listSymbol.length + 1,
                        itemBuilder: (context, index2) {
                          if (index2 == 0) {
                            return Container(
                              width:
                                  listTitle[index1].compareTo(SymbolName) == 0
                                      ? 80
                                      : 100,
                              child: Text(
                                listTitle[index1],
                                textAlign:
                                    listTitle[index1].compareTo(SymbolName) == 0
                                        ? TextAlign.left
                                        : TextAlign.right,
                                style: TextStyle(fontSize: frontSize),
                              ),
                            );
                          } else {
                            if (listTitle[index1].compareTo(SymbolName) == 0)
                              return Container(
                                width: 80,
                                child: Text(
                                  listSymbol[index2 - 1],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: frontSize),
                                ),
                              );
                            else
                              return Container(
                                width: 100,
                                child: Text(
                                  Random.secure().nextInt(10000).toString(),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: numfrontSize),
                                ),
                              );
                          }
                        },
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
