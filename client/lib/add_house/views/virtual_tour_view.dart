import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/add_house/cubit.dart';
import 'package:ccquarters/common/widgets/icon_360.dart';
import 'package:ccquarters/common/inputs/radio_list.dart';
import 'package:ccquarters/common/views/view_with_header_and_buttons.dart';
import 'package:ccquarters/virtual_tour/model/tour_info.dart';

class VirtualTourFormView extends StatefulWidget {
  const VirtualTourFormView({
    Key? key,
    required this.editMode,
    required this.usedVirtualTour,
    required this.formKey,
  }) : super(key: key);

  final bool editMode;
  final String? usedVirtualTour;
  final GlobalKey<FormState> formKey;

  @override
  State<VirtualTourFormView> createState() => _VirtualTourFormViewState();
}

class _VirtualTourFormViewState extends State<VirtualTourFormView> {
  late GlobalKey<FormState> _formKey;
  String? _usedVirtualTour;

  @override
  void initState() {
    super.initState();
    _usedVirtualTour = widget.usedVirtualTour;
    _formKey = widget.formKey;
  }

  @override
  Widget build(BuildContext context) {
    return ViewWithHeader(
      title: "Dodaj zdjęcia",
      inBetweenWidget: _buildPageContent(context),
      goBackOnPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          _formKey.currentState?.save();
          context.read<AddHouseFormCubit>().goToPhotosForm();
        }
      },
      nextOnPressed: widget.editMode
          ? null
          : () {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();
                context.read<AddHouseFormCubit>().sendData();
              }
            },
      isLastPage: true,
      scrollable: true,
      hasScrollBody: true,
    );
  }

  Widget _buildPageContent(BuildContext context) {
    return Expanded(
      child: Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(
            height: 8,
          ),
          ListTile(
            leading: Icon360(
              color: _usedVirtualTour != null ? Colors.blueGrey : Colors.grey,
            ),
            title: Text(
              "Wirtualny spacer",
              style: TextStyle(
                color: _usedVirtualTour != null ? Colors.black : Colors.grey,
              ),
            ),
            trailing: Switch(
              value: _usedVirtualTour != null,
              onChanged: (value) {
                setState(() {
                  _usedVirtualTour = value ? "" : null;
                  context
                      .read<AddHouseFormCubit>()
                      .saveChosenVirtualTour(_usedVirtualTour);
                });
              },
            ),
          ),
          Visibility(
            visible: _usedVirtualTour != null,
            child: _buildVirtualTourPicker(context),
          )
        ]),
      ),
    );
  }

  Widget _buildVirtualTourPicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: context.read<AddHouseFormCubit>().getMyTours(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RadioListForm<TourInfo>(
              defaultValue: snapshot.data
                  ?.where((element) => element.id == _usedVirtualTour)
                  .firstOrNull,
              values: snapshot.data ?? [],
              titleBuilder: (value) => Text(value.name),
              searchBoxHintText: "Wyszukaj wirtualny spacer",
              filter: (values, query) => values
                  .where((v) => v.name.contains(query.toLowerCase()))
                  .toList(),
              validator: (value) => value == null && _usedVirtualTour != null
                  ? "Wybierz wirtualny spacer"
                  : null,
              onSaved: (value) => setState(() {
                _usedVirtualTour = value?.id;
                context
                    .read<AddHouseFormCubit>()
                    .saveChosenVirtualTour(_usedVirtualTour);
              }),
            );
          } else {
            return const Row(
              children: [
                Text("Trwa ładowanie twoich wirtualnych spacerów"),
                SizedBox(width: 12),
                SizedBox.square(
                    dimension: 20, child: CircularProgressIndicator()),
              ],
            );
          }
        },
      ),
    );
  }
}
