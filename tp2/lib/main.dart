import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transformations d\'Images',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transformations d'Images")),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text("Exo 1 - Image Simple"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Exo1Screen()),
                );
              },
            ),
            ListTile(
              title: const Text("Exo 2 - Transformations"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Exo2Screen()),
                );
              },
            ),
            ListTile(
              title: const Text("Exo 4 - Affichage d'une tuile"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Exo4Screen()),
                );
              },
            ),
            ListTile(
              title: const Text("Exo 5 - Plateau de tuiles"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Exo5Screen()),
                );
              },
            ),
            ListTile(
              title: const Text("Exo 6 - Échange de tuiles d'image"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Exo6Screen()),
                );
              },
            ),
            ListTile(
              title: const Text("Exo 7 - Jeu de taquin"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Exo7Screen()),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(child: Text("Sélectionnez un exercice dans le menu.")),
    );
  }
}

class Exo1Screen extends StatelessWidget {
  const Exo1Screen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exo 1 - Image Simple")),
      body: Center(
        child: Image.network(
          'https://picsum.photos/512/1024',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class Exo2Screen extends StatefulWidget {
  const Exo2Screen({super.key});
  @override
  _Exo2ScreenState createState() => _Exo2ScreenState();
}

class _Exo2ScreenState extends State<Exo2Screen> {
  double _rotation = 0;
  double _scale = 1;
  bool _mirror = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exo 2 - Transformations")),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Transform(
                alignment: Alignment.center,
                transform:
                    Matrix4.identity()
                      ..rotateZ(_rotation)
                      ..scale(_mirror ? -_scale : _scale, _scale),
                child: Image.network(
                  'https://picsum.photos/512',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Slider(
            min: -3.14,
            max: 3.14,
            value: _rotation,
            onChanged: (value) => setState(() => _rotation = value),
          ),
          Slider(
            min: 0.5,
            max: 2,
            value: _scale,
            onChanged: (value) => setState(() => _scale = value),
          ),
        ],
      ),
    );
  }
}

class ImageTile {
  String imageURL;
  Alignment alignment;
  ImageTile({required this.imageURL, required this.alignment});

  Widget croppedImageTile() {
    return FittedBox(
      fit: BoxFit.fill,
      child: ClipRect(
        child: Align(
          alignment: alignment,
          widthFactor: 0.3,
          heightFactor: 0.3,
          child: Image.network(imageURL),
        ),
      ),
    );
  }
}

class Exo4Screen extends StatelessWidget {
  const Exo4Screen({super.key});
  @override
  Widget build(BuildContext context) {
    ImageTile tile = ImageTile(
      imageURL: 'https://picsum.photos/512',
      alignment: Alignment.center,
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Exo 4 - Tuile d'image")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150.0,
              height: 150.0,
              child: Container(
                margin: const EdgeInsets.all(20.0),
                child: createTileWidgetFrom(tile),
              ),
            ),
            SizedBox(
              height: 200,
              child: Image.network(
                'https://picsum.photos/512',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createTileWidgetFrom(ImageTile tile) {
    return InkWell(
      child: tile.croppedImageTile(),
      onTap: () {
        debugPrint("Tuile cliquée !");
      },
    );
  }
}

class Exo5Screen extends StatefulWidget {
  const Exo5Screen({super.key});
  @override
  _Exo5ScreenState createState() => _Exo5ScreenState();
}

class _Exo5ScreenState extends State<Exo5Screen> {
  int gridSize = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exo 5 - Plateau de tuiles")),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<ui.Image>(
              future: loadImage('https://picsum.photos/512'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("Erreur de chargement de l'image"),
                  );
                } else {
                  return buildGrid(snapshot.data!);
                }
              },
            ),
          ),
          Slider(
            min: 2,
            max: 7,
            divisions: 5,
            value: gridSize.toDouble(),
            onChanged: (value) {
              setState(() {
                gridSize = value.toInt();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildGrid(ui.Image image) {
    double tileSize = image.width / gridSize;
    return GridView.builder(
      padding: const EdgeInsets.all(2.0),
      itemCount: gridSize * gridSize,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridSize,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
      ),
      itemBuilder: (context, index) {
        int row = index ~/ gridSize;
        int col = index % gridSize;
        return ClipRect(
          child: CustomPaint(
            size: Size(tileSize, tileSize),
            painter: ImageTilePainter(image, row, col, tileSize),
          ),
        );
      },
    );
  }

  Future<ui.Image> loadImage(String url) async {
    final completer = Completer<ui.Image>();
    final image = NetworkImage(url);
    final stream = image.resolve(const ImageConfiguration());
    stream.addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(info.image);
      }),
    );
    return completer.future;
  }
}

