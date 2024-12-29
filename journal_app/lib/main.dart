// import 'dart:html';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paged_vertical_calendar/paged_vertical_calendar.dart';
import 'package:intl/intl.dart'; 


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
        page = OpeningPage();
      case 1:
        page = JournalingPage();
      case 2:
        page = CalendarPage();
      default:
  
      throw UnimplementedError('no widget for $appState.currentPage');
    }

    return Scaffold(
      body: page,
    );
  }
}

class OpeningPage extends StatelessWidget {
@override
Widget build(BuildContext context) {
  var appState = context.watch<MyAppState>();

  // Get the size of the screen
  final size = MediaQuery.of(context).size;
  
  // Determine the text size as a percentage of the screen height
  final double textSize = size.height * 0.1;

  // Define the padding values
  final double horizontalPadding = size.width * 0.05; // 5% of screen width
  final double bottomPadding = size.height * 0.05; // 5% of screen height

  return Scaffold(
    body: Stack(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(
              left: horizontalPadding, 
              right: horizontalPadding, 
              bottom: bottomPadding,
            ),
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [Color(0xFFEF9696),
                  Color(0xffFBB173),
                  Color(0xffffc8dd),
                  Color(0xffC7F3BC),
                  Color(0xFFBBF2F8),
                  Color(0xffDFCBFD)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomLeft,
                ).createShader(bounds);
              },
              child: TextAnimator(
                'Hey, how are you doing today?',
                initialDelay: const Duration(seconds: 1),
                characterDelay: const Duration(milliseconds: 60),
                style: GoogleFonts.poppins(
                  fontSize: textSize,
                ),
              ),
            ),
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
                //TODO: need to add conditional here for if the entry 
                //for the day has already been logged
                appState.currentPage = 1; 
              },
            ),
          ),
        ),
      ],
    ),
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

    //TODO: add a cross button to close, and will have to
    //add logic to be able to come back to journal page from calender page
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: Column (
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(top: constraints.maxHeight * 0.1)),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('Select upto 3 emotions that describe your day today.', 
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 15.0, color: Color.fromARGB(255, 123, 123, 123))
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
                        iconSize: (constraints.maxWidth / 5.5),
                        onPressed: () {
                          setState(() {
                            selectedEmotions[index] = !selectedEmotions[index];
                          });
                        },
                      );
                    }).toList(),
                  ),
                  Padding(padding: EdgeInsets.only(top: constraints.maxHeight * 0.07)),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Text('Anything you want to make note of? (optional)', 
                      // textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 15.0, color: Color.fromARGB(255, 123, 123, 123))
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0),
                    child: TextField(
                      style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 15.0, color: Color.fromARGB(255, 123, 123, 123))),
                      decoration: InputDecoration(
                        // Unfocused state border
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 188, 187, 187), 
                            width: 2, 
                          ),
                        ),
                        // Focused state border
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 188, 187, 187), 
                            width: 2.5, 
                          ),
                        ),
                      ),
                      maxLines: 8, 
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(15.0)),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Text('What are some things you are grateful for today? (optional)', 
                      // textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 15.0, color: Color.fromARGB(255, 123, 123, 123))
                      )
                    ),
                  ),
                  // TODO: in the future, make it so that each things can be a seperate list entry
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0),
                    child: TextField(
                      style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 15.0, color: Color.fromARGB(255, 123, 123, 123))),
                      decoration: InputDecoration(
                        // Unfocused state border
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 188, 187, 187), 
                            width: 2, 
                          ),
                        ),
                        // Focused state border
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 188, 187, 187), 
                            width: 2.5, 
                          ),
                        ),
                      ),
                      maxLines: 1, 
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: constraints.maxHeight * 0.04)),
                  ElevatedButton(onPressed: () {
                      //TODO: update for backend
                      appState.currentPage = 2; 
                    }, 
                    style: ButtonStyle(
                      shadowColor: WidgetStateColor.resolveWith((states) => Color.fromARGB(255, 188, 187, 187)), 
                      backgroundColor: WidgetStateColor.resolveWith((states) => Colors.white),
                      padding: WidgetStateProperty.all(EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0, bottom: 15.0))),
                    child: Text('Submit', style: TextStyle(fontSize: 15.0, color: Color.fromARGB(255, 123, 123, 123)) )
                  )
                ],
              ),
            ),
          )
        );
      }
    );
  }
}

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return PagedVerticalCalendar(initialDate: DateTime(2024, 11, 10),
          // TODO: update this with database
          minDate: DateTime(2024, 11, 10),
          maxDate: DateTime(2025, 1, 10),
          onDayPressed: (value) {
            // TODO: update this to show popup of the entry that day and allow edit  
          },
          monthBuilder: (context, month, year) {
            String monthName = getMonthName(month);
            return Container(
              padding: EdgeInsets.only(top: 9.5, bottom: 8.0),
              child: Center(
                child: Text(
                  '$monthName $year',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Color.fromARGB(255, 123, 123, 123),
                  ),
                ),
              ),
            );
          },
          dayBuilder: (context, date) {
            int day = date.day;
            return Container(
              padding: EdgeInsets.all(2.0),
              child: Center(
                child: Column(
                  children: [Text(
                    '$day',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Color.fromARGB(255, 123, 123, 123),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 0.9)),
                  Container(
                    width: 15.0,
                    height: 15.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        colors: [Colors.blue, Colors.amber],
                        center: Alignment.center,
                      ),
                    ),
                  )
                  ],
                ),
              )
            );
          },
    );
    // return CalendarDatePicker(
    //       initialDate: DateTime(2024, 11, 10),
    //       firstDate: DateTime(2024, 11, 10),
    //       lastDate: DateTime(2025, 1, 10),
    //       onDateChanged: (DateTime date) {
    //       },
    //   );
  }
}


String getMonthName(int month) {
  const List<String> monthNames = [
    '', 'January', 'February', 'March', 'April', 'May', 'June', 
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  
  if (month < 1 || month > 12) {
    throw ArgumentError('Month must be between 1 and 12');
  }
  
  return monthNames[month];
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