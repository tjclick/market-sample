import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../components/manor_temperature_widget.dart';

class DetailContextView extends StatefulWidget {
  Map<String, String> data;
  DetailContextView({Key? key, required this.data}) : super(key: key);

  @override
  _DetailContextViewState createState() => _DetailContextViewState();
}

class _DetailContextViewState extends State<DetailContextView> {
  Size? size;
  late List<String> imgList;
  int? _current;
  bool isMyFavoriteContent = false;

  @override
  void initState() {
    super.initState();
    imgList = [
      widget.data["image"] as String,
      widget.data["image"] as String,
      widget.data["image"] as String,
      widget.data["image"] as String,
      widget.data["image"] as String,
    ];
    _current = 0;
  }

  @override
  void didChangeDendencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white)),
      actions: [
        IconButton(
            onPressed: () {}, icon: Icon(Icons.share), color: Colors.black),
        IconButton(
            onPressed: () {}, icon: Icon(Icons.more_vert), color: Colors.black),
      ],
    );
  }

  double get screenWidth => size == null ? 400 : size!.width;

  Widget _makeSliderimage() {
    return Container(
      child: Stack(
        children: [
          Hero(
            tag: widget.data["cid"]!,
            child: CarouselSlider(
              options: CarouselOptions(
                  height: screenWidth,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: imgList.map((i) {
                return Container(
                  width: screenWidth,
                  height: screenWidth,
                  color: Colors.red,
                  child: Image.asset(
                    widget.data["image"] as String,
                    fit: BoxFit.fill,
                  ),
                );
              }).toList(),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(imgList.length, (index) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sellerSimpleInfo() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: Image.asset("assets/images/user.png").image,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Seller Seungyong,Yun",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text("Banpo, SeoCho, Seoul"),
            ],
          ),
          Expanded(
            child: ManorTemperature(manorTemp: 37.5),
          ),
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        _makeSliderimage(),
        _sellerSimpleInfo(),
      ],
    );
  }

  Widget _bottomBarWidget() {
    return Container(
      width: size?.width,
      height: 55,
      color: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomBarWidget(),
    );
  }
}
