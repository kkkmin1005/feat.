import 'package:flutter/material.dart';
import 'ootd.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: CalenderAppBar()
        ),
        body: Container(
          color: Colors.white,
          child: CalenderHomePage()
        )
      ),
    );
  }
}


class CalenderAppBar extends StatelessWidget {
  const CalenderAppBar({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            Container(
                margin: EdgeInsets.fromLTRB(20, 30, 10, 30),
                child: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_rounded), iconSize: 27)
            ),
            Container(
              margin:EdgeInsets.fromLTRB(10, 30, 7, 30),
              child: Text(
                '달력',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
              )
            ),
            Container(
              margin: EdgeInsets.fromLTRB(7, 30, 10, 30),
              child: IconButton(onPressed: (){}, icon: Icon(Icons.star_border_purple500_outlined), iconSize: 27)
            )
          ],
        ),
      ),
    );
  }
}

class CalenderDate extends StatefulWidget {
  CalenderDate({Key? key, this.day, this.year, this.month}) : super(key:key);

  final now = DateTime.now;
  var day;
  var year;
  var month;

  dayModify(day){
    if((day ~/ 10) < 1){
      return '0'+ day.toString();
    }
    else{
      return day.toString();
    }
  }

  monthModify(month){
    if((month ~/ 10) < 1){
      return '0'+ month.toString();
    }
    else{
      return month.toString();
    }
  }

  yearModify(year){
    return year.toString();
  }

  @override
  State<CalenderDate> createState() => _CalenderDate();
}

class _CalenderDate extends State<CalenderDate> {
  @override
  Widget build(BuildContext context) {
    if(widget.day == 0){
        return
          Container(
            width: 50, height: 50,
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white)
          );
    }
    else{
      return GestureDetector(
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ootdHomePage(year: widget.yearModify(widget.year), month:widget.monthModify(widget.month), day: widget.dayModify(widget.day)))
          );
          print(widget.yearModify(widget.year) + widget.monthModify(widget.month) + widget.dayModify(widget.day));
        },
        child: Container(
            width: 50, height: 50,
            child: Align
              (
                child: Text(widget.day.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                alignment: Alignment.center
              ),
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white)
        ),
      );
    }
  }
}


class CalenderHomePage extends StatefulWidget {
  CalenderHomePage({Key ? key}) : super(key:key);

  final now = DateTime.now();
  var startYear = 2024;
  var startMonth = 6;


  @override
  State<CalenderHomePage> createState() => _CalenderHomePageState();
}

class _CalenderHomePageState extends State<CalenderHomePage> {

  var scroll = ScrollController();

  searchTargetIndex(startDate, nowDate){
    //달력 하나 위젯 크기 알아내서 인덱스 차에 곱하기 466.5
    // state 전송 필요 x
    // init 스테이트에서 타겟 인덱스 잡아주고 진행하기

    var gap;

    if(startDate[0] == nowDate[0]){
      gap = nowDate[1] - startDate[1];
    }
    else{
      gap = (nowDate[0] - startDate[0])*12 + (nowDate[1] - startDate[1]);
    }

    return gap * 466.7;
  }

  void scrollToPosition(gap){
    scroll.animateTo(gap, duration: Duration(seconds: 1), curve: Curves.easeInOut);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double targetPosition = searchTargetIndex(
          [widget.startYear, widget.startMonth], [widget.now.year, widget.now.month]);
      scrollToPosition(targetPosition);
    });
  }

  yearAndMonth(int plusmonth, int year, int month){

    int newMonth = month + plusmonth;
    int newYear = year;

    if (newMonth > 12) {
      newYear += (newMonth - 1) ~/ 12;
      newMonth = (newMonth - 1) % 12 + 1;
    }

    return [newYear, newMonth];
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 12,
      controller: scroll,
      itemBuilder: (context, index){
        return Column(children: [
          Align(
              child: Container(
                child: Text(yearAndMonth(index, widget.startYear, widget.startMonth)[0].toString() + '__' + yearAndMonth(index, widget.startYear, widget.startMonth)[1].toString() , style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
                margin: EdgeInsets.fromLTRB(20, 30, 0, 10),
                decoration: BoxDecoration(color: Colors.white),
              ),
              alignment: Alignment.topLeft
          ),
          SizedBox(child: CalendarBar(), width: 450, height: 70),
          SizedBox(child: CalendarDateGridView(index: index), width: 450, height: 340)
        ]
        );
      }
    );
  }
}

// 캘린더 구현
// 1 캘린더 데이트 위젯 배치로 1달 캘린더 만들기
// 최대 6주 이므로 6 * 7로 구성

class CalendarDateGridView extends StatefulWidget {
  CalendarDateGridView({Key? key, this.index}) : super(key:key);

  var index;
  var startYear = 2024;
  var startMonth = 6;

  @override
  State<CalendarDateGridView> createState() => _CalendarDateGridViewState();
}

class _CalendarDateGridViewState extends State<CalendarDateGridView> {
  final now = DateTime.now();
  late int year;
  late int month;

  yearAndMonth(int plusmonth, int year, int month){

    int newMonth = month + plusmonth;
    int newYear = year;

    if (newMonth > 12) {
      newYear += (newMonth - 1) ~/ 12;
      newMonth = (newMonth - 1) % 12 + 1;
    }

    return [newYear, newMonth];
  }

  int monthDay(int month, int year){
    if ([1,3,5,7,8,10,12].contains(month))
      {
        return 31;
      }
    else if ([4,6,9,11].contains(month))
      {
        return 30;
      }
    else
      {
        if((year % 4 == 0 && year % 100 != 0) || year % 400 == 0)
          {
            return 29;
          }
        else
          {
            return 28;
          }
      }
  }

  int firstDay(int year, int month){  // 원하는 년도의 1월 1일 요일 알아 내기
    int sum = 0;

    for(int i = 1583; i < year; i++){
      if ((i % 4 == 0 && i % 100 != 0) || i % 400 == 0){
        sum += 2;
      } else{
        sum += 1;
      }
    }

    int first = (sum + 6) % 7; // 일월화수목금토는 각 0123456에 대입됨

    for(int j = 1; j < month; j++){
      first += monthDay(j, year) % 7;
    }

    return first % 7;
  }

  @override
  void initState() {
    super.initState();
    year = yearAndMonth(widget.index, widget.startYear, widget.startMonth)[0];
    month = yearAndMonth(widget.index, widget.startYear, widget.startMonth)[1];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7, // 열의 수
          crossAxisSpacing: 2.0, // 열 간의 간격
          mainAxisSpacing: 2.0, // 행 간의 간격
        ),
        itemCount: 35, // 총 아이템 수 (7 * 6)
        itemBuilder: (context, index) {
          if (index >= firstDay(year, month)) {

            var day = index - firstDay(year, month) + 1;

            if (day > monthDay(month, year)){
              return CalenderDate(day: 0);
            }
            else{
              return CalenderDate(day: day, year: year, month: month);
            }
          }
          else{
            return CalenderDate(day: 0);
          }
        },
      ),
    );
  }
}



class CalendarBar extends StatelessWidget {
  CalendarBar({super.key});

  var date = ['일', '월', '화', '수', '목', '금', '토'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
          itemCount: 7,
          itemBuilder: (context, index){
            return Container(
                width: 50, height: 50,
                child: Align(
                    child: Text(date[index], style: TextStyle(fontSize: 20)),
                    alignment: Alignment.center
                ),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white)
            );
          },

      ),
    );
  }
}




