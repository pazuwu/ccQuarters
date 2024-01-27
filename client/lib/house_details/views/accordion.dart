import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:ccquarters/common/functions.dart';
import 'package:ccquarters/model/houses/detailed_house.dart';
import 'package:ccquarters/common/consts.dart';
import 'package:flutter/material.dart';

const headerStyle = TextStyle(
    color: Color(0xffffffff), fontSize: 18, fontWeight: FontWeight.bold);

class AccordionPage extends StatelessWidget {
  const AccordionPage({super.key, required this.house});

  final DetailedHouse house;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Accordion(
      paddingListTop: largePaddingSize,
      paddingListBottom: largePaddingSize,
      headerBorderColor: colorScheme.primary,
      headerBorderColorOpened: Colors.transparent,
      maxOpenSections: 3,
      headerBackgroundColorOpened: colorScheme.primary.withOpacity(0.7),
      contentBackgroundColor: Colors.white,
      contentBorderColor: colorScheme.primary.withOpacity(0.7),
      contentBorderWidth: 3,
      contentHorizontalPadding: largePaddingSize,
      scaleWhenAnimating: false,
      openAndCloseAnimation: true,
      headerPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
      sectionClosingHapticFeedback: SectionHapticFeedback.light,
      disableScrolling: true,
      children: [
        if (house.details.description != null &&
            house.details.description!.isNotEmpty)
          _buildDescriptionAccordionSection(context),
        _buildDetailsAccordionSection(context),
        _buildLocationAccordionSection(context),
        if (house.details.additionalInfo != null &&
            house.details.additionalInfo!.isNotEmpty)
          _buildAdditionalInfoAccordionSection(context),
      ],
    );
  }

  AccordionSection _buildDescriptionAccordionSection(BuildContext context) {
    return AccordionSection(
      contentVerticalPadding: 20,
      isOpen: _shouldBeOpen(context),
      leftIcon: const Icon(Icons.description_outlined, color: Colors.white),
      header: const Text('Opis', style: headerStyle),
      content: Text(
        house.details.description!,
        style: const TextStyle(
          color: Color(0xff999999),
          fontSize: 14,
        ),
      ),
    );
  }

  AccordionSection _buildDetailsAccordionSection(BuildContext context) {
    return AccordionSection(
      isOpen: _shouldBeOpen(context),
      leftIcon: const Icon(Icons.info_outline_rounded, color: Colors.white),
      header: const Text('Szczegóły ogłoszenia', style: headerStyle),
      content: Column(
        children: buildWidgetsWithDivider([
          HouseDetailsRow(
              title: "Typ ogłoszenia",
              value: house.details.buildingType.toString()),
          HouseDetailsRow(
            title: "Typ oferty",
            value: house.offerType.toString(),
          ),
          if (house.details.floor != null && house.details.floor! > 0)
            HouseDetailsRow(
              title: "Piętro",
              value: '${house.details.floor}',
            ),
        ]),
      ),
    );
  }

  AccordionSection _buildLocationAccordionSection(BuildContext context) {
    return AccordionSection(
      isOpen: _shouldBeOpen(context),
      leftIcon: const Icon(Icons.location_on_outlined, color: Colors.white),
      header: const Text('Adres', style: headerStyle),
      content: Column(
        children: buildWidgetsWithDivider([
          HouseDetailsRow(
              title: "Województwo", value: house.location.voivodeship),
          HouseDetailsRow(title: "Miasto", value: house.location.city),
          if (house.location.district != null &&
              house.location.district!.isNotEmpty)
            HouseDetailsRow(
                title: "Dzielnica", value: house.location.district!),
          if (house.location.streetName != null &&
              house.location.streetName!.isNotEmpty)
            HouseDetailsRow(title: "Ulica", value: house.location.streetName!),
          if (house.location.streetNumber.isNotEmpty)
            HouseDetailsRow(
                title: "Numer domu", value: house.location.streetNumber),
          if (house.location.flatNumber != null &&
              house.location.flatNumber!.isNotEmpty)
            HouseDetailsRow(
                title: "Numer mieszkania", value: house.location.flatNumber!),
          HouseDetailsRow(
            title: "Kod pocztowy",
            value: house.location.zipCode,
          ),
        ]),
      ),
    );
  }

  AccordionSection _buildAdditionalInfoAccordionSection(BuildContext context) {
    return AccordionSection(
      contentVerticalPadding: 20,
      isOpen: _shouldBeOpen(context),
      leftIcon: const Icon(Icons.add_home_outlined, color: Colors.white),
      header: const Text('Dodatkowe informacje', style: headerStyle),
      content: Column(
        children: buildWidgetsWithDivider(house.details.additionalInfo!.entries
            .map((e) => HouseDetailsRow(title: e.key, value: e.value))
            .toList()),
      ),
    );
  }

  bool _shouldBeOpen(BuildContext context) {
    return MediaQuery.of(context).size.height > 800;
  }
}

class HouseDetailsRow extends StatelessWidget {
  const HouseDetailsRow({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
