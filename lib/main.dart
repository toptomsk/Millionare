import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:quiz/Helper/APIRequest.dart';
import 'package:quiz/Helper/Model.dart';
import 'package:quiz/Home.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:quiz/Login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});


  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {

  bool startAnimation = false, showAnswer = false, enableAnswer = true;
  double screenWidth = 0;
  CountDownController controller = CountDownController();
  late AnimationController _animationController;

  late Future<RootData> futureData;
  int indexQuest = 0;
  int selectedAnswer = -1;

  Future<RootData> fetchData() async {
    Future<RootData> data = APIRequest().fetchData();
    return data;
  }

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animationController.repeat(reverse: true);
    super.initState();

    futureData = fetchData();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: futureData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.jpg"),
                  fit: BoxFit.cover,
                ),
              )
          );
        }
        if (snapshot.hasData) {
          RootData data = snapshot.data!;
          return Scaffold(
            body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(child: Column(children: [
                  Row(children: [
                    const SizedBox(width: 16,),
                    IconButton(onPressed: () => {
                      Navigator.pop(context)
                      }, icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 30,)),
                    Expanded(child: Container()),
                    IconButton(onPressed: () => {
                      setState(() {
                        controller.reset();
                        showAnswer = false;
                        selectedAnswer = -1;
                        startAnimation = false;
                        indexQuest++;
                      })
                    }, icon: const Icon(Icons.skip_next, color: Colors.white, size: 50,)),
                  ],),
                  const SizedBox(height: 20,),
                  CircularCountDownTimer(
                    duration: 5,
                    initialDuration: 0,
                    controller: controller,
                    width: 100,
                    height: 100,
                    ringColor: Colors.grey[300]!,
                    fillColor: Colors.green[300]!,
                    backgroundColor: Colors.blue[500],
                    strokeWidth: 10.0,
                    strokeCap: StrokeCap.round,
                    textStyle: const TextStyle(
                        fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    textFormat: CountdownTextFormat.S,
                    isReverse: true,
                    isReverseAnimation: false,
                    isTimerTextShown: true,
                    autoStart: false,
                    onStart: () {

                    },
                    onComplete: () {
                      setState(() {
                        enableAnswer = false;
                        showAnswer = true;
                      });
                    },
                    onChange: (String timeStamp) {

                    },
                    timeFormatterFunction: (defaultFormatterFunction, duration) {
                      return Function.apply(defaultFormatterFunction, [duration]);
                    },
                  ),
                  const SizedBox(height: 20,),
                  Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      width: 500,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: AssetImage("assets/images/frameText.png"),
                          fit: BoxFit.fill,
                        ),
                      ),child: AnimatedTextKit(
                    key: ValueKey<int>(indexQuest),
                    totalRepeatCount: 1,
                    animatedTexts: [
                      TyperAnimatedText(data.questions![indexQuest].question!, textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 25, color: Colors.white))
                    ], onFinished: () => {
                    setState(() {
                      startAnimation = true;
                      Future.delayed(const Duration(milliseconds: 1500), () {
                        controller.start();
                      });
                    })
                  },)
                  ),
                  const SizedBox(height: 40,),
                  SizedBox(width: 320, child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 12,),
                    itemCount: data.questions![indexQuest].answers!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AnimatedContainer(
                      curve: Curves.easeInOut,
                      height: 100,
                      duration: Duration(milliseconds: 200 + 200*index),
                      transform: Matrix4.translationValues(startAnimation ? 0 : screenWidth, 0, 0),
                      child:  getWidgetButton(index, data.questions!));
                    }
                  )
                ),
              ],))
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget getWidgetButton(int index, List<Question> lst) {
    if (showAnswer && index == lst[indexQuest].right) {
      return FadeTransition(opacity: _animationController,
          child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundBuilder:
                    (BuildContext context, Set<WidgetState> states, Widget? child) {
                  return Ink(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: const AssetImage("assets/images/btnImage.png"),
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(Colors.greenAccent.withOpacity(0.4), BlendMode.srcATop)
                      ),
                    ),
                    child: child,
                  );
                },
              ),
              child: Padding(padding: const EdgeInsets.only(left: 28), child: Row(children: [
                Text(index == 0 ? "A" : (index == 1 ? "B" : (index == 2 ? "C" : "D")), style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
                const SizedBox(width: 40,),
                Container(alignment: Alignment.center, height: 60, width: 200, padding: const EdgeInsets.only(right: 10),
                  child: Text(lst[indexQuest].answers![index],
                      maxLines: 2, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),)
              ],
              ),)
          )
      );
    } else if (index == selectedAnswer) {
      return TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundBuilder:
                (BuildContext context, Set<WidgetState> states, Widget? child) {
              return Ink(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: const AssetImage("assets/images/btnImage.png"),
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode((showAnswer && index != lst[indexQuest].right) ? Colors.red.withOpacity(0.7) : Colors.orange.withOpacity(0.4), BlendMode.srcATop)
                  ),
                ),
                child: child,
              );
            },
          ),
          child: Padding(padding: const EdgeInsets.only(left: 28), child: Row(children: [
            Text(index == 0 ? "A" : (index == 1 ? "B" : (index == 2 ? "C" : "D")), style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
            const SizedBox(width: 40,),
            Container(alignment: Alignment.center, height: 60, width: 200, padding: const EdgeInsets.only(right: 10),
              child: Text(lst[indexQuest].answers![index],
                  maxLines: 2, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),)
          ],
          ),)
      );
    }
    return TextButton(
        onPressed: () {
          setState(() {
            selectedAnswer = index;
          });
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundBuilder:
              (BuildContext context, Set<WidgetState> states, Widget? child) {
            return Ink(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/btnImage.png"),
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.srgbToLinearGamma()
                ),
              ),
              child: child,
            );
          },
        ),
        child: Padding(padding: const EdgeInsets.only(left: 28), child: Row(children: [
          Text(index == 0 ? "A" : (index == 1 ? "B" : (index == 2 ? "C" : "D")), style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
          const SizedBox(width: 40,),
          Container(alignment: Alignment.center, height: 60, width: 200, padding: const EdgeInsets.only(right: 10),
            child: Text(lst[indexQuest].answers![index],
                maxLines: 2, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),)
        ],
        ),)
    );
  }
}
