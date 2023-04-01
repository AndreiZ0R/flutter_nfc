import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mes_nfc/repository/home_repository.dart';
import 'package:mes_nfc/theming/app_dimms.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/home_model.dart';

import '../theming/app_theme.dart';
import '../widgets/front_row.dart';
import '../widgets/home_card.dart';
import 'add_home_screen.dart';

import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _user = {'name': 'Andrei Borza'};
  final homeRepo = HomeRepository();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      //TODO: check this maybe?
      // double nfc approach for home to toggle, NOT BAD?!

      final ndefTag = Ndef.from(tag);
      var data = ndefTag?.cachedMessage;

      final records = data?.records;
      final firstRecord = records![0];

      final decoded =
          utf8.decode(firstRecord.payload.skip(1).toList()).substring(2);

      setState(() {
        homeRepo.toggleHomeStatus(decoded);
      });

      NfcManager.instance.stopSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).colorScheme.onBackground,
        padding: const EdgeInsets.all(AppDims.defaultPadding),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: AppDims.extraBigPadding),
                child: FrontRow(
                  display: _user['name']!,
                  onPressed: () {},
                ),
              ),
              const Padding(
                padding:
                    EdgeInsets.symmetric(vertical: AppDims.extraSmallPadding),
                child: Divider(color: Colors.grey),
              ),
              FutureBuilder<List<HomeModel>>(
                future: homeRepo.fetchHomes(),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    List<HomeModel> homes = snapshot.data!;
                    return homes.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, idx) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppDims.mediumSmallPadding,
                                  ),
                                  child: HomeCard(
                                    backgroundColor: AppTheme.backgroundColor,
                                    home: homes[idx],
                                    onDismissed: (direction) {
                                      setState(() {
                                        homeRepo.deleteHome(homes[idx]);
                                      });
                                    },
                                  ),
                                );
                              },
                              itemCount: homes.length,
                            ),
                          )
                        : const Center(
                            child:
                                Text('Empty. \nStart adding some new homes!'),
                          );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
              const Padding(
                padding:
                    EdgeInsets.symmetric(vertical: AppDims.extraSmallPadding),
                child: Divider(color: Colors.grey),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDims.mediumSmallBorderRadius,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => const AddHomeScreen()),
                      ).then((newHome) {
                        setState(() {
                          homeRepo.addHome(newHome);
                        });
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDims.mediumSmallPadding,
                      ),
                      child: Text(
                        'New Home',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
