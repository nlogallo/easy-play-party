import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cucù delle Wincs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CucuGame(title: 'Cucù delle Wincs'),
    );
  }
}

class CucuGame extends StatefulWidget {
  const CucuGame({super.key, required this.title});

  final String title;

  @override
  State<CucuGame> createState() => _CucuGameState();
}

class _CucuGameState extends State<CucuGame> {
  List<bool> coinsVisible = [true, true, true];

  String timestamp = DateTime.now().toLocal().toIso8601String();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(timestamp),
          Container(
            height: 100,
            color: Colors.red.withOpacity(0.5),
            child: Center(
              child: Text(
                "Trascina qui per far volare una vita",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Center(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: coinsVisible.length,
                itemBuilder: (context, index) {
                  if (coinsVisible[index]) {
                    return DraggableCoin(
                      key: ValueKey(index),
                      onDropped: () {
                        setState(() {
                          coinsVisible[index] = false; // Nascondi la moneta
                        });
                      },
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  for (int i = 0; i < coinsVisible.length; i++) {
                    if (!coinsVisible[i]) {
                      setState(() {
                        coinsVisible[i] = true;
                      });
                      break;
                    }
                  }
                },
                icon: Icon(
                  size: 60,
                  Icons.add_circle_rounded,
                  color: Colors.blue[900],
                ),
              ),
              IconButton(
                onPressed: () {
                  for (int i = 0; i < coinsVisible.length; i++) {
                    timestamp = DateTime.now().toLocal().toIso8601String();
                    coinsVisible[i] = true;
                    setState(() {});
                  }
                },
                icon: Icon(
                  size: 60,
                  Icons.restart_alt_rounded,
                  color: Colors.blue[900],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class DraggableCoin extends StatelessWidget {
  final VoidCallback onDropped;

  const DraggableCoin({Key? key, required this.onDropped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<int>(
      data: 1,
      feedback: Material(
        color: Colors
            .transparent, // Prevents visual issues with transparent feedback
        child: CoinWidget(), // Your widget under the cursor
      ),
      child: CoinWidget(),
      childWhenDragging:
          SizedBox(), // Moneta "scomparsa" mentre viene trascinata
      dragAnchorStrategy:
          pointerDragAnchorStrategy, // Makes the feedback follow the cursor/finger
      onDragEnd: (details) {
        // Check if the drag ended at the desired position
        if (details.offset.dy < 100) {
          onDropped();
        }
      },
    );
  }
}

class CoinWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return /*Align(
      alignment: Alignment.bottomCenter,
      child: */
        Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Icon(
            Icons.circle,
            size: 80,
            color: Colors.amber,
          ),
          Text(
            "10",
            style: GoogleFonts.gideonRoman(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          )
        ],
      ),
      //),
    );
  }
}
