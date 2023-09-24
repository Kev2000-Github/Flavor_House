import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/country.dart';
import 'package:flavor_house/services/paginated.dart';
import 'package:flavor_house/services/register/register_step_two_service.dart';
import 'package:flutter/material.dart';

import '../../common/popups/common.dart';
import '../../services/register/http_register_step_two_service.dart';
import '../../widgets/listview_infinite_loader.dart';

class StepCountry extends StatefulWidget {
  final Function(String) onCountrySelect;
  const StepCountry({super.key, required this.onCountrySelect});

  @override
  State<StepCountry> createState() => _StepCountryState();
}

class _StepCountryState extends State<StepCountry> {
  Paginated<Country> countries = Paginated.initial();
  bool _loadingMore = false;

  void setLoadingMoreState(bool state) {
    setState(() {
      _loadingMore = state;
    });
  }

  void getCountries(Function(bool) setLoadingState) async {
    if (mounted) setLoadingState(true);
    RegisterStepTwo registerService = HttpRegisterStepTwo();
    dartz.Either<Failure, Paginated<Country>> result = await registerService
        .getCountries(page: countries.isNotEmpty ? countries.page + 1 : 1);
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

  @override
  void initState() {
    super.initState();
    getCountries(setLoadingMoreState);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.4,
      child: ListViewInfiniteLoader(
          canLoadMore: countries.page < countries.totalPages,
          loadingState: _loadingMore,
          setLoadingModeState: setLoadingMoreState,
          getMoreItems: getCountries,
          children: List.generate(
              countries.items,
                  (index) => InkWell(
                  onTap: () {
                    widget.onCountrySelect(countries.getItem(index).id);
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
      )
    );
  }
}
