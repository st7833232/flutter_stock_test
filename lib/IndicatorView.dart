import 'package:flutter/material.dart';
import 'package:flutter_stock_test/CommonFuction.dart';
import 'dart:math';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_stock_test/IndicatorQuoteView.dart';

class IndicatorView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _IndicatorView();
  }
}

class _IndicatorView extends State<IndicatorView>
    with AutomaticKeepAliveClientMixin {
  List<IndicatorData> list = new List();
  String updateTime;
  Color color;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getListData();
    color = Colors.black;
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
                child: Text(
                  "符合" + list.length.toString() + '項指標',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: Text(
                  '資料時間:' + updateTime,
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 9,
          child: RefreshIndicator(
            onRefresh: _getListData,
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return Container(
                    height: 50.0,
                    child: ListTile(
                      title: Text(
                        list[index].item,
                        style: TextStyle(color: list[index].color),
                      ),
                      leading: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        child: Text(
                          getItemTypeString(list[index].type),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => IndicatorQuoteView(list[index].item)));
                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.white,
                    height: 2,
                  );
                },
                itemCount: list.length),
          ),
        ),
      ],
    );
  }

  Future<Null> _getListData() async {
    list.clear();
    int len = Random.secure().nextInt(12);
    for (int i = 0; i < len; i++) {
      IndicatorData indicatorData = new IndicatorData();
      switch (i) {
        case 0:
          indicatorData.setData(itemType.theme, '系統整合', Colors.white);
          break;
        case 1:
          indicatorData.setData(
              itemType.indicator, '近四季有三季速動比>150%', Colors.white);
          break;
        case 2:
          indicatorData.setData(itemType.indicator, '現金殖利率>5%', Colors.red);
          break;
        case 3:
          indicatorData.setData(itemType.indicator, '現金股利>3元', Colors.red);
          break;
        case 4:
          indicatorData.setData(itemType.indicator, '外資連3買', Colors.red);
          break;
        case 5:
          indicatorData.setData(itemType.indicator, '外資連買≧5天', Colors.red);
          break;
        case 6:
          indicatorData.setData(itemType.indicator, '外資近3日持股率增加', Colors.red);
          break;
        case 7:
          indicatorData.setData(itemType.indicator, '股價在月線上&月線上揚', Colors.red);
          break;
        case 8:
          indicatorData.setData(itemType.indicator, '日MACD柱狀體負轉正', Colors.red);
          break;
        case 9:
          indicatorData.setData(itemType.hot, '創新低股', Colors.green);
          break;
        case 10:
          indicatorData.setData(itemType.hot, '股價轉弱股', Colors.green);
          break;
        case 11:
          indicatorData.setData(itemType.hot, '大盤弱勢股', Colors.green);
          break;
      }
      list.add(indicatorData);
    }
    setState(() {
      updateTime = intl.DateFormat("HH:mm:ss").format(DateTime.now());
    });
    return;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
