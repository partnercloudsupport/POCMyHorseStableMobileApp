import 'package:flutter/material.dart';
import 'ListHorseInfo.dart';
import 'HorseInfo.dart';

enum _HorseInfoCardChoice {
  Name, // Text field for the horse name
  Sexe, // Field with switch for male/female choice
  Race, // List field for race choice
  Date, // Date field for the birthdate
  Nationality, // List Field for the nationality choice
  Notes // Text field for name
}

class HorseInfoCard extends StatelessWidget {
  HorseInfoCard({ Key key }) : super(key: key);

  final choice = [
    new DisplayHorseInfoWidget(_HorseInfoCardChoice.Name, title: "Nom", nbLine: 1),
    new DisplayHorseInfoWidget(_HorseInfoCardChoice.Sexe),
    new DisplayHorseInfoWidget(_HorseInfoCardChoice.Race),
    new DisplayHorseInfoWidget(_HorseInfoCardChoice.Nationality),
    new DisplayHorseInfoWidget(_HorseInfoCardChoice.Date),
    new DisplayHorseInfoWidget(_HorseInfoCardChoice.Notes, title: "Notes sur l'animal", nbLine: 3),
  ];

  @override
  Widget build(BuildContext context) {
    return new ListView(
        children: choice
    );
  }
}

class DisplayHorseInfoWidget extends ListHorseInfoPrimitive {
  DisplayHorseInfoWidget(this.type, {Key key, this.title, this.nbLine}) : super(key: key);

  final _HorseInfoCardChoice type; // Type of field
  final String title; // Text field title
  final nbLine; // Number line for text field

  @override
  State<ListHorseInfoPrimitive> createState() {
    if (type == _HorseInfoCardChoice.Race){
      return new ListHorseInfo(
          race: null,
          races: [new Race(name: "Race number 1"), new Race(name: "Race number 2")],
          name: "Race"
      );
    }
    if (type == _HorseInfoCardChoice.Nationality){
      return new ListHorseInfo(
          race: null,
          races: [new Nationality(name: "Nat number 1"), new Nationality(name: "Nat number 2")],
          name: "Nationality"
      );
    }

    return new _DisplayHorseInfoWidget(type, title: title, nbLine: nbLine);
  }
}

/// State for [DisplayHorseInfoWidget] widgets.
class _DisplayHorseInfoWidget extends State<DisplayHorseInfoWidget> {
  _DisplayHorseInfoWidget(this.type, {this.title, this.nbLine});

  final _HorseInfoCardChoice type; // Type of information we want to retreive

  final String title; // Text field title
  int nbLine; // Number line for the text field
  final TextEditingController _controller = new TextEditingController(); // Text field composent

  bool isMal = false;
  DateTime birthdate;

  Widget _makeTextField(){
    return new TextField(
      controller: _controller,
      maxLines: nbLine,
      decoration: new InputDecoration(
          labelText: this.title,
          hintText: 'Type something'
      ),
    );
  }
  void onChanged(DateTime value) {
    setState(() {
      this.birthdate = value;
    });
  }

  Widget _datePicker(){
    final DateTime dateTime = new DateTime.now();
    final date = new DateTime(dateTime.year, dateTime.month, dateTime.day);
    final time = new TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);

    return new FlatButton(
      child: new Text(
          null == this.birthdate ? "Clicker pour entrer la date de naissance" : "Anniversaire: " + this.birthdate.day.toString() + "/" + this.birthdate.month.toString() + "/" + this.birthdate.year.toString()
      ),
      onPressed: () {
        showDatePicker(
            context: context, initialDate: date, firstDate: new DateTime(1950, 1, 1), lastDate: new DateTime.now()
        )
            .then((DateTime value) {
          if (null != value) {
            onChanged(new DateTime(value.year, value.month, value.day, time.hour,time.minute));
          }
        });
      },
    );
  }

  void _handleSwitch(bool newValue) {
    setState(() {
      isMal = newValue;
    });
  }

  Widget _maleOrFemal(){
    return new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          new Text(isMal ? "Male" : "Femelle"),
          new Switch(
              value: isMal,
              onChanged: _handleSwitch
          )]
    );
  }

  @override
  Widget build(BuildContext context) {
    if (type == _HorseInfoCardChoice.Date)
      return _datePicker();
    if (type == _HorseInfoCardChoice.Sexe)
      return _maleOrFemal();
    return _makeTextField();
  }
}
