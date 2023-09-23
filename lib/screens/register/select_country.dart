import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/country.dart';
import 'package:flavor_house/services/register/http_register_step_two_service.dart';
import 'package:flavor_house/services/register/register_step_two_service.dart';
import 'package:flutter/material.dart';

import '../../common/popups/common.dart';
import '../../utils/colors.dart';

class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({super.key});

  @override
  State<SelectCountryScreen> createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {
  List<Country> countries = [];

  void getCountries() async {
    RegisterStepTwo registerService = HttpRegisterStepTwo();
    dartz.Either<Failure, List<Country>> result =
        await registerService.getCountries();
    result.fold((failure) => CommonPopup.alert(context, failure),
        (List<Country> countries) {
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
          child: SingleChildScrollView(
        child: Column(
          children: List.generate(
              countries.length,
              (index) => InkWell(
                  onTap: () {
                    Navigator.of(context).pop(countries[index]);
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: Row(children: [
                        Text(
                          countries[index].name,
                          style: const TextStyle(fontSize: 23),
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios)
                      ])))),
        ),
      )),
    );
  }
}
