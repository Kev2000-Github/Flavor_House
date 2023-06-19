
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/interest.dart';
import '../../utils/colors.dart';
import '../../widgets/button.dart';

List<Interest> interests = [
  new Interest("1", "dulce",
      "https://cookingformysoul.com/wp-content/uploads/2023/05/feat-spatchcock-bbq-chicken-min.jpg"),
  new Interest("2", "BBQ",
      "https://cookingformysoul.com/wp-content/uploads/2023/05/feat-spatchcock-bbq-chicken-min.jpg"),
  new Interest("3", "Frutas",
      "https://cookingformysoul.com/wp-content/uploads/2023/05/feat-spatchcock-bbq-chicken-min.jpg"),
  new Interest("4", "Chocolate",
      "https://cookingformysoul.com/wp-content/uploads/2023/05/feat-spatchcock-bbq-chicken-min.jpg"),
  new Interest("5", "Proteinas",
      "https://cookingformysoul.com/wp-content/uploads/2023/05/feat-spatchcock-bbq-chicken-min.jpg"),
  new Interest("6", "China",
      "https://cookingformysoul.com/wp-content/uploads/2023/05/feat-spatchcock-bbq-chicken-min.jpg"),
  new Interest("7", "Japones",
      "https://cookingformysoul.com/wp-content/uploads/2023/05/feat-spatchcock-bbq-chicken-min.jpg"),
  new Interest("8", "Papas fritas",
      "https://cookingformysoul.com/wp-content/uploads/2023/05/feat-spatchcock-bbq-chicken-min.jpg"),
];

class StepInterests extends StatefulWidget {
  final Function onFinish;
  const StepInterests({Key? key, required this.onFinish}) : super(key: key);

  @override
  State<StepInterests> createState() => _StepInterestsState();
}

class _StepInterestsState extends State<StepInterests> {
  List<String> selectedInterests = [];

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
                        if(selectedInterests.contains(interestId)){
                          selectedInterests.remove(interests[index].id);
                        }
                        else{
                          selectedInterests.add(interests[index].id);
                        }
                        if(selectedInterests.length >= 3) widget.onFinish(true);
                        else widget.onFinish(false);
                        setState(() {

                        });
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
            image: DecorationImage(
                image: NetworkImage(interest.picURL ?? ""), fit: BoxFit.cover)),
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