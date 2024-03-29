import 'package:cinemamovie/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MovieDetail extends StatefulWidget {
  final Movie moviesDetails;
  const MovieDetail({Key? key, required this.moviesDetails}) : super(key: key);

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  late VideoPlayerController _controller;
  bool vidInited = false;

  void initVideo() {
    if (!vidInited) {
      _controller = VideoPlayerController.network(widget.moviesDetails.video)
        ..initialize().then((_) {
          _controller.play();
          _controller.setLooping(true);

          setState(() {
            vidInited = true;
          });
        });
    }
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    initVideo();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios),
            ),
            const Spacer(),
            const Text(
              'Movie Details',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const Spacer(),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2b2a3a),
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: (widget.moviesDetails.title == true)
          ? Container()
          : WillPopScope(
              onWillPop: _onWillPop,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      (_controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play());
                    },
                    child: ClipRRect(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: (MediaQuery.of(context).size.width * 9) / 16,
                        child: _controller.value.isInitialized
                            ? AspectRatio(
                                aspectRatio: (16 / 9),
                                child: VideoPlayer(_controller),
                              )
                            : const Center(
                                child: SizedBox(
                                    width: 100.0,
                                    height: 100.0,
                                    child: CircularProgressIndicator()),
                              ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10.0, 15.0, 0, 10.0),
                    child: Text(
                      widget.moviesDetails.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: const Divider(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.moviesDetails.description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10.0, 0, 0, 10.0),
                    child: Text(
                      (widget.moviesDetails.imagesStars == true)
                          ? ""
                          : "Actors",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  (widget.moviesDetails.imagesStars == true)
                      ? Container()
                      : Row(
                          children: [
                            const SizedBox(
                              height: 150.0,
                              width: 15.0,
                            ),
                            Row(
                              children: widget.moviesDetails.imagesStars
                                  .map<Widget>(
                                    (actorUrl) => Container(
                                      margin:
                                          const EdgeInsets.only(right: 15.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        child: SizedBox(
                                          width: 150.0,
                                          height: 150.0,
                                          child: Image.network(
                                            actorUrl,
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                ],
              ),
            ),
    );
  }
}
