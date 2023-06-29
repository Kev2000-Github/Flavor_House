import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/providers/user_provider.dart';
import 'package:flavor_house/services/auth/dummy_auth_service.dart';
import 'package:flavor_house/utils/cache.dart';
import 'package:flavor_house/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flavor_house/common/constants/routes.dart' as routes;
import 'package:flavor_house/common/popups/login.dart';
import 'package:provider/provider.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../models/user.dart';
import '../../services/auth/auth_service.dart';
import '../../utils/colors.dart';
import '../../widgets/button.dart';
import '../../widgets/Avatar.dart';
import '../../utils/colors.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  String imagePath="";
  User? user;
  final FocusNode _TextFocus = FocusNode();
  final TextEditingController _TextController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _TextFocus.dispose();
    _TextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderSide: Divider.createBorderSide(context)
    );
    user = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: AppBar(
              toolbarHeight: 80,
              flexibleSpace: Container(),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                "Crear Publicación",
                style: TextStyle(
                    color: blackColor, fontSize: 32, fontWeight: FontWeight.w600),
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
                      imageURL: user?.picture ?? ""),
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
                  Container(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children:[
                         (imagePath=="")?Container():Image.file(File(imagePath), width: 250, height: 250),
                         IconButton(
                             iconSize: 70,
                             onPressed:() async {
                               final ImagePicker _picker = ImagePicker();
                               XFile? _pickedFile =
                               await _picker.pickImage(source: ImageSource.gallery);
                               imagePath = _pickedFile?.path ?? "";
                               setState((){
                               });
                             },
                             icon: const Icon(Icons.image, size: 70,color: gray03Color,)),
                       ]
                     )),
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
