import 'dart:io';

import 'package:flavor_house/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/user/user.dart';
import '../../utils/colors.dart';
import '../../widgets/Avatar.dart';
import '../../widgets/button.dart';

class CreatePostMomentScreen extends StatefulWidget {
  const CreatePostMomentScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostMomentScreen> createState() => _CreatePostMomentScreenState();
}

class _CreatePostMomentScreenState extends State<CreatePostMomentScreen> {
  String imagePath="";
  User? user;
  final FocusNode _textFocus = FocusNode();
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _textFocus.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderSide: Divider.createBorderSide(context)
    );
    user = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: AppBar(
              toolbarHeight: 80,
              flexibleSpace: Container(),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                "Crear Publicación",
                style: TextStyle(
                    color: blackColor, fontSize: 28, fontWeight: FontWeight.w600),
              ),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close, size: 24,color: blackColor,)),
            )
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                   Avatar(
                      pictureHeight: 90,
                      borderSize: 2,
                      image: user?.picture),
                    const SizedBox(height: 25),
                    TextField(
                      decoration:
                      InputDecoration(
                        hintText:"Agrega un comentario",
                        border: inputBorder,
                        focusedBorder: inputBorder,
                        enabledBorder: inputBorder,
                        filled: true,
                        contentPadding: const EdgeInsets.all(8),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: null,
                      obscureText: false,
                    ),
                const SizedBox(height: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      (imagePath=="")?Container():Image.file(File(imagePath), width: 250, height: 250),
                      IconButton(
                          iconSize: 70,
                          onPressed:() async {
                            final ImagePicker picker = ImagePicker();
                            XFile? pickedFile =
                            await picker.pickImage(source: ImageSource.gallery);
                            imagePath = pickedFile?.path ?? "";
                            setState((){
                            });
                          },
                          icon: const Icon(Icons.image, size: 70,color: gray03Color,)),
                    ]
                  ),
                Button(
                    text: "Publicar",
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    borderSide: null,
                    backgroundColor: primaryColor,
                    textColor: whiteColor,
                    size: const Size.fromHeight(50)),
                const SizedBox(height: 25),
            ]
          )

        )
    );
  }
}
