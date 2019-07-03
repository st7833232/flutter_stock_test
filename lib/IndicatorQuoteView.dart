import 'package:flutter/material.dart';
import 'package:flutter_stock_test/IndicatorQuote.dart';
import 'package:flutter_stock_test/IndicatorCard.dart';

class IndicatorQuoteView extends StatefulWidget {
  String title;

  IndicatorQuoteView(this.title, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _IndicatorQuoteView();
  }
}

class _IndicatorQuoteView extends State<IndicatorQuoteView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<String> _listItem = new List();
  String addString = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listItem.add("QuoteView");
    _listItem.add("CardView");
    _tabController = new TabController(length: _listItem.length, vsync: this);
    _tabController.addListener(_changeTitle);
  }

  void _changeTitle() {
    if (_tabController.index == 0) {
      setState(() {
        addString = "";
      });
    } else if (_tabController.index == 1) {
      setState(() {
        addString = "(盤後)";
      });
    }
  }

  Widget _getTabViewItem(String item) {
    Widget obj;

    switch (item) {
      case 'QuoteView':
        obj = IndicatorQuote();
        break;
      case 'CardView':
        obj = indicatorCard();
        break;
    }

    return obj;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(widget.title + addString),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: PreferredSize(
              child: Container(
                color: Colors.black,
                height: 48.0,
                alignment: Alignment.center,
                child: new TabPageSelector(controller: _tabController),
              ),
              preferredSize: const Size.fromHeight(48.0),
            ),
          ),
          Expanded(
            flex: 24,
            child: Container(
              child: TabBarView(
                  controller: _tabController,
                  children: _listItem.map<Widget>((String item) {
                    return _getTabViewItem(item);
                  }).toList()),
            ),
          ),
        ],
      ),
    );
  }
}