class ImageTilePainter extends CustomPainter {
  final ui.Image image;
  final int row, col;
  final double tileSize;
  ImageTilePainter(this.image, this.row, this.col, this.tileSize);
  @override
  void paint(Canvas canvas, Size size) {
    Rect srcRect = Rect.fromLTWH(
      col * tileSize,
      row * tileSize,
      tileSize,
      tileSize,
    );
    Rect dstRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(image, srcRect, dstRect, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Exo6Screen extends StatefulWidget {
  const Exo6Screen({super.key});
  @override
  _Exo6ScreenState createState() => _Exo6ScreenState();
}

class _Exo6ScreenState extends State<Exo6Screen> {
  int _gridSize = 2;
  List<int> _tileIndices = [];
  int? _selectedTileIndex;

  @override
  void initState() {
    super.initState();
    _initTiles();
  }

  void _initTiles() {
    _tileIndices = List.generate(_gridSize * _gridSize, (index) => index);
  }

  void _handleTileTap(int index) {
    setState(() {
      if (_selectedTileIndex == null) {
        _selectedTileIndex = index;
      } else if (_selectedTileIndex == index) {
        _selectedTileIndex = null;
      } else {
        int row1 = _selectedTileIndex! ~/ _gridSize;
        int col1 = _selectedTileIndex! % _gridSize;
        int row2 = index ~/ _gridSize;
        int col2 = index % _gridSize;
        if ((row1 - row2).abs() + (col1 - col2).abs() == 1) {
          int temp = _tileIndices[index];
          _tileIndices[index] = _tileIndices[_selectedTileIndex!];
          _tileIndices[_selectedTileIndex!] = temp;
          _selectedTileIndex = null;
        } else {
          _selectedTileIndex = index;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exo 6 - Échange de tuiles d'image")),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<ui.Image>(
              future: loadImage('https://picsum.photos/512'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("Erreur de chargement de l'image"),
                  );
                } else {
                  return buildSwapGrid(snapshot.data!);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text(
                  "Taille du plateau :",
                  style: TextStyle(fontSize: 18),
                ),
                Slider(
                  min: 2,
                  max: 6,
                  divisions: 4,
                  value: _gridSize.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      _gridSize = value.toInt();
                      _initTiles();
                    });
                  },
                  label: "$_gridSize x $_gridSize",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSwapGrid(ui.Image image) {
    double tileSize = image.width / _gridSize;
    return GridView.builder(
      key: ValueKey(_tileIndices.join(',')),
      padding: const EdgeInsets.all(10),
      itemCount: _gridSize * _gridSize,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _gridSize,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (context, index) {
        int tileNumber = _tileIndices[index];
        int sourceRow = tileNumber ~/ _gridSize;
        int sourceCol = tileNumber % _gridSize;
        BoxDecoration decoration = const BoxDecoration();
        if (_selectedTileIndex != null) {
          int selectedRow = _selectedTileIndex! ~/ _gridSize;
          int selectedCol = _selectedTileIndex! % _gridSize;
          if (index == _selectedTileIndex) {
            decoration = BoxDecoration(
              border: Border.all(color: Colors.blue, width: 3),
            );
          } else {
            int row = index ~/ _gridSize;
            int col = index % _gridSize;
            if ((selectedRow - row).abs() + (selectedCol - col).abs() == 1) {
              decoration = BoxDecoration(
                border: Border.all(color: Colors.red, width: 3),
              );
            }
          }
        }
        return GestureDetector(
          onTap: () => _handleTileTap(index),
          child: Container(
            decoration: decoration,
            child: ClipRect(
              child: CustomPaint(
                size: Size(tileSize, tileSize),
                painter: ImageTileSwapPainter(
                  image,
                  sourceRow,
                  sourceCol,
                  tileSize,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<ui.Image> loadImage(String url) async {
    final completer = Completer<ui.Image>();
    final image = NetworkImage(url);
    final stream = image.resolve(const ImageConfiguration());
    stream.addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(info.image);
      }),
    );
    return completer.future;
  }
}

class ImageTileSwapPainter extends CustomPainter {
  final ui.Image image;
  final int sourceRow, sourceCol;
  final double tileSize;
  ImageTileSwapPainter(
    this.image,
    this.sourceRow,
    this.sourceCol,
    this.tileSize,
  );
  @override
  void paint(Canvas canvas, Size size) {
    Rect srcRect = Rect.fromLTWH(
      sourceCol * tileSize,
      sourceRow * tileSize,
      tileSize,
      tileSize,
    );
    Rect dstRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(image, srcRect, dstRect, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Exo7Screen extends StatefulWidget {
  const Exo7Screen({super.key});
  @override
  _Exo7ScreenState createState() => _Exo7ScreenState();
}

class _Exo7ScreenState extends State<Exo7Screen> {
  int _gridSize = 2;
  List<int> _tiles = [];
  int _moveCount = 0;
  List<List<int>> _history = [];
  bool _solved = false;

  late Future<ui.Image> _imageFuture;

  @override
  void initState() {
    super.initState();
    _initBoard();
    _loadNewImage();
  }

  
  void _loadNewImage() {
    String url = 'https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch}/512';
    _imageFuture = _loadImage(url);
  }

  void _initBoard() {
    _tiles = _solvedState();
    _moveCount = 0;
    _history = [];
    _solved = true;
  }

  List<int> _solvedState() {
    List<int> state = List.generate(_gridSize * _gridSize, (index) => index);
    state[_gridSize * _gridSize - 1] = -1;
    return state;
  }

  int _emptyTileIndex() {
    return _tiles.indexWhere((element) => element == -1);
  }

  bool _canMove(int index) {
    int emptyIndex = _emptyTileIndex();
    int rowEmpty = emptyIndex ~/ _gridSize;
    int colEmpty = emptyIndex % _gridSize;
    int rowTile = index ~/ _gridSize;
    int colTile = index % _gridSize;
    return ((rowEmpty - rowTile).abs() + (colEmpty - colTile).abs() == 1);
  }

  void _moveTile(int index) {
    if (!_canMove(index)) return;
    setState(() {
      _history.add(List.from(_tiles));
      int emptyIndex = _emptyTileIndex();
      int temp = _tiles[index];
      _tiles[index] = _tiles[emptyIndex];
      _tiles[emptyIndex] = temp;
      _moveCount++;
      _solved = _checkSolved();
    });
  }

  bool _checkSolved() {
    List<int> solved = _solvedState();
    for (int i = 0; i < _tiles.length; i++) {
      if (_tiles[i] != solved[i]) return false;
    }
    return true;
  }

  void _undoMove() {
    if (_history.isNotEmpty) {
      setState(() {
        _tiles = _history.removeLast();
        _moveCount--;
        _solved = _checkSolved();
      });
    }
  }

  int _inversionCount(List<int> tiles) {
    int invCount = 0;
    for (int i = 0; i < tiles.length; i++) {
      for (int j = i + 1; j < tiles.length; j++) {
        if (tiles[i] != -1 && tiles[j] != -1 && tiles[i] > tiles[j]) {
          invCount++;
        }
      }
    }
    return invCount;
  }

  bool _isSolvable(List<int> tiles) {
    int invCount = _inversionCount(tiles);
    if (_gridSize % 2 == 1) {
      return invCount % 2 == 0;
    } else {

      int emptyIndex = _emptyTileIndex();
      int blankRowFromTop = emptyIndex ~/ _gridSize;
      int blankRowFromBottom = _gridSize - blankRowFromTop;
      return ((invCount + blankRowFromBottom) % 2 == 1);
    }
  }

  void _shuffleBoard() {
    setState(() {
      List<int> newTiles;
      do {
        List<int> permutation = List.generate(
          _gridSize * _gridSize - 1,
          (i) => i,
        );
        permutation.shuffle();
        newTiles = List.from(permutation);
        newTiles.add(-1);
      } while (!_isSolvable(newTiles));
      _tiles = newTiles;
      _moveCount = 0;
      _history = [];
      _solved = _checkSolved();
    });
  }

  Future<ui.Image> _loadImage(String url) async {
    final completer = Completer<ui.Image>();
    final image = NetworkImage(url);
    final stream = image.resolve(const ImageConfiguration());
    stream.addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(info.image);
      }),
    );
    return completer.future;
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exo 7 - Jeu de taquin")),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<ui.Image>(
              future: _imageFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Erreur de chargement de l'image"));
                } else {
                  if (_solved) {
                    return Center(
                      child: RawImage(
                        image: snapshot.data,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    );
                  } else {
                    return _buildBoard(snapshot.data!);
                  }
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Nombre de déplacements: $_moveCount"),
          ),
          if (_solved)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Félicitations, vous avez gagné!",
                style: TextStyle(color: Colors.green, fontSize: 20),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _undoMove,
                child: const Text("Annuler"),
              ),
              ElevatedButton(
                onPressed: _shuffleBoard,
                child: const Text("Génerer taquin"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _loadNewImage();
                    _initBoard();
                  });
                },
                child: const Text("Changer d'image"),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text("Taille du plateau:"),
              Slider(
                min: 2,
                max: 6,
                divisions: 3,
                value: _gridSize.toDouble(),
                label: "$_gridSize x $_gridSize",
                onChanged: (value) {
                  setState(() {
                    _gridSize = value.toInt();
                    _initBoard();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildBoard(ui.Image image) {
    double tileSize = image.width / _gridSize;
    return GridView.builder(
      key: ValueKey(_tiles.join(',')),
      padding: const EdgeInsets.all(8.0),
      itemCount: _tiles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _gridSize,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        int tileValue = _tiles[index];
        if (tileValue == -1) {
          return Container(color: Colors.grey[300]);
        } else {
          int sourceRow = tileValue ~/ _gridSize;
          int sourceCol = tileValue % _gridSize;
          return GestureDetector(
            onTap: () {
              _moveTile(index);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: ClipRect(
                child: CustomPaint(
                  size: Size(tileSize, tileSize),
                  painter: ImageTileSwapPainter(
                    image,
                    sourceRow,
                    sourceCol,
                    tileSize,
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

