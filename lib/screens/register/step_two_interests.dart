import 'package:flavor_house/services/register/dummy_register_step_two_service.dart';
import 'package:flavor_house/services/register/register_step_two_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart' as dartz;

import '../../common/error/failures.dart';
import '../../models/interest.dart';
import '../../utils/colors.dart';

List<Interest> interests = [
  Interest("1", "dulce", "assets/images/interest.jpg"),
  Interest("2", "BBQ", "assets/images/interest.jpg"),
  Interest("3", "Frutas", "assets/images/interest.jpg"),
  Interest("4", "Chocolate", "assets/images/interest.jpg"),
  Interest("5", "Proteinas", "assets/images/interest.jpg"),
  Interest("6", "China", "assets/images/interest.jpg"),
  Interest("7", "Japones", "assets/images/interest.jpg"),
  Interest("8", "Papas fritas", "assets/images/interest.jpg"),
];

class StepInterests extends StatefulWidget {
  final Function onFinish;
  const StepInterests({Key? key, required this.onFinish}) : super(key: key);

  @override
  State<StepInterests> createState() => _StepInterestsState();
}

class _StepInterestsState extends State<StepInterests> {
  List<Interest> interests = [];
  List<String> selectedInterests = [];

  void getInterests() async {
    RegisterStepTwo registerService = DummyRegisterStepTwo();
    dartz.Either<Failure, List<Interest>> result = await registerService.getInterests();
    result.fold((l) => null, (interests) {
      setState(() => this.interests = interests);
    });
  }

  @override
  void initState() {
    super.initState();
    getInterests();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "¡Bienvenido a Flavor House!",
          style: TextStyle(
              color: blackColor, fontSize: 25, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "¡cuentanos sobre tus intereses!",
          style: TextStyle(
              color: gray04Color, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 5,
        ),
        const Text(
          "Escoge por lo menos 3 intereses",
          style: TextStyle(
              color: gray04Color, fontSize: 16, fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
            height: MediaQuery.of(context).size.height / 1.6,
            child: GridView.builder(
                itemCount: interests.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (context, index) {
                  return InterestItem(
                      onTap: () {
                        String interestId = interests[index].id;
                        if (selectedInterests.contains(interestId)) {
                          selectedInterests.remove(interests[index].id);
                        } else {
                          selectedInterests.add(interests[index].id);
                        }
                        if (selectedInterests.length >= 3)
                          widget.onFinish(true);
                        else
                          widget.onFinish(false);
                        setState(() {});
                      },
                      interest: interests[index],
                      isSelected:
                          selectedInterests.contains(interests[index].id));
                }))
      ],
    );
  }
}

class InterestItem extends StatelessWidget {
  final Interest interest;
  final bool isSelected;
  final VoidCallback? onTap;
  const InterestItem(
      {Key? key, required this.interest, required this.isSelected, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(image: interest.picture.image, fit: BoxFit.cover)),
        child: Stack(children: [
          Positioned.fill(
              child: Opacity(
                  opacity: 0.3,
                  child: Container(
                    color: whiteColor,
                  ))),
          Positioned.fill(
              child: Opacity(
                  opacity: 0.5,
                  child: Container(
                    color: blackColor,
                  ))),
          Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10),
                  child: Text(
                    interest.name,
                    style: const TextStyle(
                        color: whiteColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ))),
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10),
                  child: Icon(
                    isSelected
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: secondaryColor,
                  )))
        ]),
      ),
    );
  }
}
