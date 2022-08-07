import 'package:flutter/material.dart';

import 'game_logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //local variables for game
  String activePlayer='X';
  bool gameOver=false;
  int turn=0;
  String result='';
  bool isSwitched=false;
  Game game=Game();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: MediaQuery.of(context).orientation==Orientation.portrait?Column(
          children: [
            ...firstBlock(),
            _expanded(context),
            ...lastBlock()
          ],
        ):Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...firstBlock(),
                  const SizedBox(height: 20,),
                  ...lastBlock()
                ],
              ),
            ),
            _expanded(context),
          ],
        ),
      ),
    );
  }


  List<Widget> firstBlock(){
    return [
      SwitchListTile.adaptive(
          title:const Text("Turn on/off two players",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
            textAlign: TextAlign.center,
          ),
          value: isSwitched,
          onChanged: (bool newValue){
            setState(() {
              isSwitched=newValue;
            });
          }
      ),
      const SizedBox(height: 20,),
      Text("It's $activePlayer turn".toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 52,
        ),
        textAlign: TextAlign.center,
      ),
    ];
  }

  List<Widget> lastBlock(){
    return [
      Text(result,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 42,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 20,),
      ElevatedButton.icon(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Theme.of(context).splashColor)
        ),
        icon: const Icon(Icons.repeat),
        onPressed: (){
          setState(() {
            Player.playerX=[];
            Player.playerO=[];
            activePlayer='X';
            gameOver=false;
            turn=0;
            result='';
          });
        },
        label: const Text("Repeat the Game"),
      ),
    ];
  }

  Expanded _expanded(BuildContext context){
    return Expanded(
        child:GridView.count(
            padding: const EdgeInsets.all(16),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            childAspectRatio: 1.0,
            crossAxisCount: 3,
            children: List.generate(
                9,
                    (index) =>InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: gameOver ?null:()=>_onTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).shadowColor,
                        borderRadius: BorderRadius.circular(16)
                    ),
                    child: Center(
                      child:Text(
                          Player.playerX.contains(index)?"X": Player.playerO.contains(index)
                              ?"O":"",
                          style:TextStyle(
                            color: Player.playerX.contains(index)?Colors.blue:Colors.pink,
                            fontSize: 52,
                          )),
                    ),
                  ),
                )
            )
        )
    );
  }

  _onTap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.playGame(index, activePlayer);
      updateState();

      if (!isSwitched && !gameOver && turn != 9) {
        await game.autoPlay(activePlayer);
        updateState();
      }
    }
  }

  void updateState() {
    setState(() {
      activePlayer = (activePlayer == 'X') ? 'O' : 'X';
      turn++;

      String winnerPlayer = game.checkWinner();

      if (winnerPlayer != '') {
        gameOver = true;
        result = '$winnerPlayer is the winner';
      } else if (!gameOver && turn == 9) {
        result = 'It\'s Draw!';
      }
    });
  }
}

