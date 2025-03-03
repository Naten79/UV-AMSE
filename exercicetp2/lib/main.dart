import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
              child: Text("Menu", style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: const Text("Exo 1 - Image Simple"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Exo1Screen()));
              },
            ),
            ListTile(
              title: const Text("Exo 2 - Transformations"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Exo2Screen()));
              },
            ),
            ListTile(
              title: const Text("Exo 4 - Affichage d'une tuile"), // Ajoute ton Exo 4 ici
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Exo4Screen()));
              },
            ),
            ListTile(
              title: const Text("Exo 5 - Plateau de tuiles"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Exo5Screen()));
              },
            ),
          ],
        ),
      ),
      body: const Center(child: Text("Sélectionnez un exercice dans le menu.")),
    );
  }
}

// 📌 Exo 1 : Affichage simple de l'image
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

// 📌 Exo 2 : Transformations avec Sliders
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
                transform: Matrix4.identity()
                  ..rotateZ(_rotation)
                  ..scale(_mirror ? -_scale : _scale, _scale),
                child: Image.network('https://picsum.photos/512', fit: BoxFit.cover),
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
          SwitchListTile(
            title: const Text("Effet miroir"),
            value: _mirror,
            onChanged: (value) => setState(() => _mirror = value),
          ),
        ],
      ),
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
    Tile tile = Tile(
      imageURL: 'https://picsum.photos/512',
      alignment: const Alignment(0, 0),
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
              child: Image.network('https://picsum.photos/512', fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }

  Widget createTileWidgetFrom(Tile tile) {
    return InkWell(
      child: tile.croppedImageTile(),
      onTap: () {
        debugPrint("Tuile cliquée !");
      },
    );
  }
}

// 📌 Exo 5 : Plateau de tuiles
class Exo5Screen extends StatefulWidget {
  const Exo5Screen({super.key});

  @override
  _Exo5ScreenState createState() => _Exo5ScreenState();
}

class _Exo5ScreenState extends State<Exo5Screen> {
  int _gridSize = 3; // Taille du plateau (3x3 par défaut)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exo 5 - Plateau de tuiles")),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _gridSize,
                childAspectRatio: 1,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: _gridSize * _gridSize,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Tuile ${index + 1}",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text("Taille du plateau :", style: TextStyle(fontSize: 18)),
                Slider(
                  min: 2,
                  max: 6,
                  divisions: 4,
                  value: _gridSize.toDouble(),
                  onChanged: (value) {
                    setState(() => _gridSize = value.toInt());
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
}
