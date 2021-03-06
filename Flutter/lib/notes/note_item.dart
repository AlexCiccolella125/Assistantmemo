import 'dart:async';

import 'package:assistantmemo/services/serverAPI.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:assistantmemo/services/models.dart';
import 'package:just_audio/just_audio.dart' as ap;
import 'package:favorite_button/favorite_button.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  const NoteItem({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: note.note_id,
      child: Card(
        color: Colors.blue,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => NoteScreen(note: note),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: SizedBox(
                      child: Center(
                        child: Icon(Icons.sticky_note_2,
                            color: Colors.black, size: 60),
                      ),
                    ),
                  ),
                  Text(note.classification),
                  StarButton(
                    isStarred: note.is_starred,
                    iconSize: 75.0,
                    // iconDisabledColor: Colors.white,
                    valueChanged: (_isFavorite) {
                      starNote(note.note_id, _isFavorite);
                      // print('Is Favorite : $_isFavorite');
                    },
                  ),
                ],
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    note.text_transcript,
                    style: const TextStyle(
                      height: 1.5,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.fade,
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoteScreen extends StatelessWidget {
  final Note note;

  const NoteScreen({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final path = downloadRecording(note.audio_filename);
    return Scaffold(
      appBar: AppBar(
        title: Text('Note'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(tag: note.note_id, child: Icon(Icons.sticky_note_2, size: 75)),
            Text(note.classification),
            StarButton(
              isStarred: note.is_starred,
              iconSize: 75.0,
              // iconDisabledColor: Colors.white,
              valueChanged: (_isFavorite) {
                starNote(note.note_id, _isFavorite);
                // print('Is Favorite : $_isFavorite');
              },
            ),
          ],
        ),
        Text(
          note.text_transcript,
          style: const TextStyle(
              height: 2, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ReadyPlayer(
          note: note,
        ),
        Categories(
          note: note,
        )
      ]),
    );
  }
}

class Categories extends StatelessWidget {
  Categories({Key? key, required this.note}) : super(key: key);

  final Note note;
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: note.classification,
          ),
          controller: myController,
        ),
        Center(
          child: OutlinedButton(
            child: Text("Add Category"),
            onPressed: () {
              FirestoreService()
                  .updateClassification(note.note_id, (myController.text));
            },
          ),
        )
      ],
    );
  }
}

class ReadyPlayer extends StatelessWidget {
  const ReadyPlayer({
    Key? key,
    required this.note,
  }) : super(key: key);

  final Note note;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: downloadRecording(note.audio_filename),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (snapshot.hasData) {
          String path = snapshot.data!.toString();
          return AudioPlayer(
            note: note,
            source: ap.AudioSource.uri(Uri.parse(path)),
            onDelete: () {},
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('loading', textDirection: TextDirection.ltr);
        } else {
          return Text(
              "Really strange error, there might be missing data in DB");
        }
      },
    );
  }
}

class AudioPlayer extends StatefulWidget {
  /// Path from where to play recorded audio
  final ap.AudioSource source;
  final note;

  /// Callback when audio file should be removed
  /// Setting this to null hides the delete button
  final VoidCallback onDelete;

  const AudioPlayer(
      {required this.source, required this.onDelete, required this.note});

  @override
  AudioPlayerState createState() => AudioPlayerState();
}

class AudioPlayerState extends State<AudioPlayer> {
  static const double _controlSize = 56;
  static const double _deleteBtnSize = 24;

  final _audioPlayer = ap.AudioPlayer();
  late StreamSubscription<ap.PlayerState> _playerStateChangedSubscription;
  late StreamSubscription<Duration?> _durationChangedSubscription;
  late StreamSubscription<Duration> _positionChangedSubscription;

  @override
  void initState() {
    _playerStateChangedSubscription =
        _audioPlayer.playerStateStream.listen((state) async {
      if (state.processingState == ap.ProcessingState.completed) {
        await stop();
      }
      setState(() {});
    });
    _positionChangedSubscription =
        _audioPlayer.positionStream.listen((position) => setState(() {}));
    _durationChangedSubscription =
        _audioPlayer.durationStream.listen((duration) => setState(() {}));
    _init();

    super.initState();
  }

  Future<void> _init() async {
    await _audioPlayer.setAudioSource(widget.source);
  }

  @override
  void dispose() {
    _playerStateChangedSubscription.cancel();
    _positionChangedSubscription.cancel();
    _durationChangedSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          children: <Widget>[
            _buildControl(),
            _buildSlider(constraints.maxWidth),
            IconButton(
              icon: Icon(Icons.delete,
                  color: const Color(0xFF73748D), size: _deleteBtnSize),
              onPressed: () {
                _audioPlayer.stop();
                deleteNote(widget.note.note_id);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/Notes', (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildControl() {
    Icon icon;
    Color color;

    if (_audioPlayer.playerState.playing) {
      icon = Icon(Icons.pause, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.play_arrow, color: theme.primaryColor, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child:
              SizedBox(width: _controlSize, height: _controlSize, child: icon),
          onTap: () {
            if (_audioPlayer.playerState.playing) {
              pause();
            } else {
              play();
            }
          },
        ),
      ),
    );
  }

  Widget _buildSlider(double widgetWidth) {
    final position = _audioPlayer.position;
    final duration = _audioPlayer.duration;
    bool canSetValue = false;
    if (duration != null) {
      canSetValue = position.inMilliseconds > 0;
      canSetValue &= position.inMilliseconds < duration.inMilliseconds;
    }

    double width = widgetWidth - _controlSize - _deleteBtnSize;
    width -= _deleteBtnSize;

    return SizedBox(
      width: width,
      child: Slider(
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: Theme.of(context).colorScheme.secondary,
        onChanged: (v) {
          if (duration != null) {
            final position = v * duration.inMilliseconds;
            _audioPlayer.seek(Duration(milliseconds: position.round()));
          }
        },
        value: canSetValue && duration != null
            ? position.inMilliseconds / duration.inMilliseconds
            : 0.0,
      ),
    );
  }

  Future<void> play() {
    return _audioPlayer.play();
  }

  Future<void> pause() {
    return _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    return _audioPlayer.seek(const Duration(milliseconds: 0));
  }
}
