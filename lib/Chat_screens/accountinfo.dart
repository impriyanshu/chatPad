
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chattingapp/Modles/reciever.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_fonts/google_fonts.dart';

import '../customs/avatar.dart';


class AccountPage extends StatefulWidget {
AccountPage({@required this.job , @required this.group});
final Reciever job ;
final bool group ;

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {



  @override
  Widget build(BuildContext context) {
    print(widget.job.nameof);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('User Info' , style: TextStyle(letterSpacing: 2 , fontWeight: FontWeight.w600),),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(200),
          child: _buildUserInfo(),
        ),
      ),
      body: SingleChildScrollView(child: _bodyinfo()),
    );
  }

  Widget _buildUserInfo() {
    print(widget.job.isgroup);
    return Column(
      children: <Widget>[
        Avatar(
          name : widget.job.nameof.toString(),
          photoUrl: '${widget.job.urlof}',
          radius: 65,
          group : widget.group
        ),
        SizedBox(height: 6),
          Text(
            widget.job.nameof.toString(),
            style: GoogleFonts.acme(
              textStyle : TextStyle(
                  letterSpacing: 1,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.indigo[50]
              ),
            ),
          ),
        SizedBox(height: 15),
      ],
    );
  }

 Widget _bodyinfo() {
    return Column(
      children: <Widget>[
        SizedBox(height: 45,),
        Center(child: Text(
          'Username',
          style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w700),
        )),
        SizedBox(height: 5,),
        Text(
          widget.job.usernameof.toString(),
          style: GoogleFonts.acme(
            textStyle : TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.indigo[800],
            ),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 25,),
        Center(child: Text(
          'Status',
          style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w700),
        )),
        SizedBox(height: 5,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: AutoSizeText(
                widget.job.statusof != null ? widget.job.statusof : "",
                style: GoogleFonts.acme(
                  textStyle : TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.indigo[800],
                  ),
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 25,),
        Row(
          children: <Widget>[
            SizedBox(
              width: 200,
            ),
            Icon(Icons.email),
            SizedBox(
              width: 95,
            ),
            widget.job.emailof == null ? Text('') : IconButton( icon: Icon(Icons.send , color: Colors.red,),
                onPressed: () =>mailsend(widget.job.emailof))
          ],
        ),
        SizedBox(height: 5,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: AutoSizeText(
                widget.job.emailof != null ? widget.job.emailof : "",
                style: GoogleFonts.acme(
                  textStyle : TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.indigo[800],
                  ),
                ),
                minFontSize: 10,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
 }

  mailsend(String emailof) async {
    final Email email = Email (
      recipients: [emailof] ,
    );

    String platformResponse;

    await FlutterEmailSender.send ( email );

  }
}
