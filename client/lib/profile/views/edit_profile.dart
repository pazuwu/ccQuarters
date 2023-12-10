import 'dart:typed_data';

import 'package:ccquarters/common_widgets/image.dart';
import 'package:ccquarters/common_widgets/inkwell_with_photo.dart';
import 'package:ccquarters/login_register/views/personal_info_fields.dart';
import 'package:ccquarters/model/user.dart';
import 'package:ccquarters/profile/cubit.dart';
import 'package:ccquarters/utils/consts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key, required this.user});

  final User user;
  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  final companyTextField = TextEditingController();
  final nameTextField = TextEditingController();
  final surnameTextField = TextEditingController();
  final phoneNumberTextField = TextEditingController();
  Uint8List? image;
  bool _deleteImage = false;
  late bool _isBusinessAccount;
  late String? _photoUrl;

  @override
  void initState() {
    _isBusinessAccount = widget.user.company != null;
    _photoUrl = widget.user.photoUrl;
    companyTextField.text = widget.user.company ?? "";
    nameTextField.text = widget.user.name ?? "";
    surnameTextField.text = widget.user.surname ?? "";
    phoneNumberTextField.text = widget.user.phoneNumber ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _changeDeleteImageFlag();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              context.read<ProfilePageCubit>().goToProfilePage();
            },
          ),
          title: const Text("Edytuj profil"),
          actions: [_buildSaveButton(context)],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width *
                  (MediaQuery.of(context).orientation == Orientation.landscape
                      ? 0.5
                      : 1),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildPhoto(),
                    _buildPersonalInfoFields(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _changeDeleteImageFlag() {
    return setState(() {
      _deleteImage = false;
    });
  }

  Widget _buildSaveButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          if (!_isBusinessAccount) {
            widget.user.company = null;
          } else {
            widget.user.company = companyTextField.text;
          }
          widget.user.name = nameTextField.text;
          widget.user.surname = surnameTextField.text;
          widget.user.phoneNumber = phoneNumberTextField.text;

          context.read<ProfilePageCubit>().updateUser(
              widget.user, image, widget.user.photoUrl != _photoUrl);
        }
      },
      icon: const Icon(Icons.check),
    );
  }

  Widget _buildPhoto() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxWidth * _getPhotoSizeMultiplier(),
          width: constraints.maxWidth * _getPhotoSizeMultiplier(),
          child: Padding(
            padding: const EdgeInsets.all(largePaddingSize),
            child: ClipOval(child: _getPhotoWidget(constraints)),
          ),
        );
      },
    );
  }

  Widget _getPhotoWidget(BoxConstraints constraints) {
    if (image != null || (_photoUrl != null && _photoUrl!.isNotEmpty)) {
      return InkWellWithPhoto(
        onTap: () {
          setState(() {
            if (_deleteImage) {
              image = null;
              _photoUrl = null;
              _deleteImage = false;
            } else {
              _deleteImage = true;
            }
          });
        },
        imageWidget: image != null
            ? CircleAvatar(
                backgroundImage: MemoryImage(
                  image!,
                ),
                radius: constraints.maxWidth * _getPhotoSizeMultiplier() / 2,
              )
            : ImageWidget(
                imageUrl: _photoUrl!,
                shape: BoxShape.circle,
              ),
        inkWellChild: _deleteImage ? _buildDeleteImage(constraints) : null,
      );
    } else {
      return _buildGetNewPhoto(constraints);
    }
  }

  Widget _buildDeleteImage(BoxConstraints constraints) {
    return Center(
      child: Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        color: Colors.grey.withOpacity(0.2),
        child: Icon(
          Icons.delete,
          size: constraints.maxWidth * _getPhotoSizeMultiplier() / 4,
        ),
      ),
    );
  }

  Widget _buildGetNewPhoto(BoxConstraints constraints) {
    return InkWellWithPhoto(
      onTap: () {
        _getFromGallery().then((value) {
          if (value != null) {
            setState(() {
              image = value.bytes;
            });
          }
        });
      },
      imageWidget: CircleAvatar(
        radius: constraints.maxWidth * _getPhotoSizeMultiplier() / 2,
        child: Icon(
          Icons.person,
          size: constraints.maxWidth * _getPhotoSizeMultiplier() / 2,
        ),
      ),
    );
  }

  Widget _buildPersonalInfoFields() {
    return PersonalInfoFields(
      company: companyTextField,
      name: nameTextField,
      surname: surnameTextField,
      phoneNumber: phoneNumberTextField,
      isBusinessAccount: _isBusinessAccount,
      saveIsBusinessAcount: (value) {
        setState(() {
          _isBusinessAccount = value;
        });
      },
    );
  }

  Future<PlatformFile?> _getFromGallery() async {
    var res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
      withData: true,
    );

    return res?.files.first;
  }

  double _getPhotoSizeMultiplier() {
    return MediaQuery.of(context).orientation == Orientation.landscape
        ? 0.4
        : 0.8;
  }
}
