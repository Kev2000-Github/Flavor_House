import 'package:flavor_house/common/constants/routes.dart' as routes;
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class StepCountry extends StatelessWidget {
  final Function(String) onCountrySelect;
  const StepCountry({Key? key, required this.onCountrySelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: ListTile(
          title: const Text("Pais",
              style: TextStyle(
                  color: gray04Color,
                  fontSize: 22,
                  fontWeight: FontWeight.w500)),
          trailing: const Icon(Icons.keyboard_arrow_right, size: 20),
          onTap: () async {
            final selectedCountryId = await Navigator.of(context).pushNamed(routes.select_country);
            onCountrySelect(selectedCountryId as String);
          },
        ));
  }
}

