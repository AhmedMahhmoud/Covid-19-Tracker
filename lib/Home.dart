import 'package:design1/Services/ApiProvider.dart';
import 'package:design1/Services/CountriesApiModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "./Services/ApiModel.dart";

class Home extends StatefulWidget {
  var country = "Egypt";
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    getCountryy();
    isLastSelected();

    // TODO: implement initState
    super.initState();
  }

  Future<void> isLastSelected() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("lastSelected").isNotEmpty) {
      widget.country = sharedPreferences.getString("lastSelected");
    }
  }

  List<String> allCountries = [];
  Future<void> getCountryy() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getStringList("sharedCountry").length == 0) {
      setState(() async {
        await Provider.of<ApiSerrvices>(context).displayFlags();
      });
    }

    allCountries = sharedPreferences.getStringList("sharedCountry");
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    final myprovider = Provider.of<ApiSerrvices>(context, listen: true);

    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipPath(
                clipper: MyClipper(),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Image(
                          image: AssetImage("assets/images/Screenshot_1.png"),
                        ),
                      ),
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xff11249F), Color(0xff3383CD)],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight),
                          image: DecorationImage(
                              image: AssetImage("assets/images/virus.png"))),
                    ),
                    Positioned(
                      height: 600,
                      width: 290,
                      top: 40,
                      child: SvgPicture.asset(
                        "assets/images/coronadr.svg",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: 150,
                      child: Text(
                        "Get to know \nAbout Covid-19.",
                        style: TextStyle(
                            letterSpacing: 1,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey)),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/images/maps-and-flags.svg"),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            elevation: 2,
                            isExpanded: true,
                            onChanged: (String value) async {
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              sharedPreferences
                                  .setString("lastSelected", value)
                                  .then((value) => print("lastSelected Done"))
                                  .then((value) {
                                setState(() {
                                  widget.country = sharedPreferences
                                      .getString("lastSelected");
                                });
                              });
                            },
                            value: widget.country,
                            items: allCountries
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ));
                            }).toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Case Update",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Newest update ${DateFormat('MMMMd').format(DateTime.now())}",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FutureBuilder(
                      future: myprovider.displatData(widget.country),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: Column(
                            children: [
                              Text(
                                "Please wait ... \nFetching Data ...",
                                style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CircularProgressIndicator(),
                            ],
                          ));
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 150,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ColumnStates(
                                    stats: "infected",
                                    statsColor: Colors.orange[600],
                                    statsNumber:
                                        myprovider.apiModel[0].confirmed,
                                  ),
                                  ColumnStates(
                                    stats: "Deathes",
                                    statsColor: Colors.red[600],
                                    statsNumber:
                                        myprovider.apiModel[0].newDeath,
                                  ),
                                  ColumnStates(
                                    stats: "Recovered",
                                    statsColor: Colors.green[600],
                                    statsNumber:
                                        myprovider.apiModel[0].newRecovered,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Total Spread",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TotalInfectedRow(
                                    total: "Total Confirmed",
                                    text: myprovider.apiModel[0].totalConfirmed,
                                    textColor: Colors.orange[600]),
                                SizedBox(
                                  height: 10,
                                ),
                                TotalInfectedRow(
                                    total: "Total Deaths",
                                    text: myprovider.apiModel[0].totalDeath,
                                    textColor: Colors.red[600]),
                                SizedBox(
                                  height: 10,
                                ),
                                TotalInfectedRow(
                                    total: "Total Recovered",
                                    text: myprovider.apiModel[0].totalRecovered,
                                    textColor: Colors.green[600]),
                              ],
                            )
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TotalInfectedRow extends StatelessWidget {
  const TotalInfectedRow(
      {Key key, @required this.text, this.textColor, this.total})
      : super(key: key);

  final String text;
  final Color textColor;
  final String total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          total,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: textColor,
            ),
          ),
        )
      ],
    );
  }
}

class ColumnStates extends StatelessWidget {
  final String stats;
  final String statsNumber;
  final Color statsColor;
  const ColumnStates({
    this.stats,
    this.statsColor,
    this.statsNumber,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: EdgeInsets.all(7),
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statsColor.withOpacity(0.26),
            ),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(color: statsColor, width: 2)),
            )),
        SizedBox(
          height: 10,
        ),
        Text(
          statsNumber,
          style: TextStyle(
              letterSpacing: 1,
              color: statsColor,
              fontWeight: FontWeight.bold,
              fontSize: 40),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          stats,
          style: TextStyle(color: Colors.grey, fontSize: 17),
        )
      ],
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
