// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../../injection_container.dart';
import '../bloc/article/remote/remote_article_bloc.dart';
import '../bloc/article/remote/remote_article_event.dart';

class CountryDropdown extends StatefulWidget {
  final void Function(String) onSelected; // Callback for selected value

  const CountryDropdown({
    super.key,
    required this.onSelected,
  });

  @override
  State<CountryDropdown> createState() => _CountryDropdownState();
}

class _CountryDropdownState extends State<CountryDropdown> {
  // List of country codes
  final List<String> countryCodes = [
    'ae',
    'ar',
    'at',
    'au',
    'bg',
    'br',
    'ca',
    'ch',
    'cn',
    'co',
    'cz',
    'de',
    'eg',
    'fr',
    'gb',
    'gr',
    'hk',
    'hu',
    'id',
    'ie',
    'il',
    'in',
    'it',
    'jp',
    'kr',
    'lt',
    'lv',
    'ma',
    'mx',
    'my',
    'ng',
    'nl',
    'no',
    'nz',
    'ph',
    'pl',
    'pt',
    'ro',
    'rs',
    'ru',
    'sa',
    'se',
    'sg',
    'si',
    'sk',
    'th',
    'tr',
    'tw',
    'ua',
    'us',
    've',
    'za',
  ];

  String? selectedCode; // Holds the currently selected country code

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      dropdownColor: Colors.white,
      alignment: Alignment.center,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16,
        fontFamily: 'Butler',
      ),
      borderRadius: BorderRadius.circular(10),
      isExpanded: true,
      hint: const Text("Select Country"), // Default hint text
      value: selectedCode,
      items: countryCodes.map((String code) {
        return DropdownMenuItem<String>(
          alignment: Alignment.center,
          value: code,
          child: Text(code.toUpperCase()), // Display code in uppercase
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          selectedCode = value; // Update the selected value
        });
        widget.onSelected(value!); // Trigger callback
      },
      onTap: () {
        sl<RemoteArticleBloc>().add(
          GetRemoteArticleEvent(country: selectedCode),
        );
      },
    );
  }
}
