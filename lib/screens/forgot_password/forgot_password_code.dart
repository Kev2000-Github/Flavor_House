import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/constants/routes.dart' as routes;
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/common/popups/common.dart';
import 'package:flavor_house/common/popups/forgot_password.dart';
import 'package:flavor_house/services/auth/http_auth_service.dart';
import 'package:flavor_house/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user/user.dart';
import '../../providers/user_provider.dart';
import '../../services/auth/auth_service.dart';
import '../../utils/colors.dart';
import '../../widgets/button.dart';

class ForgotPasswordCodeScreen extends StatefulWidget {
  final String email;
  const ForgotPasswordCodeScreen ({Key? key, required this.email}) : super(key: key);

  @override
  State<ForgotPasswordCodeScreen> createState() => _ForgotPasswordCodeScreenState();
}

class _ForgotPasswordCodeScreenState extends State<ForgotPasswordCodeScreen> {
  final FocusNode _codeFocus = FocusNode();
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.email);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _codeFocus.dispose();
    _codeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: GestureDetector(
      onTap: () {
        _codeFocus.unfocus();
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
                  "CODIGO DE RECUPERACION",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 32),
                const Text(
                  "Introduce el codigo que se ha enviado a tu email para recuperar tu contrasena",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 32),
                TextFieldInput(
                    hintText: "Ingresa el codigo de recuperacion",
                    focusNode: _codeFocus,
                    textInputType: TextInputType.text,
                    textEditingController: _codeController),
                const SizedBox(height: 24),
                Flexible(flex: 2, child: Container()),
                // button login
                Button(
                  text: "Continuar",
                  onPressed: () async {
                    String code = _codeController.value.text;
                    Auth auth = HttpAuth();
                    dartz.Either<Failure, User> result =
                        await auth.code(widget.email!, code);
                    result.fold(
                        (failure) => CommonPopup.alert(context, failure),
                        (user) async {
                          await Provider.of<UserProvider>(context, listen: false).login(user);
                          if(context.mounted) Navigator.of(context).pushNamed(routes.forgot_password_new);
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
