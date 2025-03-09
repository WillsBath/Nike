import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<Color> colors;
  late List<int> cardsFlipped;

  @override
  void initState() {
    super.initState();
    colors = [
      Colors.red, Colors.blue, Colors.pinkAccent, Colors.deepOrange,
      Colors.purple, Colors.lightGreen, Colors.amber, Colors.grey,
      Colors.red, Colors.blue, Colors.pinkAccent, Colors.deepOrange,
      Colors.purple, Colors.lightGreen, Colors.amber, Colors.grey
    ];
    colors.shuffle();

    cardsFlipped = List.generate(16, (index) => 0);
  }

  int getCurrFlipped() {
    return cardsFlipped.where((x) => x == 1).length;
  }

  List<dynamic> checkEqual() {
    int idx1 = -1, idx2 = -1;
    for (int i = 0; i < 16; i++) {
      if (cardsFlipped[i] == 1) {
        if (idx1 == -1) {
          idx1 = i;
        } else {
          idx2 = i;
          break;
        }
      }
    }
    if (idx1 == -1 || idx2 == -1) return [false, -1, -1];
    return [colors[idx1] == colors[idx2], idx1, idx2];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(
          child: Text(
            "Card Game",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 228, 255, 198),
      body: Container(
        margin: const EdgeInsets.all(10),
        height: 400,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 142, 255, 122),
        ),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: colors.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (cardsFlipped[index] == -1) return;
                setState(() {
                  cardsFlipped[index] = 1;
                  if (getCurrFlipped() == 2) {
                    var equal = checkEqual();
                    if (equal[0]) {
                      cardsFlipped[equal[1]] = -1;
                      cardsFlipped[equal[2]] = -1;
                    }
                    Future.delayed(const Duration(seconds: 1), () {
                      setState(() {
                        for (int i = 0; i < 16; i++) {
                          if (cardsFlipped[i] != -1) {
                            cardsFlipped[i] = 0;
                          }
                        }
                      });
                    });
                  }
                });
              },
              child: GameCard(
                id: index,
                color: colors[index],
                isFlipped: cardsFlipped[index],
              ),
            );
          },
        ),
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final Color color;
  final int isFlipped;
  final int id;

  const GameCard({
    super.key,
    required this.color,
    required this.isFlipped,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.all(5),
      curve: Curves.easeIn,
      decoration: BoxDecoration(
        color: isFlipped == 1
            ? color
            : isFlipped == 0
                ? const Color.fromARGB(255, 215, 247, 180)
                : Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
