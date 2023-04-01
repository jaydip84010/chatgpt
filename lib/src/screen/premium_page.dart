import 'dart:async';

import 'package:flutter/material.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({Key? key}) : super(key: key);

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/images/premium Screen background.png',
                      ),
                      fit: BoxFit.fill)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        margin: EdgeInsets.only(right: 355, top: 20),
                        height: 35,
                        width: 35,
                        child: Image.asset(
                          'assets/images/close arrow.png',
                          fit: BoxFit.fill,
                        )),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height / 6.8,
                      child: Spacer()),
                  Container(
                      height: MediaQuery.of(context).size.height / 2.5,
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Image.asset(
                        'assets/images/Choose Your Plan.png',
                        fit: BoxFit.fill,
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                            height: 90,
                            width: 180,
                            child: Image.asset(
                              'assets/images/399.png',
                              fit: BoxFit.fill,
                            )),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                            height: 90,
                            width: 180,
                            child: Image.asset(
                              'assets/images/790.png',
                              fit: BoxFit.fill,
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                        height: 90,
                        width: MediaQuery.of(context).size.width / 1.15,
                        child: Image.asset(
                          'assets/images/5,000.png',
                          fit: BoxFit.fill,
                        )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
