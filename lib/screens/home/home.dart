import 'package:flavor_house/widgets/input_post.dart';
import 'package:flavor_house/widgets/post_moment.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences pref;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10, right: 20),
        child: Column(children: [
          const InputPost(
              avatarURL:
                  "https://images.ctfassets.net/hrltx12pl8hq/3Mz6t2p2yHYqZcIM0ic9E2/3b7037fe8871187415500fb9202608f7/Man-Stock-Photos.jpg"),
          const SizedBox(
            height: 20,
          ),
          PostMoment(
              fullName: "Juan Toledo",
              username: "ReyDeLaCocina",
              postTitle: "Pastel de chocolate Noruego",
              description: "Es muy delicioso y esponjoso!",
              likes: 80,
              rates: 3,
              isLiked: true,
              isFavorite: true,
              pictureURL:
                  "https://cdn0.recetasgratis.net/es/posts/2/4/9/pastel_de_fresa_23942_orig.jpg",
              avatarURL:
                  "https://images.ctfassets.net/hrltx12pl8hq/3Mz6t2p2yHYqZcIM0ic9E2/3b7037fe8871187415500fb9202608f7/Man-Stock-Photos.jpg")
        ]));
  }
}
