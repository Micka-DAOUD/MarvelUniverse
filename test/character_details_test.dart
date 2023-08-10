import 'package:marvel_app/character/character_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Character noDescCharacter = Character(
    description: "",
    name: "The Unknown",
    imageUrl:
        "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg",
  );
  Character descCharacter = Character(
    description: "The man who knows everything",
    name: "The Known",
    imageUrl:
        "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg",
  );

  testWidgets("Specific message shown when there is no given description",
      (tester) async {
    await tester.pumpWidget(CharacterDetailScreen(character: noDescCharacter));

    final noDescriptionFinder = find
        .text("Oops! It seems that there is no info about this super hero...");

    expect(noDescriptionFinder, findsOneWidget);
  });

  testWidgets("Description is correctly diplayed", (tester) async {
    await tester.pumpWidget(CharacterDetailScreen(character: descCharacter));

    final noDescriptionFinder = find
        .text("Oops! It seems that there is no info about this super hero...");

    expect(noDescriptionFinder, findsNothing);
  });
}

class CharacterDetailScreen extends StatelessWidget {
  const CharacterDetailScreen({super.key, required this.character});

  final Character character;
  final noDescriptionText =
      "Oops! It seems that there is no info about this super hero...";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Character Details',
      home: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.red,
              pinned: true,
              expandedHeight: 300,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                expandedTitleScale: 1,
                title: Text(character.name),
              ),
            ),
            SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  character.description == ""
                      ? noDescriptionText
                      : character.description,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
