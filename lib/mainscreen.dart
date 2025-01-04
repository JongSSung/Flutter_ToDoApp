import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/add_task.dart';


class MainScreen extends StatefulWidget
{
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
{
  List<String> todoList = [];
  void addTodo({required String todoText}){
    setState(() {
      // 가장 최신 순
      todoList.insert(0, todoText);
    });
    writeLocalData();
    // 데이터 추가후 바텀시트 없애지도록 처리.
    Navigator.pop(context);
  }
  
  // Shared preferences 사용해 데이터 저장
  // 참고 https://pub.dev/packages/shared_preferences
  // 그냥 설치시 오류발생함.. 설정 -> 개발자 설정 -> 개발자모드 활성화 후 설치
  void writeLocalData() async { 
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('todoList', todoList);
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      // 엡바 좌측 햄버거 메뉴
      drawer: const Drawer(
        child: Text('Drawer'),
      ),
      appBar: AppBar(
        title: const Text('TODO App'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // 클릭시 하단에 modal창 나옴
              // 디폴트 50%
              showModalBottomSheet(
                context: context, 
                builder: (context){                  
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets, // 홈 인디케이터, 키보드의 높이등  영역의 크기를 알려줌
                    child: SizedBox(
                      height: 250,
                      child: AddTask(
                        addTodo: addTodo
                        ),
                    ),
                  );
                },
              );
            },
            // 좌측 상단 + 버튼
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index){
          return ListTile(
            onTap: (){
              showModalBottomSheet(
                context: context, 
                builder: (context){
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: (){
                        setState(() {
                          todoList.removeAt(index);
                        });
                        writeLocalData();
                        Navigator.pop(context);
                      }, 
                      child: Text("Task Done!"),
                      )
                  );
                },
              );
            },
            title: Text(todoList[index]), 
          );
        },
      ),

    );
  }
}