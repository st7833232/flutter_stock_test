import 'package:flutter/material.dart';

const String SymbolName = "商品";

List<String> listTitle = [
  '商品',
  '成交價',
  '最高價',
  '最低價',
  '成交量',
  '單量',
  '成交張數',
];

List<String> listSymbol = [
  "台積電",
  "聯電",
  "台泥",
  "亞泥",
  "精誠",
  "宏達電",
  "大立光",
  "元大",
  "麗台",
  "愛之味",
  "義美",
  "統一",
  "台灣指數",
  "台指期&",
];

Color getPriceColor(double dbPrice, dbComparePrice) {
  Color color = Colors.white;

  if (dbPrice > dbComparePrice)
    color = Colors.red;
  else if (dbPrice < dbComparePrice)
    color = Colors.green;
  else
    color = Colors.white;

  return color;
}

String getPriceString(double dbPrice, dbComparePrice) {
  String price;
  double dbGapPrice = dbPrice - dbComparePrice;
  double dbRadio = (dbGapPrice / dbComparePrice).abs() * 100;

  if (dbGapPrice > 0)
    price = "$dbPrice " +
        "  ▲" +
        dbGapPrice.toStringAsFixed(2) +
        " (" +
        dbRadio.toStringAsFixed(2) +
        "%)";
  else
    price = "$dbPrice " +
        "  ▼" +
        dbGapPrice.toStringAsFixed(2) +
        " (" +
        dbRadio.toStringAsFixed(2) +
        "%)";

  return price;
}

class TickData {
  String time;
  double open;
  double high;
  double low;
  double price;
  double priceBuy;
  double priceSell;
  int value;
  bool isSell;

  TickData(this.time, this.open, this.high, this.low, this.price, this.priceBuy, this.priceSell, this.value,
      this.isSell);
}

class KTickData {
  String date;
  String time;
  double open;
  double high;
  double low;
  double price;
  double priceBuy;
  double priceSell;
  int value;
  bool isSell;

  KTickData(this.date, this.time, this.open, this.high, this.low, this.price, this.priceBuy, this.priceSell, this.value,
      this.isSell);
}

class BSData {
  double price;
  int value;

  BSData(this.price, this.value);
}

class IndicatorData {
  itemType type;
  String item;
  Color color;

  IndicatorData({this.type, this.item, this.color});

  void setData(itemType type, String item, Color color) {
    this.type = type;
    this.item = item;
    this.color = color;
  }
}

enum itemType {
  theme,
  indicator,
  hot,
  single,
}

String getItemTypeString(itemType type) {
  String str = '';
  switch (type) {
    case itemType.theme:
      str = '題材';
      break;
    case itemType.indicator:
      str = '指標';
      break;
    case itemType.hot:
      str = '熱門';
      break;
    case itemType.single:
      str = '訊號';
      break;
  }
  return str;
}

List<DropdownMenuItem<String>> getDropDownMenuItems() {
  List<DropdownMenuItem<String>> items = new List();
  items.add(DropdownMenuItem(
    child: Text('日', style: TextStyle(color: Colors.blue),),
    value: '日',
  ));
  items.add(DropdownMenuItem(
    child: Text('周', style: TextStyle(color: Colors.blue),),
    value: '周',
  ));
  items.add(DropdownMenuItem(
    child: Text('月', style: TextStyle(color: Colors.blue),),
    value: '月',
  ));
  items.add(DropdownMenuItem(
    child: Text('季', style: TextStyle(color: Colors.blue),),
    value: '季',
  ));
  items.add(DropdownMenuItem(
    child: Text('還', style: TextStyle(color: Colors.blue),),
    value: '還',
  ));
  items.add(DropdownMenuItem(
    child: Text('1分', style: TextStyle(color: Colors.blue),),
    value: '1分',
  ));
  items.add(DropdownMenuItem(
    child: Text('5分', style: TextStyle(color: Colors.blue),),
    value: '5分',
  ));
  items.add(DropdownMenuItem(
    child: Text('15分', style: TextStyle(color: Colors.blue),),
    value: '15分',
  ));
  items.add(DropdownMenuItem(
    child: Text('30分', style: TextStyle(color: Colors.blue),),
    value: '30分',
  ));
  items.add(DropdownMenuItem(
    child: Text('60分', style: TextStyle(color: Colors.blue),),
    value: '60分',
  ));

  return items;
}

int getTotalTickCount(String start, String end) {
  int count = 0;

  int Gap = start.indexOf(":");
  int nStartTime = int.parse(start.substring(0, Gap)) * 60 +
      int.parse(start.substring(Gap + 1));
  Gap = end.indexOf(":");
  int nEndTime = int.parse(end.substring(0, Gap)) * 60 +
      int.parse(end.substring(Gap + 1));

  count = nEndTime - nStartTime;

  return count;
}