import 'package:flutter/material.dart';
import 'package:mes_nfc/models/home_model.dart';
import 'package:mes_nfc/widgets/app_checkbox.dart';
import 'package:mes_nfc/widgets/app_text_field.dart';
import '../theming/app_dimms.dart';

import 'dart:typed_data';
import 'package:nfc_manager/nfc_manager.dart';

import '../theming/app_theme.dart';

class AddHomeScreen extends StatefulWidget {
  const AddHomeScreen({Key? key}) : super(key: key);

  @override
  State<AddHomeScreen> createState() => _AddHomeScreenState();
}

class _AddHomeScreenState extends State<AddHomeScreen> {
  final _formKey = GlobalKey<FormState>();

  bool checkboxIsSelected = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ownerController = TextEditingController();

  SnackBar getSnackBar({required Color color, required String label}) {
    return SnackBar(
      dismissDirection: DismissDirection.endToStart,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppDims.mediumSmallBorderRadius,
        ),
      ),
      backgroundColor: color,
      elevation: 2,
      padding: const EdgeInsets.all(AppDims.smallPadding),
      content: Padding(
        padding: const EdgeInsets.all(AppDims.mediumSmallPadding),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.background,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text('Add New Home'),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(AppDims.mediumBorderRadius),
            bottomRight: Radius.circular(AppDims.mediumBorderRadius),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(AppDims.defaultPadding),
          color: Theme.of(context).colorScheme.background,
          child: Padding(
            padding: const EdgeInsets.only(top: AppDims.extraBigPadding),
            child: FutureBuilder<bool>(
              future: NfcManager.instance.isAvailable(),
              builder: (context, ss) => ss.data != true
                  ? const Center(child: CircularProgressIndicator())
                  : Form(
                      onChanged: () {},
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: [
                              AppTextField(
                                hintText: 'e.g. Uppear East Apt.',
                                keyboardType: TextInputType.text,
                                label: 'Name',
                                controller: nameController,
                                color: Theme.of(context).colorScheme.primary,
                                validator: (str) {
                                  if (str == null || str.isEmpty) {
                                    return 'Please enter a name';
                                  }
                                  return null;
                                },
                              ),
                              AppTextField(
                                hintText: 'e.g. 23 Main Street, Chicago',
                                keyboardType: TextInputType.text,
                                label: 'Address',
                                controller: addressController,
                                color: Theme.of(context).colorScheme.primary,
                                validator: (str) {
                                  if (str == null || str.isEmpty) {
                                    return 'Please enter an address';
                                  }
                                  return null;
                                },
                              ),
                              AppTextField(
                                hintText: 'e.g. John Doe',
                                keyboardType: TextInputType.text,
                                label: 'Owner',
                                controller: ownerController,
                                color: Theme.of(context).colorScheme.primary,
                                validator: (str) {
                                  if (str == null || str.isEmpty) {
                                    return 'Please enter an owner';
                                  }
                                  return null;
                                },
                              ),
                              AppCheckbox(
                                label: 'Locked?',
                                onChanged: (val) {
                                  setState(() {
                                    checkboxIsSelected = !checkboxIsSelected;
                                  });
                                },
                                color: Theme.of(context).colorScheme.primary,
                                isSelected: checkboxIsSelected,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppDims.defaultPadding,),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDims.mediumSmallBorderRadius,
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    getSnackBar(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      label: 'Ready to scan',
                                    ),
                                  );

                                  _ndefWrite();
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppDims.mediumSmallPadding,
                                  horizontal: AppDims.defaultPadding,
                                ),
                                child: Text(
                                  'Submit',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void _ndefWrite() {
    var result;

    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        result = 'Tag is not ndef writable';

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(getSnackBar(
              color: AppTheme.errorColor, label: 'Tag cannot be written'));
        NfcManager.instance.stopSession(errorMessage: result);
        return;
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createText(
          '${nameController.text}',
        ),
        // NdefRecord.createUri(
        //   Uri.parse('https://flutter.dev'),
        // ),
        // NdefRecord.createMime(
        //   'text/plain',
        //   Uint8List.fromList('Hello'.codeUnits),
        // ),
        NdefRecord.createExternal(
          'android.com',
          'pkg',
          Uint8List.fromList('com.example.mes_nfc'.codeUnits),
        ),
      ]);

      try {
        await ndef.write(message);
        result = 'Success to "Ndef Write"';
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(getSnackBar(
              color: AppTheme.succesColor, label: 'Success writing tag'));

        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop(
            HomeModel(
              name: nameController.text,
              lastChecked: DateTime.now(),
              isLocked: checkboxIsSelected,
              location: addressController.text,
              owner: ownerController.text,
            ),
          );
        });

        NfcManager.instance.stopSession();
      } catch (e) {
        result = e;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(getSnackBar(
              color: AppTheme.errorColor, label: 'Error writing tag'));
        NfcManager.instance.stopSession(errorMessage: result.toString());
        return;
      }
    });
  }

  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var data = tag.data;
      NfcManager.instance.stopSession();
    });
  }
}
