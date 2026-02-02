import 'package:flutter/material.dart';
import 'package:myrex11/adapter/TeamItemAdapter.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_navigator.dart';
import 'package:myrex11/appUtilities/defaultbutton.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/repository/model/team_response.dart';

class MyTeams extends StatefulWidget {
  GeneralModel model;
  List<Team> teamsList;
  Function onCreate;

  MyTeams(
    this.model,
    this.teamsList,
    this.onCreate,
  );

  @override
  _MyTeamsState createState() => new _MyTeamsState();
}

class _MyTeamsState extends State<MyTeams> {
  @override
  void initState() {
    super.initState();
    widget.model.onTeamCreated = widget.onCreate;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(left: 8, right: 8, top: 8),
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                // padding: EdgeInsets.only(bottom: 52),
                child: new ListView.builder(
                    padding: EdgeInsets.only(bottom: 56),
                    key: UniqueKey(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: widget.teamsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new TeamItemAdapter(
                        widget.model,
                        widget.teamsList[index],
                        false,
                        index,
                        onTeamCreated: widget.onCreate,
                      );
                    }),
              ),
              GestureDetector(
                onTap: () {
                  widget.model.teamId = 0;
                  widget.model.isFromEditOrClone = false;
                  navigateToCreateTeam(context, widget.model);
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Container(
                    height: 45,
                    margin: EdgeInsets.only(
                        left: 100, right: 100, top: 0, bottom: 0),
                    decoration: BoxDecoration(
                      color: buttonGreenColor,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      border: Border.all(
                        color: Color(0xFF6A0BF8),
                        width: 1.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: Text(
                          'Create Team ' +
                              (widget.teamsList.length + 1).toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 15),
              //   child: DefaultButton(
              //     width: MediaQuery.of(context).size.width * 0.4,
              //     height: 40,
              //     margin: EdgeInsets.zero,
              //     text:
              //         'Create Team ' + (widget.teamsList.length + 1).toString(),
              //     textcolor: Colors.white,
              //     borderRadius: 20,
              //     color: buttonGreenColor,
              //     onpress: () {
              //       widget.model.teamId = 0;
              //       widget.model.isFromEditOrClone = false;
              //       navigateToCreateTeam(context, widget.model);
              //     },
              //   ),
              // )

              // new Container(
              //     width:
              //     MediaQuery.of(context).size.width,
              //     height: 50,
              //     child: RaisedButton(
              //       textColor: Colors.white,
              //       elevation: .5,
              //       color: Colors.black,
              //       child: Text(
              //         'Create Team ('+(widget.teamsList.length+1).toString()+')',
              //         style: TextStyle(fontSize: 15,color: Colors.white),
              //       ),
              //       shape: RoundedRectangleBorder(
              //           borderRadius:
              //           BorderRadius.circular(5)),
              //       onPressed: () {
              //         widget.model.teamId=0;
              //         navigateToCreateTeam(context,widget.model);
              //       },
              //     )),
            ],
          ),
        ),
      ),
    );
  }
}
