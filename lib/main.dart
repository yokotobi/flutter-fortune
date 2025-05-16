import 'package:flutter/material.dart';
import 'models/character.dart';
import 'services/fortune_service.dart';
import 'screens/fortune_result_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '占いアプリ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const FortuneHomePage(),
    );
  }
}

class FortuneHomePage extends StatefulWidget {
  const FortuneHomePage({super.key});

  @override
  State<FortuneHomePage> createState() => _FortuneHomePageState();
}

class _FortuneHomePageState extends State<FortuneHomePage> {
  List<Character>? _characters;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final characters = await FortuneService.getCharacters();
      setState(() {
        _characters = characters;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('データの読み込みに失敗しました')),
        );
      }
    }
  }

  void _navigateToFortuneResult(Character character) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FortuneResultScreen(character: character),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('今日の運勢'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _characters == null
              ? const Center(child: Text('データを読み込めませんでした'))
              : ListView.builder(
                  itemCount: _characters!.length,
                  itemBuilder: (context, index) {
                    final character = _characters![index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(character.name[0]),
                        ),
                        title: Text(character.name),
                        subtitle: Text(character.description),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => _navigateToFortuneResult(character),
                      ),
                    );
                  },
                ),
    );
  }
}
