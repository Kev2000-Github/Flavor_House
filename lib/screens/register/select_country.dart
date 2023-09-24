import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/country.dart';
import 'package:flavor_house/services/paginated.dart';
import 'package:flavor_house/services/register/http_register_step_two_service.dart';
import 'package:flavor_house/services/register/register_step_two_service.dart';
import 'package:flavor_house/widgets/listview_infinite_loader.dart';
import 'package:flutter/material.dart';

import '../../common/popups/common.dart';
import '../../utils/colors.dart';

class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({super.key});

  @override
  State<SelectCountryScreen> createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {
  Paginated<Country> countries = Paginated.initial();
  bool _loadingMore = false;

  void getCountries(Function(bool) setLoadingState) async {
    if (mounted) setLoadingState(true);
    RegisterStepTwo registerService = HttpRegisterStepTwo();
    dartz.Either<Failure, Paginated<Country>> result =
        await registerService.getCountries(
            page: countries.isNotEmpty ? countries.page + 1 : 1
        );
    result.fold((failure) {
      if (mounted) setLoadingState(false);
      CommonPopup.alert(context, failure);
    }, (newCountries) {
      if (mounted) setLoadingState(false);
      setState(() {
        countries.addPage(newCountries);
      });
    });
  }

  void setLoadingMoreState(bool state) {
    setState(() {
      _loadingMore = state;
    });
  }

  @override
  void initState() {
    super.initState();
    getCountries(setLoadingMoreState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            flexibleSpace: Container(),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Pais",
              style: TextStyle(
                  color: blackColor, fontSize: 28, fontWeight: FontWeight.w500),
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 24,
                  color: blackColor,
                )),
          )),
      body: SafeArea(
          child: ListViewInfiniteLoader(
            canLoadMore: countries.page < countries.totalPages,
            loadingState: _loadingMore,
            setLoadingModeState: setLoadingMoreState,
            getMoreItems: getCountries,
            children: List.generate(
                countries.items,
                    (index) => InkWell(
                    onTap: () {
                      Navigator.of(context).pop(countries.getItem(index));
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Expanded(
                            flex: 8,
                            child: Text(
                              countries.getItem(index).name,
                              style: const TextStyle(fontSize: 23),
                            )
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios)
                        ]))))
          )),
    );
  }
}
