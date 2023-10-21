import 'package:ccquarters/house_details/accordion.dart';
import 'package:ccquarters/main_page/cubit.dart';
import 'package:ccquarters/model/house.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsView extends StatefulWidget {
  const DetailsView({super.key, required this.house});

  final House house;
  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        leading: IconButton(
          onPressed: () => context.read<MainPageCubit>().goBack(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(widget.house.houseDetails.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Photos(
              photos: widget.house.photos,
            ),
            AccordionPage(
              house: widget.house,
            )
          ],
        ),
      ),
    );
  }
}

class Photos extends StatefulWidget {
  const Photos({super.key, required this.photos});

  final List<String> photos;
  @override
  State<Photos> createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  final controller = PageController(viewportFraction: 0.8, keepPage: true);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
