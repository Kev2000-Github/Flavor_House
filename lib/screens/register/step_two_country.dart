import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/country.dart';
import 'package:flavor_house/services/register/dummy_register_step_two_service.dart';
import 'package:flavor_house/services/register/register_step_two_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart' as dartz;

import '../../utils/colors.dart';

class StepCountry extends StatefulWidget {
  final Function(String) onCountrySelect;
  const StepCountry({super.key, required this.onCountrySelect});

  @override
  State<StepCountry> createState() => _StepCountryState();
}

class _StepCountryState extends State<StepCountry> {
  List<Country> countries = [];

  void getCountries() async {
    RegisterStepTwo registerService = DummyRegisterStepTwo();
    dartz.Either<Failure, List<Country>> result =
    await registerService.getCountries();
    result.fold((l) => null, (List<Country> countries) {
      setState(() {
        this.countries = countries;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCountries();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(countries.length, (index) => InkWell(
            onTap: () {
              widget.onCountrySelect(countries[index].id);
            },
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                child: Row(
                    children: [
                      Text(countries[index].name, style: const TextStyle(
                          fontSize: 23
                      ),),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios)
                    ]
                )
            )
        )),
      ),
    );
  }
}