import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/constants/routes.dart' as routes;
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/common/popups/forgot_password.dart';
import 'package:flavor_house/services/auth/dummy_auth_service.dart';
import 'package:flavor_house/services/auth/http_auth_service.dart';
import 'package:flavor_house/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user/user.dart';
import '../../providers/user_provider.dart';
import '../../services/auth/auth_service.dart';
import '../../utils/colors.dart';
import '../../widgets/button.dart';

class ForgotPasswordNewScreen extends StatefulWidget {
  const ForgotPasswordNewScreen ({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordNewScreen> createState() => _ForgotPasswordNewScreenState();
}

class _ForgotPasswordNewScreenState extends State<ForgotPasswordNewScreen> {
  final FocusNode _newPasswordFocus = FocusNode();
  final TextEditingController _newPasswordController = TextEditingController();
  final FocusNode _repeatNewPasswordFocus = FocusNode();
  final TextEditingController _repeatNewPasswordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _newPasswordFocus.dispose();
    _newPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: GestureDetector(
      onTap: () {
        _newPasswordFocus.unfocus();
      },
      child: Stack(
        children: [
          Align(
              alignment: AlignmentDirectional.topStart,
              child: Container(
                  margin: const EdgeInsets.only(top: 25),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      }, icon: const Icon(Icons.close, size: 24)))),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: Column(children: [
                // svg image
                // text field input for email
                const SizedBox(height: 32),
                const Text(
                  "NUEVA CONTRASEÑA",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 32),
                const Text(
                  "Introduce tu nueva contraseña",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 32),
                TextFieldInput(
                    hintText: "Nueva contraseña",
                    focusNode: _newPasswordFocus,
                    textInputType: TextInputType.text,
                    textEditingController: _newPasswordController),
                const SizedBox(height: 24),
                TextFieldInput(
                    hintText: "Repite la contraseña",
                    focusNode: _repeatNewPasswordFocus,
                    textInputType: TextInputType.text,
                    textEditingController: _repeatNewPasswordController),
                Flexible(flex: 2, child: Container()),
                // button login
                Button(
                  text: "Continuar",
                  onPressed: () async {
                    String password = _newPasswordController.value.text;
                    //TODO: Beware this is a dummy implementation!
                    Auth auth = HttpAuth();
                    dartz.Either<Failure, User> result =
                        await auth.NewPassword(password);
                    result.fold(
                        (failure) {
                          if(failure.runtimeType == PasswordEmpty){
                            ForgotPasswordPopup.PasswordEmpty(context);
                          }
                        },
                        (user) async {
                          ForgotPasswordPopup.Passwordsucessful(context, () async {
                            await Provider.of<UserProvider>(context, listen: false).login(user);
                            Navigator.of(context).pushNamed(routes.main_screen);
                          });
                        });
                  },
                  borderSide: null,
                  backgroundColor: primaryColor,
                  textColor: whiteColor,
                  size: const Size.fromHeight(50),
                ),
                const SizedBox(height: 24),
              ]))
        ],
      ),
    )));
  }
}
