import 'package:flutter/material.dart';
import 'package:quiz_app_flutter/features/home_page.dart';
import 'package:quiz_app_flutter/features/quizzes/pages/quiz_page.dart';
import 'package:quiz_app_flutter/features/profile/pages/profile_page.dart';

class NavigationPage extends StatefulWidget {
  final int selectedIndex;

  const NavigationPage({Key? key, this.selectedIndex = 0}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int selectedIndex = 0;

  final List<IconData> navIcons = [
    Icons.home,
    Icons.school,
    Icons.person,
  ];

  final List<String> navigationTitle = [
    "Home",
    "Quiz",
    "Profile",
  ];

  final List<Widget> pages = [
    const HomePage(),
    const QuizPage(),
    const ProfilePage(),
  ];

  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
    _pageController = PageController(initialPage: selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            children: pages,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _navBar(),
          ),
        ],
      ),
    );
  }

  Widget _navBar() {
    return Container(
      height: 65,
      margin: const EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        bottom: 36.0,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(29),
            blurRadius: 20,
            spreadRadius: 10,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: navIcons.map((icon) {
          int index = navIcons.indexOf(icon);
          bool isSelected = selectedIndex == index;
          return Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                  _pageController.jumpToPage(index);
                });
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(
                        top: 15,
                        bottom: 0,
                        left: 35,
                        right: 35,
                      ),
                      child: Icon(
                        icon,
                        color: isSelected ? Colors.deepPurple : Colors.grey,
                        size: 26,
                      ),
                    ),
                    Text(
                      navigationTitle[index],
                      style: TextStyle(
                        color: isSelected ? Colors.deepPurple : Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
