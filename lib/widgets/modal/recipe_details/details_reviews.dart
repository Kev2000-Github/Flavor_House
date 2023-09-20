import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/constants/routes.dart' as routes;
import 'package:flavor_house/common/popups/common.dart';
import 'package:flavor_house/services/paginated.dart';
import 'package:flavor_house/services/reviews/reviews_service.dart';
import 'package:flutter/material.dart';

import '../../../common/error/failures.dart';
import '../../../models/post/review.dart';
import '../../../services/reviews/http_reviews_service.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_themes.dart';
import '../../../utils/time.dart';
import '../../button.dart';
import '../../stars.dart';
import '../text_input.dart';

class Reviews extends StatefulWidget {
  final String recipeId;
  const Reviews({super.key, required this.recipeId});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  List<Review> reviews = [];
  ValueNotifier<int> starsValueNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    getReviews();
  }

  @override
  void dispose() {
    super.dispose();
    starsValueNotifier.dispose();
  }

  void getReviews() async {
    ReviewService reviewService = HttpReviewService();
    dartz.Either<Failure, Paginated<Review>> result =
        await reviewService.getReviews(widget.recipeId);
    result.fold((l) => null, (Paginated<Review> reviews) {
      setState(() {
        this.reviews = reviews.getData();
      });
    });
  }

  void createReview(String content, int stars) async {
    ReviewService reviewService = HttpReviewService();
    dartz.Either<Failure, Review> result = await reviewService.createReview(widget.recipeId, content, stars);
    result.fold((l) => CommonPopup.alert(context, l), (review) {
      setState(() {
        reviews.insert(0, review);
      });
    });
  }

  void onOpenTextInput(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => TextInputModalContent(
              onSend: (String comment) {
                createReview(comment, starsValueNotifier.value);
              },
              child: ValueListenableBuilder(
                valueListenable: starsValueNotifier,
                builder: (context, value, _) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (starsValueNotifier.value > 0) starsValueNotifier.value -= 1;
                      },
                      icon: const Icon(Icons.arrow_back_ios), color: yellowColor,),
                    StarsRating(rate: starsValueNotifier.value),
                    IconButton(
                        onPressed: () {
                          if (starsValueNotifier.value < 5) starsValueNotifier.value += 1;
                        },
                        icon: const Icon(Icons.arrow_forward_ios), color: yellowColor)
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Button(
              onPressed: () {
                onOpenTextInput(context);
              },
              text: "Agrega una reseña...",
              borderSide: const BorderSide(color: gray01Color, width: 2),
              borderRadius: BorderRadius.circular(10),
              size: const Size.fromHeight(45),
              fontSize: 14,
              textColor: gray03Color,
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
            children: List.generate(
                reviews.length,
                (index) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.done_all, size: 28, color: darkColor),
                      const SizedBox(width: 5),
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.end,
                                  spacing: 10,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(routes.other_user_profile,
                                              arguments: reviews[index].userId);
                                        },
                                        child: Text(
                                          reviews[index].fullName,
                                          style: DesignTextTheme.get(
                                              type: TextThemeEnum.darkSemiMedium),
                                        )
                                    ),
                                    Text(formatTimeAgo(reviews[index].createdAt),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: gray04Color,
                                            fontSize: 12))
                                  ],
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Text(reviews[index].review),
                                ),
                                StarsRating(
                                    rate: reviews[index].stars, size: 20)
                              ],
                            )
                          )
                      )
                    ])),
          )))
        ],
      ),
    );
  }
}
