import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Tak1")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image.network(
                'https://picsum.photos/512/512',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SliderExample(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TileWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class SliderExample extends StatefulWidget {
  const SliderExample({super.key});

  @override
  State<SliderExample> createState() => _SliderExampleState();
}

class _SliderExampleState extends State<SliderExample> {
  double _currentSliderPrimaryValue = 0.2;
  double _currentSliderSecondaryValue = 0.5;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Slider(
          value: _currentSliderPrimaryValue,
          secondaryTrackValue: _currentSliderSecondaryValue,
          label: _currentSliderPrimaryValue.round().toString(),
          onChanged: (double value) {
            setState(() {
              _currentSliderPrimaryValue = value;
            });
          },
        ),
        Slider(
          value: _currentSliderSecondaryValue,
          label: _currentSliderSecondaryValue.round().toString(),
          onChanged: (double value) {
            setState(() {
              _currentSliderSecondaryValue = value;
            });
          },
        ),
      ],
    );
  }
}

class Tile {
  String imageURL;
  Alignment alignment;

  Tile({required this.imageURL, required this.alignment});

  Widget croppedImageTile() {
    return FittedBox(
      fit: BoxFit.fill,
      child: ClipRect(
        child: Container(
          child: Align(
            alignment: this.alignment,
            widthFactor: 0.3,
            heightFactor: 0.3,
            child: Image.network(this.imageURL),
          ),
        ),
      ),
    );
  }
}

class TileWidget extends StatelessWidget {
  final Tile tile = Tile(
      imageURL: 'https://picsum.photos/512', alignment: Alignment(0, 0));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.0,
      height: 150.0,
      child: Container(
        margin: EdgeInsets.all(20.0),
        child: InkWell(
          child: tile.croppedImageTile(),
          onTap: () {
            print("Tapped on tile");
          },
        ),
      ),
    );
  }
}
