import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:ccquarters/model/house.dart';
import 'package:flutter/foundation.dart';
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
      headerBorderColor: colorScheme.primary,
      headerBorderColorOpened: Colors.transparent,
      // headerBorderWidth: 1,
      maxOpenSections: 10,
      headerBackgroundColorOpened: colorScheme.primary.withOpacity(0.7),
      contentBackgroundColor: Colors.white,
      contentBorderColor: colorScheme.primary.withOpacity(0.7),
      contentBorderWidth: 3,
      contentHorizontalPadding: 20,
      scaleWhenAnimating: true,
      openAndCloseAnimation: true,
      headerPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
      sectionClosingHapticFeedback: SectionHapticFeedback.light,
      disableScrolling: true,
      children: [
        _buildDescriptionAccordionSection(),
        _buildDetailsAccordionSection(),
        _buildLocationAccordionSection(),
      ],
    );
  }

  AccordionSection _buildDescriptionAccordionSection() {
    return AccordionSection(
      contentVerticalPadding: 20,
      isOpen: kIsWeb,
      leftIcon: const Icon(Icons.description_outlined, color: Colors.white),
      header: const Text('Opis', style: headerStyle),
      content: Text(house.houseDetails.description,
          style: const TextStyle(
            color: Color(0xff999999),
            fontSize: 14,
          )),
    );
  }

  AccordionSection _buildDetailsAccordionSection() {
    return AccordionSection(
        isOpen: kIsWeb,
        leftIcon: const Icon(Icons.details_outlined, color: Colors.white),
        header: const Text('Szczegóły ogłoszenia', style: headerStyle),
        content: Column(
          children: [
            HouseDetailsRow(
                title: "Cena", value: '${house.houseDetails.price} zł'),
            HouseDetailsRow(
                title: "Powierzchnia", value: '${house.houseDetails.area} m2'),
            if (house.houseDetails.roomCount != null)
              HouseDetailsRow(
                  title: "Liczba pokoi",
                  value: '${house.houseDetails.roomCount}'),
            if (house.houseDetails.floor != null)
              HouseDetailsRow(
                title: "Piętro",
                value: '${house.houseDetails.floor}',
                isLast: true,
              ),
          ],
        ));
  }

  AccordionSection _buildLocationAccordionSection() {
    return AccordionSection(
        isOpen: kIsWeb,
        leftIcon: const Icon(Icons.location_on_outlined, color: Colors.white),
        header: const Text('Lokalizacja', style: headerStyle),
        content: Column(
          children: [
            HouseDetailsRow(title: "Miasto", value: house.location.city),
            if (house.location.district != null)
              HouseDetailsRow(
                  title: "Dzielnica", value: house.location.district!),
            if (house.location.streetName != null)
              HouseDetailsRow(
                  title: "Ulica", value: house.location.streetName!),
            if (house.location.streetNumber != null)
              HouseDetailsRow(
                  title: "Numer domu", value: house.location.streetNumber!),
            if (house.location.flatNumber != null)
              HouseDetailsRow(
                  title: "Numer mieszkania", value: house.location.flatNumber!),
            HouseDetailsRow(
              title: "Kod pocztowy",
              value: house.location.zipCode,
              isLast: true,
            ),
          ],
        ));
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
            Text(title, style: const TextStyle(fontSize: 14)),
            Text(value,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
