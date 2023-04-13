import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snakemania/pixels/blank_pixels.dart';
import 'package:snakemania/pixels/food_pixels.dart';
import 'package:snakemania/pixels/highscore_tile.dart';
import 'package:snakemania/pixels/snake_pixels.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum snake_Direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
// height and width of the screen
  double? screenHeight;
  double? screenWidth;

  // grid dimensions
  int totalSquares = 100;
  int totalRow = 10;

  bool gameStarted = false;
  TextEditingController nameController = TextEditingController();
  //snake position
  List<int> snakePos = [0, 1, 2];

  //food position
  int snakeFood = 55;

// snake direction
  var snakeDirection = snake_Direction.RIGHT;

  int currentScore = 0;

// highscore List
  List<String> HighScores_docIds = [];
  late final Future? getDocIds;

  @override
  void initState() {
    getDocIds = gettingIds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (value) {
          if (value.isKeyPressed(LogicalKeyboardKey.space)) {
            startGame();
          } else if (value.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
            snakeDirection = snake_Direction.DOWN;
          } else if (value.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
            snakeDirection = snake_Direction.UP;
          } else if (value.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
            snakeDirection = snake_Direction.RIGHT;
          } else if (value.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
            snakeDirection = snake_Direction.LEFT;
          }
        },
        child: Column(
          children: [
            // high scores
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Current Score'),
                        Text(
                          currentScore.toString(),
                          style: TextStyle(fontSize: 32),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: gameStarted
                        ? Container()
                        : FutureBuilder(
                            future: getDocIds,
                            builder: (context, snapshot) {
                              return ListView.builder(
                                itemCount: HighScores_docIds.length,
                                itemBuilder: (context, index) {
                                  return HighScoreTile(
                                      documentId: HighScores_docIds[index]);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),

            //Game Grid
            Expanded(
              flex: 3,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0 &&
                      snakeDirection != snake_Direction.UP) {
                    snakeDirection = snake_Direction.DOWN;
                  } else if (details.delta.dy < 0 &&
                      snakeDirection != snake_Direction.DOWN) {
                    snakeDirection = snake_Direction.UP;
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 0 &&
                      snakeDirection != snake_Direction.LEFT) {
                    snakeDirection = snake_Direction.RIGHT;
                  } else if (details.delta.dx < 0 &&
                      snakeDirection != snake_Direction.RIGHT) {
                    snakeDirection = snake_Direction.LEFT;
                  }
                },
                child: GridView.builder(
                    itemCount: totalSquares,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: totalRow,
                    ),
                    itemBuilder: (context, index) {
                      if (snakePos.contains(index)) {
                        return const SnakePixels();
                      } else if (snakeFood == index) {
                        return const FoodPixels();
                      } else {
                        return const BlankPixels();
                      }
                    }),
              ),
            ),

            // Start button
            Expanded(
              child: Container(
                child: Center(
                  child: MaterialButton(
                    color: gameStarted ? Colors.grey : Colors.pink,
                    onPressed: gameStarted ? () {} : startGame,
                    child: const Text(
                      'Play',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startGame() {
    gameStarted = true;
    Timer.periodic(Duration(milliseconds: 250), (timer) {
      setState(() {
        // keep snake moving
        moveSnake();

        // check for game over
        if (gameOver()) {
          timer.cancel();
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Game Over'),
                  content: Column(
                    children: [
                      Text(
                        'Your Score is : ${currentScore.toString()}',
                      ),
                      TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your name',
                          ))
                    ],
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        submitScore();
                        Navigator.pop(context);
                        newGame();
                      },
                      color: Colors.pink,
                      child: const Text("Submit"),
                    )
                  ],
                );
              });
        }
      });
    });
  }

  void submitScore() {
    var database = FirebaseFirestore.instance;
    database.collection('HighScores').add({
      'name': nameController.text,
      'score': currentScore,
    });
  }

  Future newGame() async {
    HighScores_docIds = [];
    await gettingIds();
    setState(() {
      snakePos = [0, 1, 2];
      currentScore = 0;
      snakeFood = Random().nextInt(totalSquares);
      snakeDirection = snake_Direction.RIGHT;
      gameStarted = false;
      nameController.clear();
    });
  }

  bool gameOver() {
    List<int> bodySnake = snakePos.sublist(0, snakePos.length - 1);

    if (bodySnake.contains(snakePos.last)) {
      return true;
    }
    return false;
  }

  void eatFood() {
    currentScore++;
    while (snakePos.contains(snakeFood)) {
      snakeFood = Random().nextInt(totalSquares);
    }
  }

  void moveSnake() {
    switch (snakeDirection) {
      case snake_Direction.RIGHT:
        {
          if (snakePos.last % totalRow == 9) {
            snakePos.add(snakePos.last + 1 - totalRow);
          } else {
            snakePos.add(snakePos.last + 1);
          }
        }
        break;
      case snake_Direction.LEFT:
        {
          if (snakePos.last % totalRow == 0) {
            snakePos.add(snakePos.last - 1 + totalRow);
          } else {
            snakePos.add(snakePos.last - 1);
          }
        }
        break;

      case snake_Direction.UP:
        {
          if (snakePos.last < totalRow) {
            snakePos.add(snakePos.last - totalRow + totalSquares);
          } else {
            snakePos.add(snakePos.last - totalRow);
          }
        }
        break;

      case snake_Direction.DOWN:
        {
          if (snakePos.last + totalRow > totalSquares) {
            snakePos.add(snakePos.last + totalRow - totalSquares);
          } else {
            snakePos.add(snakePos.last + totalRow);
          }
        }
        break;

      default:
    }

    if (snakePos.last == snakeFood) {
      eatFood();
    } else {
      snakePos.removeAt(0);
    }
  }

  Future gettingIds() async {
    await FirebaseFirestore.instance
        .collection('HighScores')
        .orderBy('score', descending: true)
        .limit(5)
        .get()
        .then((value) => value.docs.forEach((element) {
              HighScores_docIds.add(element.reference.id);
            }));
  }
}
