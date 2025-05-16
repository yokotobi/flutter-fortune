import 'package:flutter/material.dart';
import '../models/character.dart';
import '../models/fortune.dart';
import '../services/fortune_service.dart';

class FortuneResultScreen extends StatefulWidget {
  final Character character;

  const FortuneResultScreen({
    super.key,
    required this.character,
  });

  @override
  State<FortuneResultScreen> createState() => _FortuneResultScreenState();
}

class _FortuneResultScreenState extends State<FortuneResultScreen> {
  Fortune? _fortune;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getFortune();
  }

  Future<void> _getFortune() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final fortune = await FortuneService.getRandomFortune();
      setState(() {
        _fortune = fortune;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('占い結果の取得に失敗しました')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.character.name}さんの運勢'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _fortune == null
              ? const Center(child: Text('占い結果を取得できませんでした'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _fortune!.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _fortune!.description,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '詳細な運勢',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 16),
                                _buildFortuneItem('恋愛運', _fortune!.love),
                                const Divider(),
                                _buildFortuneItem('仕事運', _fortune!.work),
                                const Divider(),
                                _buildFortuneItem('健康運', _fortune!.health),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('もう一度占う'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildFortuneItem(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
