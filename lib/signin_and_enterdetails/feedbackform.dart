import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class FeedBackForm extends StatelessWidget {

  final RoundedLoadingButtonController _feedController = new RoundedLoadingButtonController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messgaeController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar (
        title: Row(
          children: <Widget>[
            Text ( 'Feedback',
            ),
            SizedBox(width: 8,),
            Icon(Icons.rate_review)
          ],
        ) ,
        centerTitle: true ,
      ) ,
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      labelText: 'Name',
                    ),
                    controller: _nameController,
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.subject),
                      labelText: 'Subject',
                    ),
                    controller: _subjectController,
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.message),
                      labelText: 'Message',
                    ),
                    controller: _messgaeController,
                    maxLines: 5,
                  ),
                  new Container(
                      padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                      child: new RoundedLoadingButton(
                        controller: _feedController,
                        color: Colors.red,
                        child: const Text('Submit' , style: TextStyle(color: Colors.white , fontSize: 16 , fontWeight: FontWeight.w700),),
                        onPressed: (){
                          _sendmail(context);
                        } ,
                      )),
                ],
              ))),
    );
  }

  Future<void> _sendmail(BuildContext context) async {
    _feedController.reset ();


    if(_nameController.text=="" || _messgaeController.text==""){
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Name and Message can't be empty"),
            duration: Duration(seconds: 3),
          ));
    }
    else {
      print ( 'Ho rha ha' );
      final Email email = Email (
        body: _messgaeController.text + '\n\n' +'From \n ${_nameController.text}' ,
        subject: _subjectController.text ,
        recipients: ['chatpad14@gmail.com'] ,
      );

      String platformResponse;

      await FlutterEmailSender.send ( email );
      platformResponse = 'success';
      print ( 'done' );
      _nameController.clear ( );
      _subjectController.clear ( );
      _messgaeController.clear ( );
    }
  }
}
