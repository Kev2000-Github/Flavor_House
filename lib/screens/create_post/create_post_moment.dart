import 'dart:io';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/popups/common.dart';
import 'package:flavor_house/models/post/moment.dart';
import 'package:flavor_house/providers/user_provider.dart';
import 'package:flavor_house/services/post/http_post_service.dart';
import 'package:flavor_house/widgets/conditional.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../common/error/failures.dart';
import '../../models/user/user.dart';
import '../../services/post/post_service.dart';
import '../../utils/colors.dart';
import '../../widgets/Avatar.dart';
import '../../widgets/button.dart';

class CreatePostMomentScreen extends StatefulWidget {
  final Moment? post;
  const CreatePostMomentScreen({Key? key, this.post}) : super(key: key);

  @override
  State<CreatePostMomentScreen> createState() => _CreatePostMomentScreenState();
}

class _CreatePostMomentScreenState extends State<CreatePostMomentScreen> {
  Image? image;
  String? imageURI;
  User? user;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _textFocus = FocusNode();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.value =
        TextEditingValue(text: widget.post?.description ?? "");
    image = widget.post?.pictureURL != null ? widget.post?.picture : null;
    imageURI = widget.post?.pictureURL;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _textFocus.dispose();
    _textController.dispose();
  }

  void createPost() async {
    PostService postService = HttpPost();
    dartz.Either<Failure, Moment> result = await postService.createMoment(
      description: _textController.text,
      imageURI: imageURI
    );
    result.fold((l) => CommonPopup.alert(context, l), (moment) {
      Navigator.pop(context, moment);
    });
  }

  void updatePost() async {
    PostService postService = HttpPost();
    dartz.Either<Failure, Moment> result = await postService.updateMoment(
        id: widget.post!.id,
        description: _textController.text,
        imageURI: imageURI,
    );
    result.fold((l) => CommonPopup.alert(context, l), (moment) {
      Navigator.pop(context, moment);
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
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
                    color: blackColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w600),
              ),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 24,
                    color: blackColor,
                  )),
            )),
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Avatar(
                        pictureHeight: 90, borderSize: 2, image: user?.picture),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: _textController,
                      validator: (val) {
                        if(val == null || val.isEmpty) return 'Descripcion vacia';
                        if(val.length < 10) return 'La descripcion debe tener como minimo 10 caracteres';
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Dime, que quieres compartir?",
                        border: inputBorder,
                        focusedBorder: inputBorder,
                        enabledBorder: inputBorder,
                        filled: true,
                        contentPadding: const EdgeInsets.all(8),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 5,
                      obscureText: false,
                    ),
                    const SizedBox(height: 25),
                    Conditional(
                      condition: image != null,
                      positive: Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: image)
                      ),
                    ),
                    const Divider(height: 1, thickness: 1.5, color: gray02Color),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              iconSize: 40,
                              splashRadius: 25,
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                XFile? pickedFile = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if(pickedFile == null) return;
                                imageURI = pickedFile.path;
                                image = Image.file(File(pickedFile.path));
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.photo_outlined,
                                color: gray03Color,
                              ))
                        ]
                    ),
                    Button(
                        text: widget.post != null ? "Editar" : "Publicar",
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            if(widget.post != null) {
                              updatePost();
                            } else {
                              createPost();
                            }
                          }
                        },
                        borderSide: null,
                        backgroundColor: primaryColor,
                        textColor: whiteColor,
                        size: const Size.fromHeight(50)),
                    const SizedBox(height: 25),
                  ])
            )));
  }
}
