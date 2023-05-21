// import 'package:cinemamovie/functions.dart';
// import 'package:cinemamovie/views/booking/booking.dart';
// import 'package:cinemamovie/views/booking/widgets/booking_button.dart';
// import 'package:cinemamovie/views/movie/widgets/movie_description.dart';
// import 'package:cinemamovie/views/movie/widgets/movie_timing.dart';
// import 'package:flutter/material.dart';

// import 'package:video_player/video_player.dart';

// class MovieDetail extends StatefulWidget {
//   final movieData;
//   const MovieDetail({Key? key, required this.movieData}) : super(key: key);

//   @override
//   State<MovieDetail> createState() => _MovieDetailState();
// }

// class _MovieDetailState extends State<MovieDetail> {
//   late VideoPlayerController _controller;
//   bool vidInited = false;

//   void initVideo() {
//     if (!vidInited) {
//       _controller = VideoPlayerController.network(widget.movieData["video"])
//         ..initialize().then((_) {
//           _controller.play();
//           _controller.setLooping(true);

//           setState(() {
//             vidInited = true;
//           });
//         });
//     }
//   }

//   Future<bool> _onWillPop() async {
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     initVideo();

//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Row(
//           children: [
//             InkWell(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: const Icon(Icons.arrow_back_ios),
//             ),
//             const Spacer(),
//             const Text(
//               'Movie Details',
//               style: TextStyle(
//                 fontFamily: 'Roboto',
//                 fontWeight: FontWeight.bold,
//                 fontSize: 24,
//               ),
//             ),
//             const Spacer(),
//           ],
//         ),
//         centerTitle: true,
//         backgroundColor: const Color(0xFF2b2a3a),
//         elevation: 0,
//       ),
//       resizeToAvoidBottomInset: false,
//       body: (widget.movieData["title"] == null)
//           ? Container()
//           : WillPopScope(
//               onWillPop: _onWillPop,
//               child: Stack(
//                 children: [
//                   Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           (_controller.value.isPlaying
//                               ? _controller.pause()
//                               : _controller.play());
//                         },
//                         child: ClipRRect(
//                           child: SizedBox(
//                             width: MediaQuery.of(context).size.width,
//                             height:
//                                 (MediaQuery.of(context).size.width * 9) / 16,
//                             child: _controller.value.isInitialized
//                                 ? AspectRatio(
//                                     aspectRatio: (16 / 9),
//                                     child: VideoPlayer(_controller),
//                                   )
//                                 : const Center(
//                                     child: SizedBox(
//                                         width: 100.0,
//                                         height: 100.0,
//                                         child: CircularProgressIndicator()),
//                                   ),
//                           ),
//                         ),
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             margin:
//                                 const EdgeInsets.fromLTRB(10.0, 15.0, 0, 10.0),
//                             child: const Text(
//                               "Details",
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 18.0,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                           ),
//                           Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 10.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 MovieTiming(
//                                     time: (parseDate(widget.movieData["date"])),
//                                     timeText: "Date"),
//                                 MovieTiming(
//                                   timeText: 'Time Start',
//                                   time: widget.movieData["timestart"],
//                                 ),
//                                 MovieTiming(
//                                   timeText: 'Time End',
//                                   time: widget.movieData["timeend"],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             margin: const EdgeInsets.only(top: 10.0),
//                             child: const Divider(
//                               color: Colors.white,
//                             ),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               MovieDescription(
//                                 title: widget.movieData["description"],
//                               ),
//                               Container(
//                                 margin:
//                                     const EdgeInsets.fromLTRB(10.0, 0, 0, 10.0),
//                                 child: Text(
//                                   (widget.movieData["imagesStars"] == null)
//                                       ? ""
//                                       : "Actors",
//                                   style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 18.0,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ),
//                               (widget.movieData["imagesStars"] == null)
//                                   ? Container()
//                                   : SingleChildScrollView(
//                                       scrollDirection: Axis.horizontal,
//                                       child: Row(
//                                         children: [
//                                           const SizedBox(
//                                             height: 150.0,
//                                             width: 15.0,
//                                           ),
//                                           Row(
//                                             children: widget
//                                                 .movieData["imagesStars"]
//                                                 .map<Widget>(
//                                                   (actorUrl) => Container(
//                                                     margin:
//                                                         const EdgeInsets.only(
//                                                             right: 15.0),
//                                                     child: ClipRRect(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               15.0),
//                                                       child: SizedBox(
//                                                         width: 150.0,
//                                                         height: 150.0,
//                                                         child: Image.network(
//                                                             actorUrl,
//                                                             fit: BoxFit.cover,
//                                                             alignment: Alignment
//                                                                 .center),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 )
//                                                 .toList(),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                             ],
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     child: Container(
//                       alignment: Alignment.center,
//                       color: const Color.fromARGB(255, 2, 1, 17),
//                       height: 70.0,
//                       width: MediaQuery.of(context).size.width,
//                       child: BookingButton(
//                         tapped: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const Booking(),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
