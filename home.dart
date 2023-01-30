import 'package:carrot_market_sample/repository/contents_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'detail.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ContentsRepository contentsRepository = ContentsRepository();
  late String currentLocation;
  final Map<String, String> locationTypeToString = {
    "banpo": "반포동",
    "yeoksam": "역삼동",
    "sadang": "사당동",
  };
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    //현재 지역값 초기화
    currentLocation = "banpo";
    isLoading = false;
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   contentsRepository = ContentsRepository();
  // }

  //package:intl/intl.dart' 의 NumberFormat 클래스를 사용하여 숫자를 통화 형식으로 변환합니다.
  final oCcy = new NumberFormat("#,###", "ko_KR");
  String calcStringToWon(String priceString) {
    return "${oCcy.format(int.parse(priceString))} 원";
  }

  Future<List<Map<String, String>>> _loadContents() async {
    List<Map<String, String>> responseData =
        await contentsRepository.loadContentsFromLocation(currentLocation);
    return responseData;
  }

  Widget _makeDataList(List<Map<String, String>> datas) {
    int size = datas == null ? 0 : datas.length;
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 15),
      physics: ClampingScrollPhysics(), // bounce 효과를 제거 할 수 있다.
      itemBuilder: (BuildContext context, int index) {
        if (datas != null && datas.length > 0) {
          Map<String, String> data = datas[index];
          return GestureDetector(
            onTap: () {
              //페이지 전환시 push(열때), pop(닫을때) 방식으로 전환
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return DetailContextView(
                  data: datas[index],
                );
              }));
            },
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      // Hero 위젯을 사용하여 애니메이션 효과를 줍니다.
                      child: Hero(
                        tag: data["cid"] as String,
                        child: Image.asset(
                          data["image"] as String,
                          width: 100,
                          height: 100,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.only(left: 20, top: 2),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data["title"] as String,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 5),
                            Text(
                              data["location"] as String,
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xff999999)),
                            ),
                            SizedBox(height: 5),
                            Text(
                                calcStringToWon(
                                    datas[index]["price"].toString()),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 5),
                            Expanded(
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 18,
                                      child: SvgPicture.asset(
                                        "assets/svg/heart_off.svg",
                                        width: 13,
                                        height: 13,
                                      ),
                                    ),
                                    SizedBox(width: 3),
                                    Text(data["likes"] as String),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
      itemCount: size,
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          height: 1,
          color: Colors.black.withOpacity(0.1),
        );
      },
    );
  }

  /*
   * body UI 
   */
  Widget _bodyWidget() {
    return FutureBuilder<List<Map<String, String>>>(
      future: _loadContents(),
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, String>>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("데이터 오류"));
        }
        if (snapshot.hasData) {
          return _makeDataList(snapshot.data ?? []);
        }
        return Center(child: Text("해당 지역에 데이터가 없습니다."));
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            print("tap");
          },
          child: PopupMenuButton<String>(
            //드롭박스 다운시 아래로 떨어지는 거리
            offset: Offset(0, 30),
            //드롭박스 모양 스타일
            shape: ShapeBorder.lerp(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                0.5),
            //드롭박스 아이템 선택시
            onSelected: (String where) {
              print(where);
              //initState에서 currentLocation 지정해준 값으로 변경
              setState(() {
                currentLocation = where;
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                //appbar 드롭박스 셋팅
                PopupMenuItem(
                  value: "banpo",
                  child: Text("논현동"),
                ),
                PopupMenuItem(
                  value: "yeoksam",
                  child: Text("역삼동"),
                ),
                PopupMenuItem(
                  value: "sadang",
                  child: Text("사당동"),
                ),
              ];
            },
            child: Row(
              children: [
                //드롭박스 Map셋팅으로 지정해준 값으로 변경
                Text(locationTypeToString[currentLocation]!,
                    style: TextStyle(color: Colors.black)),
                Icon(Icons.arrow_drop_down, color: Colors.black),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
              onPressed: () {}, icon: Icon(Icons.search), color: Colors.black),
          IconButton(
              onPressed: () {}, icon: Icon(Icons.tune), color: Colors.black),
          IconButton(
              onPressed: () {},
              icon: SvgPicture.asset("assets/svg/bell.svg", width: 24)),
        ],
      ),
      body: _bodyWidget(),
    );
  }
}
