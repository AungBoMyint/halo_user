import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:kozarni_ecome/screen/home_screen.dart';

class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SafeArea(
    child: IntroductionScreen(
      pages: [
        PageViewModel(
          title: "HALO FASHION STAR",
          body: ''' 💓 Style ကျကျ ကိုရီးယားမင်းသားလို ခေတ်မှီအောင်ဘဲ ဝတ်မလား 🤵‍♂️
💗 မြန်မာဆန်ဆန်နဲ့  ခန့်ချောကြီး style ဘဲ ဝတ်မလား။ 👨‍⚕️
🥳 “HALO ကိုသာ သတိရလိုက်ပါ ”''',
          image: buildImage('assets/shopping.jpeg'),
          decoration: getPageDecoration(),
        ),

        PageViewModel(
          title: "HALO FASHION STAR",
          body: ''' 
          “ Prefect The Imperfection,
                     HALO Is Everywhere…..”''',
          image: buildImage('assets/1.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'EVERYTIME YOU WILL NEED MY HALO',
          body: '''
          🌿  ခရီးထွက်ကြတဲ့အခါ...
          🌿  Shopping ထွကိကြတဲ့အခါ...
          🌿  မုန့်ထွက်စားကြတဲ့အခါ...
          🌿 လျှောက်လည်တဲ့အခါတိုင်း 
          ❝   HALO ကို သတိရလိုက်ပါနော်  ❞ ''',
          image: buildImage('assets/2.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: "HALO FASHION STAR",
          body: '''
          🌧  မိုးလေးကလဲရွာ....
          💨  လေလေးကလဲတိုက်....
          🤔  ဘာဝတ်ပြီး အပြင်ထွက်ရမလဲနော် ❓''',
          image: buildImage('assets/4.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'HAPPY AND ONLY MY HALO',
          body: ''' ❝  အမြဲတမ်း လွတ်လပ်ပေါ့ပါးနေစေဖို့
              HALO ဝတ်ကြစို့  ❞ ''',
          footer: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ButtonWidget(
              text: "LET'S GET STARTED",
              onClicked: () => goToHome(context),
            ),
          ),
          image: buildImage('assets/3.png'),
          decoration: getPageDecoration(),
        ),
      ],
      done: Text("", style: TextStyle(fontWeight: FontWeight.w600)),
      onDone: () => goToHome(context),
      showSkipButton: true,
      skip: Text('SKIP', style: TextStyle(fontSize: 16, color: Colors.orange),),
      onSkip: () => goToHome(context),
      next: Icon(Icons.forward_outlined, size: 30, color: Colors.orange),
      dotsDecorator: getDotDecoration(),
      onChange: (index) => print('Page $index selected'),
      globalBackgroundColor: Colors.white,
      skipFlex: 0,
      nextFlex: 0,
      // isProgressTap: false,
      // isProgress: false,
      // showNextButton: true,
      // freeze: true,
      // animationDuration: 1000,
    ),
  );

  void goToHome(context) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => HomeScreen()),
  );

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350));

  DotsDecorator getDotDecoration() => DotsDecorator(
    color: Colors.indigo,
    activeColor: Colors.orange,
    size: Size(10, 10),
    activeSize: Size(22, 10),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );

  PageDecoration getPageDecoration() => PageDecoration(
    titleTextStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    titlePadding: EdgeInsets.only(top: 20),
    descriptionPadding: EdgeInsets.only(top: 30).copyWith(bottom: 0),
    imagePadding: EdgeInsets.only(top: 30),
    pageColor: Colors.white,
  );
}


class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => RaisedButton(
    onPressed: onClicked,
    color: Colors.orange,
    shape: StadiumBorder(),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    child: Text(text,
      style: TextStyle(color: Colors.white, fontSize: 16),
    ),
  );
}