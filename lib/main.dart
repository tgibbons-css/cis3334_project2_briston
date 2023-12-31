import 'package:cis3334_project2_briston/screens/task_list_screen.dart';
import 'package:cis3334_project2_briston/screens/timer_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'models/task.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  Hive.registerAdapter(TaskAdapter());

  final tasksBox = await Hive.openBox<Task>('tasks');
  runApp(MyApp(tasksBox: tasksBox));
}

class MyApp extends StatelessWidget {
  final Box<Task> tasksBox;
  const MyApp({super.key, required this.tasksBox});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //scrollBehavior: const ConstantScrollBehavior(),
      title: 'Focus Buddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}



class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  bool get wantKeepAlive => true;

  // final List<Widget> _widgetOptions = <Widget>[
  //   TaskListScreen(tasksBox: Hive.box<Task>('tasks')),
  //   const TimerScreen(),
  // ];

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
      children: <Widget>[
        TaskListScreen(tasksBox: Hive.box<Task>('tasks')),
        const TimerScreen(),
      ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Timer',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}







