import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_application_2/components/custom_list_tile.dart';

import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MusicApp(),
    );
  }
}

class MusicApp extends StatefulWidget {
  const MusicApp({Key? key}) : super(key: key);

  @override
  State<MusicApp> createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  List musicList = [
    {
      'title': "A Very Happy Christmas",
      'singer': "",
      'url':
          "https://assets.mixkit.co/music/preview/mixkit-a-very-happy-christmas-897.mp3",
      'coverUrl':
          "https://www.homemade-gifts-made-easy.com/image-files/free-printable-christmas-cards-have-yourself-merry-blackboard-800x800.png"
    },
    {
      'title': "Games Worldbeat",
      'singer': "",
      'url':
          "https://assets.mixkit.co/music/preview/mixkit-games-worldbeat-466.mp3",
      'coverUrl':
          "https://vusic.techstore.dev/static/media/notAvailable.776cd01b.jpg"
    },
    {
      'title': "Comical",
      'singer': "",
      'url': "https://assets.mixkit.co/music/preview/mixkit-comical-2.mp3",
      'coverUrl':
          "https://pbs.twimg.com/profile_images/1040980813674958848/jz6yn-vN_400x400.jpg"
    },
    {
      'title': "Deep Urban",
      'singer': "",
      'url': "https://assets.mixkit.co/music/preview/mixkit-deep-urban-623.mp3",
      'coverUrl':
          "https://i1.sndcdn.com/artworks-000134476436-ko298x-t500x500.jpg"
    }
  ];

  String currentTitle = "";
  String currentCover = "";
  String currentSinger = "";
  IconData btnIcon = Icons.play_arrow;

  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String currentSong = "";

  Duration duration = new Duration();
  Duration position = new Duration();

  void playMusic(String url) async {
    if (isPlaying && currentSong != url) {
      audioPlayer.pause();
      await audioPlayer.play(UrlSource(url));
      if (audioPlayer.state == PlayerState.playing) {
        setState(() {
          currentSong = url;
        });
      }
    } else if (!isPlaying) {
      await audioPlayer.play(UrlSource(url));
      if (audioPlayer.state == PlayerState.playing) {
        setState(() {
          isPlaying = true;
        });
      }
      audioPlayer.onDurationChanged.listen((event) {
        setState(() {
          duration = event;
        });
      });
    }
    audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF899CCF),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 117, 133, 177),
        title: Text(
          "My Playlist",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 5,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: musicList.length,
                itemBuilder: (context, index) => customListTile(
                      onTap: () {
                        setState(() {
                          currentTitle = musicList[index]['title'];
                          currentCover = musicList[index]['coverUrl'];
                          currentSinger = musicList[index]['singer'];
                        });
                        playMusic(musicList[index]['url']);
                      },
                      title: musicList[index]['title'],
                      singer: musicList[index]['singer'],
                      cover: musicList[index]['coverUrl'],
                    )),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Color(0x55212121),
                blurRadius: 8.0,
              ),
            ]),
            child: Column(
              children: [
                Slider.adaptive(
                  value: position.inSeconds.toDouble(),
                  min: 0.0,
                  max: duration.inSeconds.toDouble(),
                  onChanged: (value) {},
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 8.0, left: 12.0, right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            image: DecorationImage(
                                image: NetworkImage(currentCover))),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentTitle,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              currentSinger,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (isPlaying) {
                            audioPlayer.pause();
                            setState(() {
                              btnIcon = Icons.play_arrow;
                              isPlaying = false;
                            });
                          } else {
                            audioPlayer.resume();
                            setState(() {
                              btnIcon = Icons.pause;
                              isPlaying = true;
                            });
                          }
                        },
                        iconSize: 42.0,
                        icon: Icon(btnIcon),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
