import 'dart:html';
import 'dart:ui';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Journey',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber, secondary: Colors.blueGrey),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var _currentPage = 0;

  int get currentPage => _currentPage;

  set currentPage(int newPage) {
    _currentPage = newPage;
    notifyListeners();  // This will notify the listeners to rebuild the UI
  }
}


class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    Widget page;
      switch (appState.currentPage) {
      case 0:
        page = OpeningPage(appState: appState);
        break;
      case 1:
        page = JournalingPage();
      default:
  
      throw UnimplementedError('no widget for $appState.currentPage');
    }

    return Scaffold(
      body: page,
    );
  }
}

class OpeningPage extends StatelessWidget {
  const OpeningPage({
    super.key,
    required this.appState,
  });

  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double size = constraints.maxHeight * 0.105;
        
        return Scaffold(
          body: Stack(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 35.0, right: 30.0, bottom: 50.0),
                  child: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: [Color(0xFFEF9696), Color(0xffFBB173), Color(0xffffc8dd), Color(0xffC7F3BC), Color(0xFFBBF2F8), Color(0xffDFCBFD)], // Replace with your desired colors
                        begin: Alignment.topLeft,
                        end: Alignment.bottomLeft,
                      ).createShader(bounds);
                    },
                    child: TextAnimator(
                      'Hey, how are you doing today?',
                      initialDelay: const Duration(seconds: 1),
                      characterDelay: const Duration(milliseconds: 60),
                      style: GoogleFonts.poppins(
                        fontSize: size,
                      ),
                    ),
                  )
                ),
              ),
    
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(30.0),
                  child: IconButton(
                    icon: Icon(Icons.arrow_right_alt_rounded), 
                    iconSize: 50.0, 
                    onPressed: () {
                      appState.currentPage = 1; 
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class JournalingPage extends StatefulWidget {
  @override
  State<JournalingPage> createState() => _JournalingPageState();
}

class _JournalingPageState extends State<JournalingPage> {
  // const _JournalingPageState({
  //   super.key,
  //   required this.appState,
  // });

  // final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    
    //TOOD: maybe make another list of icons w/o outline for when not selected
    List<Icon> icons = [Icon(Icons.hourglass_bottom_rounded), Icon(Icons.camera), Icon(Icons.sick), Icon(Icons.anchor), Icon(Icons.account_box), Icon(Icons.favorite), Icon(Icons.face)];
    
    //state
    List<bool> selectedEmotions = List<bool>.filled(7, false);
    var text = null;

    //TODO: add a cross button to close, and will have to
    //add logic to be able to come back to journal page from calender page
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Center(
            child: Column (
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.only(top: constraints.maxHeight * 0.1)),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Select upto 3 emotions that describe your day today.', 
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 25.0, color: Color.fromARGB(255, 123, 123, 123))
                    )
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 5.0, // Horizontal spacing between children
                  runSpacing: 6.0, // Vertical spacing between rows
      
                  children: icons.asMap().entries.map((entry) {
                    int index = entry.key;
                    Icon icon = entry.value;

                    return IconButton(
                      icon: icon,
                      iconSize: (constraints.maxWidth / 5),
                      onPressed: () {
                        setState(() {
                          selectedEmotions[index] = !selectedEmotions[index];
                        });
                      },
                    );
                  }).toList(),
                )
              ],),
          )
        );
      }
    );
  }
  

}


// class GeneratorPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     var pair = appState.current;

//     IconData icon;
//     if (appState.favorites.contains(pair)) {
//       icon = Icons.favorite;
//     } else {
//       icon = Icons.favorite_border;
//     }

//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           BigCard(pair: pair),
//           SizedBox(height: 10),
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: () {
//                   appState.toggleFavorite();
//                 },
//                 icon: Icon(icon),
//                 label: Text('Like'),
//               ),
//               SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   appState.getNext();
//                 },
//                 child: Text('Next'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FavoritesPage extends StatelessWidget {
  
//    @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();

//     if (appState.favorites.isEmpty) {
//       return Center(
//         child: Text('No favorites yet.'),
//       );
//     }

//     return ListView(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(20),
//           child: Text('You have '
//               '${appState.favorites.length} favorites:'),
//         ),
//         for (var pair in appState.favorites)
//           ListTile(
//             leading: Icon(Icons.favorite),
//             title: Text(pair.asLowerCase),
//           ),
//       ],
//     );
//   }
// }


class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text((pair.asLowerCase), style: style),
      ),
    );
  }
}