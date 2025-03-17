// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
//
// class MainPage extends StatefulWidget {
//   const MainPage({super.key});
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<MainPage> {
//   final List<String> _carouselImages = [
//     'assets/main_img.jpeg',
//     'assets/main_img.jpeg',
//     'assets/main_img.jpeg',
//     'assets/main_img.jpeg',
//   ];
//   final List<String> _gridImages = [
//     'assets/grid/example1.jpeg',
//     'assets/grid/example2.png',
//     'assets/grid/example3.png',
//     'assets/grid/example4.png',
//   ];
//   int _currentIndex = 0;
//   final CarouselSliderController carouselController =
//       CarouselSliderController();
//   //
//   void _goToPrevious() {
//     if (_currentIndex > 0) {
//       setState(() {
//         _currentIndex -= 1;
//       });
//       carouselController.previousPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   void _goToNext() {
//     if (_currentIndex < _carouselImages.length - 1) {
//       setState(() {
//         _currentIndex += 1;
//       });
//       carouselController.nextPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         leading: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: [
//               SizedBox(width: 30),
//               Image.asset('assets/scrd_logo.png'),
//             ],
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(
//               Icons.notifications,
//               color: Colors.white,
//             ),
//             onPressed: () {},
//           ),
//           // IconButton(
//           //   icon: const Icon(Icons.settings),
//           //   onPressed: () {},
//           // ),
//           Container(
//             width: 30,
//             height: 30,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(30),
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(width: 10),
//         ],
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(26.0),
//         child: Column(
//           children: [
//             SingleChildScrollView(
//               child: Stack(
//                 children: [
//                   CarouselSlider(
//                     carouselController: carouselController,
//                     options: CarouselOptions(
//                       height: 400.0,
//                       autoPlay: true,
//                       viewportFraction: 1.0,
//                       enlargeCenterPage: true,
//                       onPageChanged: (index, reason) {
//                         setState(() {
//                           _currentIndex = index;
//                         });
//                       },
//                     ),
//                     items: _carouselImages.map((item) {
//                       return Builder(
//                         builder: (BuildContext context) {
//                           return Container(
//                             margin: const EdgeInsets.all(8.0),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10.0),
//                               image: DecorationImage(
//                                 image: AssetImage(item),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     }).toList(),
//                   ),
//                   Positioned(
//                     top: 0,
//                     bottom: 0,
//                     left: 10,
//                     child: IconButton(
//                       icon: Image.asset('assets/button/left_arrow.png'),
//                       iconSize: 50,
//                       onPressed: _goToPrevious,
//                     ),
//                   ),
//                   Positioned(
//                     top: 0,
//                     bottom: 0,
//                     right: 10,
//                     child: IconButton(
//                       icon: Image.asset('assets/button/right_arrow.png'),
//                       iconSize: 50,
//                       onPressed: _goToNext,
//                     ),
//                   ),
//                   Positioned(
//                     left: 0,
//                     right: 0,
//                     bottom: 20,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: List.generate(
//                         _carouselImages.length,
//                         (index) => Container(
//                           width: 8.0,
//                           height: 8.0,
//                           margin: const EdgeInsets.symmetric(horizontal: 4.0),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: _currentIndex == index
//                                 ? Colors.white
//                                 : Colors.grey,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(width: 8),
//                   Container(
//                     height: 35,
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.white),
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     child: DropdownButton<String>(
//                       value: '지역',
//                       items: <String>['지역', '옵션1', '옵션2']
//                           .map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value,
//                               style: const TextStyle(color: Colors.white)),
//                         );
//                       }).toList(),
//                       onChanged: (String? newValue) {},
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Container(
//                     height: 35,
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.white),
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     child: DropdownButton<String>(
//                       value: '난이도',
//                       items: <String>['난이도', '쉬움', '보통', '어려움']
//                           .map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value,
//                               style: const TextStyle(color: Colors.white)),
//                         );
//                       }).toList(),
//                       onChanged: (String? newValue) {},
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Container(
//                     height: 35,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.white),
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     child: TextButton.icon(
//                       onPressed: () {},
//                       icon: Image.asset(
//                         'assets/button/knife.png', // 원하는 이미지 경로
//                         width: 24, // 크기 조절
//                         height: 24,
//                       ),
//                       label: const Text('공포도 X',
//                           style: TextStyle(color: Colors.white, fontSize: 13)),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Container(
//                     height: 35,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.white),
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     child: TextButton.icon(
//                       onPressed: () {},
//                       icon: Image.asset(
//                         'assets/button/sneaker.png', // 원하는 이미지 경로
//                         width: 24,
//                         height: 24,
//                       ),
//                       label: const Text('활동성 X',
//                           style: TextStyle(color: Colors.white)),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   width: 8,
//                 ),
//                 DropdownButton<String>(
//                   style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 22,
//                       fontWeight: FontWeight.w700),
//                   value: '지역',
//                   items: <String>['지역', '옵션1', '옵션2']
//                       .map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value,
//                           style: const TextStyle(color: Colors.white)),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {},
//                 ),
//               ],
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: _gridImages.map((image) {
//                     return Container(
//                       width: 150,
//                       height: 300,
//                       margin: const EdgeInsets.symmetric(horizontal: 8.0),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10.0),
//                         image: DecorationImage(
//                           image: AssetImage(image),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
