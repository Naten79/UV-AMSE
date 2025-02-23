import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Fish {
  final String name;
  final String latinName;
  final String family;
  final double adultSize;
  final double adultWeight;
  final String diet;
  final String habitat;
  final String region;
  final String waterTemperature;
  final String description;
  final String image;
  final String type; // Nouveau champ
  final String regime; // Nouveau champ

  Fish({
    required this.name,
    required this.latinName,
    required this.family,
    required this.adultSize,
    required this.adultWeight,
    required this.diet,
    required this.habitat,
    required this.region,
    required this.waterTemperature,
    required this.description,
    required this.image,
    required this.type, // Nouveau champ
    required this.regime, // Nouveau champ
  });

  factory Fish.fromJson(Map<String, dynamic> json) {
    return Fish(
      name: json['name'],
      latinName: json['latinName'],
      family: json['family'],
      adultSize: (json['adultSize'] as num).toDouble(),
      adultWeight: (json['adultWeight'] as num).toDouble(),
      diet: json['diet'],
      habitat: json['habitat'],
      region: json['region'],
      waterTemperature: json['waterTemperature'],
      description: json['description'],
      image: json['image'],
      type: json['type'], // Lecture du nouveau champ
      regime: json['regime'], // Lecture du nouveau champ
    );
  }
}

class MyAppState extends ChangeNotifier {
  List<Fish> fishList = [];
  List<Fish> likedFish = [];
  String selectedHabitat = 'Tous'; // Filtre pour l'habitat
  String selectedRegime = 'Tous'; // Filtre pour le régime

  MyAppState() {
    _loadFishData();
  }

  Future<void> _loadFishData() async {
    try {
      final String response = await rootBundle.loadString('assets/data/poissons.json');
      final List<dynamic> data = json.decode(response);
      fishList = data.map((json) => Fish.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      print('Erreur lors du chargement du JSON: $e');
    }
  }

  void toggleLike(Fish fish) {
    if (likedFish.contains(fish)) {
      likedFish.remove(fish);
    } else {
      likedFish.add(fish);
    }
    notifyListeners();
  }

  List<Fish> get filteredFishList {
    if (fishList.isEmpty) return []; // Ajout d'une vérification ici
    return fishList.where((fish) {
      final habitatMatch = selectedHabitat == 'Tous' || fish.type == selectedHabitat;
      final regimeMatch = selectedRegime == 'Tous' || fish.regime == selectedRegime;
      return habitatMatch && regimeMatch;
    }).toList();
  }

  void setSelectedHabitat(String habitat) {
    selectedHabitat = habitat;
    notifyListeners();
  }

  void setSelectedRegime(String regime) {
    selectedRegime = regime;
    notifyListeners();
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'FishApp',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MyHomePage(),
    LikesPage(),
    AboutPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fish'app"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Likes'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Column(
      children: [
        _buildFilterSection(context),
        Expanded(
          child: appState.fishList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : appState.filteredFishList.isEmpty
                  ? Center(child: Text("Aucun poisson correspondant aux filtres"))
                  : ListView.builder(
                      itemCount: appState.filteredFishList.length,
                      itemBuilder: (context, index) {
                        return FishCard(fish: appState.filteredFishList[index]);
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    var appState = context.watch<MyAppState>();
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DropdownButton<String>(
          value: appState.selectedHabitat,
          items: <String>['Tous', 'Eau douce', 'Eau salée']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              appState.setSelectedHabitat(newValue);
            }
          },
        ),
        DropdownButton<String>(
          value: appState.selectedRegime,
          items: <String>['Tous', 'Herbivore', 'Carnivore', 'Omnivore']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              appState.setSelectedRegime(newValue);
            }
          },
        ),
      ],
    );
  }
}

class LikesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return appState.likedFish.isEmpty
        ? Center(child: Text("Aucun poisson aimé"))
        : ListView.builder(
            itemCount: appState.likedFish.length,
            itemBuilder: (context, index) {
              return FishCard(fish: appState.likedFish[index]);
            },
          );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Application de découverte d'espèces de poissons développée par Nathan DELAUNAY",
        textAlign: TextAlign.center,
      ),
    );
  }
}

class FishCard extends StatelessWidget {
  final Fish fish;

  const FishCard({Key? key, required this.fish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    bool isLiked = appState.likedFish.contains(fish);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FishDetailPage(fish: fish),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(10),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.asset(
                fish.image,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      fish.name,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      appState.toggleLike(fish);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FishDetailPage extends StatelessWidget {
  final Fish fish;

  const FishDetailPage({Key? key, required this.fish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(fish.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
              child: Image.asset(
                fish.image,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fish.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Nom latin: ${fish.latinName}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Famille: ${fish.family}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Taille adulte: ${fish.adultSize} cm',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Masse adulte: ${fish.adultWeight} kg',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Régime alimentaire: ${fish.diet}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Habitat: ${fish.habitat}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Région: ${fish.region}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Température: ${fish.waterTemperature}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Description:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    fish.description,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
