// import 'package:flutter/material.dart';
// import 'package:ice_helphand/screens/home/home_screen.dart';
// import 'package:ice_helphand/screens/wrapper.dart';
// import 'package:introduction_screen/introduction_screen.dart';

// class OnBoardingScreen extends StatelessWidget {
//   const OnBoardingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     List<PageViewModel>? listPagesViewModel = [
//       PageViewModel(
//         title: "Title of custom body page",
//         bodyWidget: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             Text("Click on "),
//             Icon(Icons.edit),
//             Text(" to edit a post"),
//           ],
//         ),
//         image: Center(child: Image.asset('assets/helpwomen.png')),
//       ),
//       PageViewModel(
//         title: "Title of custom body page",
//         bodyWidget: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             Text("Click on "),
//             Icon(Icons.edit),
//             Text(" to edit a post"),
//           ],
//         ),
//         image: Center(child: Image.asset('assets/helpwomen.png')),
//       ),
//       PageViewModel(
//         title: "Title of custom body page",
//         bodyWidget: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             Text("Click on "),
//             Icon(Icons.edit),
//             Text(" to edit a post"),
//           ],
//         ),
//         image: Center(child: Image.asset('assets/helpwomen.png')),
//       ),
//     ];
//     return IntroductionScreen(
//       pages: listPagesViewModel,
//       showSkipButton: true,
//       skip: const Text("Skip"),
//       next: const Text("Next"),
//       done: const Text("Done"),
//       onDone: () {
//         // Navigator.of(context)
//         //     .push(MaterialPageRoute(builder: ((context) => Wrapper())));
//       },
//       baseBtnStyle: TextButton.styleFrom(
//         backgroundColor: Colors.grey.shade200,
//       ),
//       skipStyle: TextButton.styleFrom(primary: Colors.red),
//       doneStyle: TextButton.styleFrom(primary: Colors.green),
//       nextStyle: TextButton.styleFrom(primary: Colors.blue),
//     );
//   }
// }
