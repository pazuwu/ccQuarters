import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/utils/consts.dart';
import 'package:flutter/material.dart';

const headerStyle = TextStyle(
    color: Color(0xffffffff), fontSize: 18, fontWeight: FontWeight.bold);

class AccordionPage extends StatelessWidget {
  const AccordionPage({super.key, required this.house});

  final House house;

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
        if (house.details.description != null)
          _buildDescriptionAccordionSection(context),
        _buildDetailsAccordionSection(context),
        _buildLocationAccordionSection(context),
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
        children: [
          HouseDetailsRow(title: "Cena", value: '${house.details.price} zł'),
          HouseDetailsRow(
              title: "Powierzchnia", value: '${house.details.area} m2'),
          if (house.details.roomCount != null && house.details.roomCount! > 0)
            HouseDetailsRow(
                title: "Liczba pokoi", value: '${house.details.roomCount}'),
          if (house.details.floor != null && house.details.floor! > 0)
            HouseDetailsRow(
              title: "Piętro",
              value: '${house.details.floor}',
              isLast: true,
            ),
        ],
      ),
    );
  }

  AccordionSection _buildLocationAccordionSection(BuildContext context) {
    return AccordionSection(
      isOpen: _shouldBeOpen(context),
      leftIcon: const Icon(Icons.location_on_outlined, color: Colors.white),
      header: const Text('Adres', style: headerStyle),
      content: Column(
        children: [
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
          if (house.location.streetNumber != null &&
              house.location.streetNumber!.isNotEmpty)
            HouseDetailsRow(
                title: "Numer domu", value: house.location.streetNumber!),
          if (house.location.flatNumber != null &&
              house.location.flatNumber!.isNotEmpty)
            HouseDetailsRow(
                title: "Numer mieszkania", value: house.location.flatNumber!),
          HouseDetailsRow(
            title: "Kod pocztowy",
            value: house.location.zipCode,
            isLast: true,
          ),
        ],
      ),
    );
  }

  bool _shouldBeOpen(BuildContext context) {
    return MediaQuery.of(context).size.height > 600;
  }
}

class HouseDetailsRow extends StatelessWidget {
  const HouseDetailsRow({
    super.key,
    required this.title,
    required this.value,
    this.isLast = false,
  });

  final String title;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        if (!isLast)
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Divider(
              color: Colors.grey,
              height: 2,
            ),
          ),
      ],
    );
  }
}
