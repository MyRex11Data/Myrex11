import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/adapter/ContestItemAdapter.dart';
import 'package:myrex11/adapter/ShimmerContestItemAdapter.dart';

import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/repository/model/category_contest_response.dart';

class MyJoinedContests extends StatefulWidget {
  List<Contest> joinedContestList;
  bool contestLoading;
  GeneralModel model;
  Function onJoinContestResult;
  Function getWinnerPriceCard;
  String userId;
  Function onTeamCreated;
  int? _contestItemIndex;
  MyJoinedContests(
      this._contestItemIndex,
      this.model,
      this.joinedContestList,
      this.contestLoading,
      this.onJoinContestResult,
      this.userId,
      this.getWinnerPriceCard,
      this.onTeamCreated);
  @override
  _MyJoinedContestsState createState() => new _MyJoinedContestsState();
}

class _MyJoinedContestsState extends State<MyJoinedContests> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(8),
      child: !widget.contestLoading
          ? new ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: widget.joinedContestList.length,
              itemBuilder: (BuildContext context, int index) {
                return new ContestItemAdapter(
                  widget._contestItemIndex,
                  widget.model,
                  widget.joinedContestList[index],
                  widget.onJoinContestResult,
                  widget.userId,
                  widget.getWinnerPriceCard,
                  widget.onTeamCreated,
                  isMyContest: true,
                  screenCheck: 'detailsContest',
                );
              })
          : new ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: 7,
              itemBuilder: (BuildContext context, int index) {
                return new ShimmerContestItemAdapter();
              }),
    );
  }
}
